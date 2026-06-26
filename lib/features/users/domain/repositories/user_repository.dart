import 'package:dartz/dartz.dart';
import '../../../../core/error/error.dart';
import '../entities/user.dart';

//repository abstract class of the user
abstract class UserRepository {
  Future<Either<Failure, ({List<User> users, int totalPages})>> getUsers(
    int page, {
    int perPage = 10,
  });
  Future<Either<Failure, User>> getUserDetail(int id);
}
