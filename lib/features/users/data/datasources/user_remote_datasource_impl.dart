import '../../../../core/error/error.dart';
import '../../../../core/network/network.dart';
import '../models/user_model.dart';
import 'user_remote_datasource.dart';

//user remote data source implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _dioClient;

  UserRemoteDataSourceImpl(this._dioClient);

  @override
  Future<({List<UserModel> users, int totalPages})> getUsers(
    int page, {
    int perPage = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        BaseEndpoints.users,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final List<dynamic> data = body['data'] as List<dynamic>;
        final int totalPages = body['total_pages'] as int? ?? 1;

        final users = data
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return (users: users, totalPages: totalPages);
      } else {
        throw ServerException(
          message: 'Failed to fetch users',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserDetail(int id) async {
    try {
      final response = await _dioClient.get('${BaseEndpoints.users}/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data as Map<String, dynamic>;
        final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else {
        throw ServerException(
          message: 'Failed to fetch user details',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
