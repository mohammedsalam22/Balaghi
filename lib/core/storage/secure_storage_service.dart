import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: AppConstants.userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.userIdKey);
  }

  Future<void> deleteUserId() async {
    await _storage.delete(key: AppConstants.userIdKey);
  }

  // User Data
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: AppConstants.userDataKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userDataKey);
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: AppConstants.userDataKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
