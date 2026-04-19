
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'auth_token';

  static Future<void> saveToken(String token) {
    return _storage.write(key: _key, value: token);
  }

  static Future<String?> getToken() {
    return _storage.read(key: _key);
  }

  static Future<void> clear() {
    return _storage.delete(key: _key);
  }
}