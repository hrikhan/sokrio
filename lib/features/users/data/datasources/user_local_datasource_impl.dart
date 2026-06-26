import 'dart:convert';
import '../../../../core/error/error.dart';
import '../../../../core/services/services.dart';
import '../../../../core/utils/utils.dart';
import '../models/user_model.dart';
import 'user_local_datasource.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final StorageService _storageService;

  UserLocalDataSourceImpl(this._storageService);

  @override
  Future<void> cacheUsers(
    List<UserModel> usersToCache, {
    bool clearExisting = false,
  }) async {
    try {
      List<UserModel> existingUsers = [];
      if (!clearExisting) {
        try {
          existingUsers = await getLastUsers();
        } catch (_) {
          // No cache yet, start with empty list
        }
      }

      // Merge and remove duplicate IDs
      final mergedMap = {for (var user in existingUsers) user.id: user};
      for (var user in usersToCache) {
        mergedMap[user.id] = user;
      }
      final mergedList = mergedMap.values.toList();

      final List<Map<String, dynamic>> jsonList = mergedList
          .map((u) => u.toJson())
          .toList();
      final jsonString = json.encode(jsonList);
      final success = await _storageService.setString(
        StorageKeys.userCacheKey,
        jsonString,
      );
      if (!success) {
        throw CacheException('Failed to write user list');
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  //get last users from sharedpreference
  @override
  Future<List<UserModel>> getLastUsers() async {
    final jsonString = _storageService.getString(StorageKeys.userCacheKey);
    if (jsonString != null) {
      final List<dynamic> decodedList =
          json.decode(jsonString) as List<dynamic>;
      return decodedList
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw CacheException('No users found');
    }
  }
}
