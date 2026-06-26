import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/core/error/error.dart';
import 'package:sokrio_task/core/network/network_info.dart';
import 'package:sokrio_task/features/users/data/datasources/user_local_datasource.dart';
import 'package:sokrio_task/features/users/data/datasources/user_remote_datasource.dart';
import 'package:sokrio_task/features/users/data/models/user_model.dart';
import 'package:sokrio_task/features/users/data/repositories/user_repository_impl.dart';

class FakeUserRemoteDataSource implements UserRemoteDataSource {
  ({List<UserModel> users, int totalPages})? mockResponse;
  bool isGetUsersCalled = false;

  @override
  Future<({List<UserModel> users, int totalPages})> getUsers(int page, {int perPage = 10}) async {
    isGetUsersCalled = true;
    if (mockResponse != null) return mockResponse!;
    throw ServerException(message: 'Remote failure');
  }

  @override
  Future<UserModel> getUserDetail(int id) async {
    throw UnimplementedError();
  }
}

class FakeUserLocalDataSource implements UserLocalDataSource {
  List<UserModel> cachedUsers = [];
  bool isCacheUsersCalled = false;
  bool lastClearExistingVal = false;

  @override
  Future<void> cacheUsers(List<UserModel> usersToCache, {bool clearExisting = false}) async {
    isCacheUsersCalled = true;
    lastClearExistingVal = clearExisting;
    if (clearExisting) {
      cachedUsers = List.from(usersToCache);
    } else {
      cachedUsers.addAll(usersToCache);
    }
  }

  @override
  Future<List<UserModel>> getLastUsers() async {
    if (cachedUsers.isNotEmpty) return cachedUsers;
    throw CacheException('No cached users');
  }
}

class FakeNetworkInfo implements NetworkInfo {
  bool isConnectedValue = true;

  @override
  Future<bool> get isConnected async => isConnectedValue;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => const Stream.empty();
}

void main() {
  late UserRepositoryImpl repository;
  late FakeUserRemoteDataSource remoteDataSource;
  late FakeUserLocalDataSource localDataSource;
  late FakeNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = FakeUserRemoteDataSource();
    localDataSource = FakeUserLocalDataSource();
    networkInfo = FakeNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  final testUserModel = UserModel(
    id: 1,
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    avatar: '',
    phone: '123',
  );

  group('getUsers', () {
    test('should check if the device is online and fetch remote data', () async {
      networkInfo.isConnectedValue = true;
      remoteDataSource.mockResponse = (users: [testUserModel], totalPages: 1);

      final result = await repository.getUsers(1);

      expect(remoteDataSource.isGetUsersCalled, isTrue);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (data) {
          expect(data.users.length, 1);
          expect(data.users.first.id, 1);
        },
      );
    });

    test('should cache data locally when the call to remote data source is successful', () async {
      networkInfo.isConnectedValue = true;
      remoteDataSource.mockResponse = (users: [testUserModel], totalPages: 1);

      await repository.getUsers(1);

      expect(localDataSource.isCacheUsersCalled, isTrue);
      expect(localDataSource.cachedUsers.length, 1);
      expect(localDataSource.cachedUsers.first.id, 1);
    });

    test('should return ServerFailure when call to remote data source fails', () async {
      networkInfo.isConnectedValue = true;
      remoteDataSource.mockResponse = null;

      final result = await repository.getUsers(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('should fail'),
      );
    });

    test('should return local cached data when device is offline', () async {
      networkInfo.isConnectedValue = false;
      localDataSource.cachedUsers = [testUserModel];

      final result = await repository.getUsers(1);

      expect(remoteDataSource.isGetUsersCalled, isFalse);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (data) {
          expect(data.users.length, 1);
          expect(data.users.first.id, 1);
        },
      );
    });

    test('should clear existing cache on page 1 when online', () async {
      networkInfo.isConnectedValue = true;
      remoteDataSource.mockResponse = (users: [testUserModel], totalPages: 1);

      await repository.getUsers(1); // Page 1

      expect(localDataSource.lastClearExistingVal, isTrue);
    });

    test('should NOT clear existing cache on page 2 when online', () async {
      networkInfo.isConnectedValue = true;
      remoteDataSource.mockResponse = (users: [testUserModel], totalPages: 1);

      await repository.getUsers(2); // Page 2

      expect(localDataSource.lastClearExistingVal, isFalse);
    });
  });
}
