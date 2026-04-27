import 'dart:async';
import 'package:flutter/foundation.dart';

import '../locator.dart';
import '../data/database/app_database.dart';
import './sync_service.dart';

class SyncStatus {
  final bool isSyncing;
  final bool isOnline;
  final DateTime? lastPullAt;
  final DateTime? lastPushAt;
  final String? lastError;
  final DateTime? lastErrorAt;

  const SyncStatus({
    required this.isSyncing,
    required this.isOnline,
    this.lastPullAt,
    this.lastPushAt,
    this.lastError,
    this.lastErrorAt,
  });

  factory SyncStatus.initial() => const SyncStatus(
        isSyncing: false,
        isOnline: false,
      );

  SyncStatus copyWith({
    bool? isSyncing,
    bool? isOnline,
    DateTime? lastPullAt,
    DateTime? lastPushAt,
    String? lastError,
    DateTime? lastErrorAt,
    bool clearError = false,
  }) {
    return SyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      isOnline: isOnline ?? this.isOnline,
      lastPullAt: lastPullAt ?? this.lastPullAt,
      lastPushAt: lastPushAt ?? this.lastPushAt,
      lastError: clearError ? null : (lastError ?? this.lastError),
      lastErrorAt: clearError ? null : (lastErrorAt ?? this.lastErrorAt),
    );
  }
}

class AutoSyncService {
  final AppDatabase _db = getIt<AppDatabase>();
  final SyncService _sync = getIt<SyncService>();
  final ValueNotifier<SyncStatus> status =
      ValueNotifier<SyncStatus>(SyncStatus.initial());

  StreamSubscription? _productsSub;
  StreamSubscription? _inventorySub;
  StreamSubscription? _customersSub;
  StreamSubscription? _salesSub;
  StreamSubscription? _categoriesSub;

  Timer? _productsDebounce;
  Timer? _inventoryDebounce;
  Timer? _batchesDebounce;
  Timer? _customersDebounce;
  Timer? _salesDebounce;
  Timer? _categoriesDebounce;

  Timer? _heartbeat;

  bool _pendingProducts = false;
  bool _pendingInventory = false;
  bool _pendingBatches = false;
  bool _pendingCustomers = false;
  bool _pendingSales = false;
  bool _pendingCategories = false;
  bool _pendingPull = false;

  bool _isSyncing = false;
  bool _wasOnline = false;
  DateTime? _lastPullAt;
  DateTime? _lastPushAt;
  static const Duration _pullInterval = Duration(seconds: 60);

  void start() {
    _productsSub = _db.select(_db.products).watch().listen((_) {
      _scheduleProductsSync();
    });

    _inventorySub = _db.select(_db.productBatches).watch().listen((_) {
      _scheduleInventorySync();
      _scheduleBatchesSync();
    });

    _customersSub = _db.select(_db.customers).watch().listen((_) {
      _scheduleCustomersSync();
    });

    _salesSub = _db.select(_db.salesBills).watch().listen((_) {
      _scheduleSalesSync();
    });

    _categoriesSub = _db.select(_db.categories).watch().listen((_) {
      _scheduleCategoriesSync();
    });

    _heartbeat = Timer.periodic(const Duration(seconds: 10), (_) {
      _tick();
    });

    _tick();
  }

  void dispose() {
    _productsSub?.cancel();
    _inventorySub?.cancel();
    _customersSub?.cancel();
    _salesSub?.cancel();
    _categoriesSub?.cancel();
    _productsDebounce?.cancel();
    _inventoryDebounce?.cancel();
    _batchesDebounce?.cancel();
    _customersDebounce?.cancel();
    _salesDebounce?.cancel();
    _categoriesDebounce?.cancel();
    _heartbeat?.cancel();
  }

  void _scheduleProductsSync() {
    _pendingProducts = true;
    _productsDebounce?.cancel();
    _productsDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  void _scheduleInventorySync() {
    _pendingInventory = true;
    _inventoryDebounce?.cancel();
    _inventoryDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  void _scheduleBatchesSync() {
    _pendingBatches = true;
    _batchesDebounce?.cancel();
    _batchesDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  void _scheduleCustomersSync() {
    _pendingCustomers = true;
    _customersDebounce?.cancel();
    _customersDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  void _scheduleSalesSync() {
    _pendingSales = true;
    _salesDebounce?.cancel();
    _salesDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  void _scheduleCategoriesSync() {
    _pendingCategories = true;
    _categoriesDebounce?.cancel();
    _categoriesDebounce = Timer(const Duration(seconds: 2), _tick);
  }

  Future<void> _tick() async {
    if (_isSyncing) return;
    _isSyncing = true;
    status.value = status.value.copyWith(isSyncing: true);

    try {
      final online = await _sync.checkOnline();
      if (!online) {
        _wasOnline = false;
        status.value = status.value.copyWith(isOnline: false);
        return;
      }

      status.value = status.value.copyWith(isOnline: true);

      if (!_wasOnline) {
        _pendingProducts = true;
        _pendingInventory = true;
        _pendingBatches = true;
        _pendingCustomers = true;
        _pendingSales = true;
        _pendingCategories = true;
        _pendingPull = true;
      }

      _wasOnline = true;

      final now = DateTime.now();
      final shouldPull =
          _pendingPull ||
          _lastPullAt == null ||
          now.difference(_lastPullAt!) >= _pullInterval;
      if (shouldPull) {
        await _sync.pullCustomers();
        await _sync.pullSalesTransactions();
        _pendingPull = false;
        _lastPullAt = DateTime.now();
        status.value = status.value.copyWith(
          lastPullAt: _lastPullAt,
          clearError: true,
        );
      }

      bool didPush = false;
      if (_pendingProducts) {
        await _sync.pushProducts();
        _pendingProducts = false;
        didPush = true;
      }
      if (_pendingInventory) {
        await _sync.pushInventory();
        _pendingInventory = false;
        didPush = true;
      }
      if (_pendingBatches) {
        await _sync.pushBatches();
        _pendingBatches = false;
        didPush = true;
      }
      if (_pendingCustomers) {
        await _sync.pushCustomers();
        _pendingCustomers = false;
        didPush = true;
      }
      if (_pendingSales) {
        await _sync.pushSalesTransactions();
        _pendingSales = false;
        didPush = true;
      }
      if (_pendingCategories) {
        await _sync.pushCategories();
        _pendingCategories = false;
        didPush = true;
      }
      if (didPush) {
        _lastPushAt = DateTime.now();
        status.value = status.value.copyWith(
          lastPushAt: _lastPushAt,
          clearError: true,
        );
      }
    } catch (e) {
      // Leave pending flags true for retry.
      status.value = status.value.copyWith(
        lastError: e.toString(),
        lastErrorAt: DateTime.now(),
      );
    } finally {
      _isSyncing = false;
      status.value = status.value.copyWith(isSyncing: false);
    }
  }
}
