import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists all configurable shop/sync settings to local storage.
class SettingsService {
  // Keys
  static const _keyShopName     = 'shop_name';
  static const _keyShopPhone    = 'shop_phone';
  static const _keyShopEmail    = 'shop_email';
  static const _keyShopGstin    = 'shop_gstin';
  static const _keyShopStateCode = 'shop_state_code';
  static const _keyAddrLine1    = 'addr_line1';
  static const _keyAddrLine2    = 'addr_line2';
  static const _keyAddrCity     = 'addr_city';
  static const _keyAddrState    = 'addr_state';
  static const _keyAddrPin      = 'addr_pin';
  static const _keyAddrCountry  = 'addr_country';
  static const _keyServerUrl    = 'server_url';
  static const _keyApiKey       = 'api_key';
  static const _keyDeliverySlots = 'delivery_slots';
  static const _keyRequireDeliveryPhoto = 'require_delivery_photo';

  // --- Getters ---

  Future<String> get shopName     async => (await _prefs()).getString(_keyShopName)    ?? '';
  Future<String> get shopPhone    async => (await _prefs()).getString(_keyShopPhone)   ?? '';
  Future<String> get shopEmail    async => (await _prefs()).getString(_keyShopEmail)   ?? '';
  Future<String> get shopGstin    async => (await _prefs()).getString(_keyShopGstin)   ?? '';
  Future<String> get shopStateCode async => (await _prefs()).getString(_keyShopStateCode) ?? '';
  Future<String> get addrLine1    async => (await _prefs()).getString(_keyAddrLine1)   ?? '';
  Future<String> get addrLine2    async => (await _prefs()).getString(_keyAddrLine2)   ?? '';
  Future<String> get addrCity     async => (await _prefs()).getString(_keyAddrCity)    ?? '';
  Future<String> get addrState    async => (await _prefs()).getString(_keyAddrState)   ?? '';
  Future<String> get addrPin      async => (await _prefs()).getString(_keyAddrPin)     ?? '';
  Future<String> get addrCountry  async => (await _prefs()).getString(_keyAddrCountry) ?? 'India';
  Future<String> get serverUrl    async => (await _prefs()).getString(_keyServerUrl)   ?? 'http://127.0.0.1:8000/api/v1';
  Future<String> get apiKey       async => (await _prefs()).getString(_keyApiKey)      ?? '';
  Future<bool> get requireDeliveryPhoto async =>
      (await _prefs()).getBool(_keyRequireDeliveryPhoto) ?? false;

  Future<List<Map<String, dynamic>>> loadDeliverySlots() async {
    final raw = (await _prefs()).getString(_keyDeliverySlots);
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  // --- Bulk loader (for pre-filling form) ---
  Future<Map<String, dynamic>> loadAll() async {
    final p = await _prefs();
    return {
      'shopName':    p.getString(_keyShopName)    ?? '',
      'shopPhone':   p.getString(_keyShopPhone)   ?? '',
      'shopEmail':   p.getString(_keyShopEmail)   ?? '',
      'shopGstin':   p.getString(_keyShopGstin)   ?? '',
      'shopStateCode': p.getString(_keyShopStateCode) ?? '',
      'addrLine1':   p.getString(_keyAddrLine1)   ?? '',
      'addrLine2':   p.getString(_keyAddrLine2)   ?? '',
      'addrCity':    p.getString(_keyAddrCity)    ?? '',
      'addrState':   p.getString(_keyAddrState)   ?? '',
      'addrPin':     p.getString(_keyAddrPin)     ?? '',
      'addrCountry': p.getString(_keyAddrCountry) ?? 'India',
      'serverUrl':   p.getString(_keyServerUrl)   ?? 'http://127.0.0.1:8000/api/v1',
      'apiKey':      p.getString(_keyApiKey)      ?? '',
      'requireDeliveryPhoto': p.getBool(_keyRequireDeliveryPhoto) ?? false,
    };
  }

  // --- Saver ---
  Future<void> saveAll({
    required String shopName,
    required String shopPhone,
    required String shopEmail,
    required String shopGstin,
    required String shopStateCode,
    required String addrLine1,
    required String addrLine2,
    required String addrCity,
    required String addrState,
    required String addrPin,
    required String addrCountry,
    required String serverUrl,
    required String apiKey,
    required bool requireDeliveryPhoto,
  }) async {
    final p = await _prefs();
    await p.setString(_keyShopName,    shopName);
    await p.setString(_keyShopPhone,   shopPhone);
    await p.setString(_keyShopEmail,   shopEmail);
    await p.setString(_keyShopGstin,   shopGstin);
    await p.setString(_keyShopStateCode, shopStateCode);
    await p.setString(_keyAddrLine1,   addrLine1);
    await p.setString(_keyAddrLine2,   addrLine2);
    await p.setString(_keyAddrCity,    addrCity);
    await p.setString(_keyAddrState,   addrState);
    await p.setString(_keyAddrPin,     addrPin);
    await p.setString(_keyAddrCountry, addrCountry);
    await p.setString(_keyServerUrl,   serverUrl);
    await p.setString(_keyApiKey,      apiKey);
    await p.setBool(_keyRequireDeliveryPhoto, requireDeliveryPhoto);
  }

  Future<void> saveDeliverySlots(List<Map<String, dynamic>> slots) async {
    final p = await _prefs();
    await p.setString(_keyDeliverySlots, jsonEncode(slots));
  }

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();
}
