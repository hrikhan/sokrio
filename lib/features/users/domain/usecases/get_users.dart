import 'package:dartz/dartz.dart';
import '../../../../core/error/error.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

// getusers usecase
class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, ({List<User> users, int totalPages})>> call(
    int page, {
    int perPage = 10,
  }) async {
    return await repository.getUsers(page, perPage: perPage);
  }
}
