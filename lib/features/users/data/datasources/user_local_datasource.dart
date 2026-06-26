import '../models/user_model.dart';

//abtract class of the user local data source
abstract class UserLocalDataSource {
  Future<void> cacheUsers(
    List<UserModel> usersToCache, {
    bool clearExisting = false,
  });
  Future<List<UserModel>> getLastUsers();
}
