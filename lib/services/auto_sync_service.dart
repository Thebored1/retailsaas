import 'dart:async';

import '../locator.dart';
import '../data/database/app_database.dart';
import './sync_service.dart';

class AutoSyncService {
  final AppDatabase _db = getIt<AppDatabase>();
  final SyncService _sync = getIt<SyncService>();

  StreamSubscription? _productsSub;
  StreamSubscription? _inventorySub;
  StreamSubscription? _customersSub;
  StreamSubscription? _salesSub;

  Timer? _productsDebounce;
  Timer? _inventoryDebounce;
  Timer? _batchesDebounce;
  Timer? _customersDebounce;
  Timer? _salesDebounce;

  Timer? _heartbeat;

  bool _pendingProducts = false;
  bool _pendingInventory = false;
  bool _pendingBatches = false;
  bool _pendingCustomers = false;
  bool _pendingSales = false;
  bool _pendingPull = false;

  bool _isSyncing = false;
  bool _wasOnline = false;

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
    _productsDebounce?.cancel();
    _inventoryDebounce?.cancel();
    _batchesDebounce?.cancel();
    _customersDebounce?.cancel();
    _salesDebounce?.cancel();
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

  Future<void> _tick() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final online = await _sync.checkOnline();
      if (!online) {
        _wasOnline = false;
        return;
      }

      if (!_wasOnline) {
        _pendingProducts = true;
        _pendingInventory = true;
        _pendingBatches = true;
        _pendingCustomers = true;
        _pendingSales = true;
        _pendingPull = true;
      }

      _wasOnline = true;

      if (_pendingProducts) {
        await _sync.pushProducts();
        _pendingProducts = false;
      }
      if (_pendingInventory) {
        await _sync.pushInventory();
        _pendingInventory = false;
      }
      if (_pendingBatches) {
        await _sync.pushBatches();
        _pendingBatches = false;
      }
      if (_pendingCustomers) {
        await _sync.pushCustomers();
        _pendingCustomers = false;
      }
      if (_pendingSales) {
        await _sync.pushSalesTransactions();
        _pendingSales = false;
      }

      if (_pendingPull) {
        await _sync.pullCustomers();
        await _sync.pullSalesTransactions();
        _pendingPull = false;
      }
    } catch (_) {
      // Leave pending flags true for retry.
    } finally {
      _isSyncing = false;
    }
  }
}
