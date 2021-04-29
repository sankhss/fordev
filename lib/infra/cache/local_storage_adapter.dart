import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({this.secureStorage});

  @override
  Future<void> saveSecure({String key, String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }

}