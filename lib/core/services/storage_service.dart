import 'package:shared_preferences/shared_preferences.dart';

//abstruct class off the storage service
abstract class StorageService {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

//implementation of the storage service
class StorageServiceImpl implements StorageService {
  final SharedPreferences _sharedPreferences;

  StorageServiceImpl(this._sharedPreferences);

  @override
  Future<bool> setString(String key, String value) async {
    return await _sharedPreferences.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }
}
