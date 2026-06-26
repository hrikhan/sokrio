import 'package:dartz/dartz.dart';
import '../../../../core/error/error.dart';
import '../../../../core/network/network.dart';
import '../../domain/users_domain.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ({List<User> users, int totalPages})>> getUsers(int page, {int perPage = 10}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUsers(page, perPage: perPage);
        await localDataSource.cacheUsers(result.users, clearExisting: page == 1);
        return Right((users: result.users, totalPages: result.totalPages));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error occurred'));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final localUsers = await localDataSource.getLastUsers();
        // Offline returns all loaded users on one page, stopping infinite scroll
        return Right((users: localUsers, totalPages: 1));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getUserDetail(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUserDetail(id);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error occurred'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final cachedUsers = await localDataSource.getLastUsers();
        final user = cachedUsers.firstWhere(
          (u) => u.id == id,
          orElse: () => throw CacheException('User details not found in cache'),
        );
        return Right(user);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }
}
