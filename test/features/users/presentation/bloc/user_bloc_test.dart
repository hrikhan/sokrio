import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/core/error/error.dart';
import 'package:sokrio_task/features/users/domain/entities/user.dart';
import 'package:sokrio_task/features/users/domain/repositories/user_repository.dart';
import 'package:sokrio_task/features/users/domain/usecases/get_users.dart';
import 'package:sokrio_task/features/users/domain/usecases/search_users.dart';
import 'package:sokrio_task/features/users/presentation/bloc/user_bloc.dart';
import 'package:sokrio_task/features/users/presentation/bloc/user_event.dart';
import 'package:sokrio_task/features/users/presentation/bloc/user_state.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<Either<Failure, ({List<User> users, int totalPages})>> getUsers(int page, {int perPage = 10}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserDetail(int id) async {
    throw UnimplementedError();
  }
}

class FakeGetUsers extends GetUsers {
  FakeGetUsers() : super(FakeUserRepository());

  Either<Failure, ({List<User> users, int totalPages})>? mockResponse;

  @override
  Future<Either<Failure, ({List<User> users, int totalPages})>> call(int page, {int perPage = 10}) async {
    return mockResponse ?? const Left(ServerFailure('Default Fail'));
  }
}

void main() {
  late FakeGetUsers fakeGetUsers;
  late SearchUsers searchUsers;
  late UserBloc userBloc;

  setUp(() {
    fakeGetUsers = FakeGetUsers();
    searchUsers = SearchUsers();
    userBloc = UserBloc(
      getUsers: fakeGetUsers,
      searchUsers: searchUsers,
    );
  });

  tearDown(() {
    userBloc.close();
  });

  final testUser = User(
    id: 1,
    email: 'test@test.com',
    firstName: 'John',
    lastName: 'Doe',
    avatar: 'avatar_url',
    phone: '1234567890',
  );

  test('initial state should be UserInitial', () {
    expect(userBloc.state, const UserInitial());
  });

  test('should emit [UserLoading, UserLoaded] when GetUsersEvent is successful', () async {
    fakeGetUsers.mockResponse = Right((users: [testUser], totalPages: 2));

    expectLater(
      userBloc.stream,
      emitsInOrder([
        const UserLoading(),
        UserLoaded(
          users: [testUser],
          filteredUsers: [testUser],
          searchQuery: '',
          isLoadingMore: false,
          hasReachedMax: false,
          nextPage: 2,
        ),
      ]),
    );

    userBloc.add(const GetUsersEvent());
  });

  test('should emit [UserLoading, UserError] when GetUsersEvent fails', () async {
    fakeGetUsers.mockResponse = const Left(ServerFailure('Connection Timeout'));

    expectLater(
      userBloc.stream,
      emitsInOrder([
        const UserLoading(),
        const UserError('Connection Timeout'),
      ]),
    );

    userBloc.add(const GetUsersEvent());
  });

  test('should filter users correctly on SearchUsersEvent', () async {
    final user1 = testUser;
    final user2 = User(
      id: 2,
      email: 'jane@test.com',
      firstName: 'Jane',
      lastName: 'Smith',
      avatar: 'avatar_url',
      phone: '0987654321',
    );

    fakeGetUsers.mockResponse = Right((users: [user1, user2], totalPages: 1));
    
    // Load users first
    userBloc.add(const GetUsersEvent());
    await expectLater(
      userBloc.stream,
      emitsThrough(isA<UserLoaded>()),
    );

    // Now search for "Jane"
    userBloc.add(const SearchUsersEvent('Jane'));

    await expectLater(
      userBloc.stream,
      emitsThrough(
        predicate<UserState>((state) {
          if (state is UserLoaded) {
            return state.filteredUsers.length == 1 && state.filteredUsers.first.id == 2;
          }
          return false;
        }),
      ),
    );
  });
}
