import '../models/user_model.dart';

//abtract class of the user remote data source
abstract class UserRemoteDataSource {
  Future<({List<UserModel> users, int totalPages})> getUsers(
    int page, {
    int perPage = 10,
  });
  Future<UserModel> getUserDetail(int id);
}
