import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class ISecureStorage {
  Future<String?> get(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

// Secure storage config
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iOSOptions,
  );
});

final secureStorageProvider = Provider<ISecureStorage>((ref) {
  final secureStorage = ref.watch(flutterSecureStorageProvider);
  return SecureStorage(secureStorage);
});

final class SecureStorage implements ISecureStorage {
  final FlutterSecureStorage _secureStorage;

  SecureStorage(this._secureStorage);

  @override
  Future<String?> get(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (error) {
      rethrow;
    }
  }
}
