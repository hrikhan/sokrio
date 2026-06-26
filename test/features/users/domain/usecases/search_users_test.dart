import 'package:flutter_test/flutter_test.dart';
import 'package:sokrio_task/features/users/domain/entities/user.dart';
import 'package:sokrio_task/features/users/domain/usecases/search_users.dart';

void main() {
  late SearchUsers searchUsers;

  setUp(() {
    searchUsers = SearchUsers();
  });

  final testUsers = [
    User(
      id: 1,
      email: 'john@example.com',
      firstName: 'John',
      lastName: 'Doe',
      avatar: '',
      phone: '123',
    ),
    User(
      id: 2,
      email: 'jane@example.com',
      firstName: 'Jane',
      lastName: 'Smith',
      avatar: '',
      phone: '456',
    ),
  ];

  test('should return all users if query is empty', () {
    final result = searchUsers(users: testUsers, query: '');
    expect(result, testUsers);
  });

  test('should filter users by first name case-insensitively', () {
    final result = searchUsers(users: testUsers, query: 'john');
    expect(result.length, 1);
    expect(result.first.id, 1);
  });

  test('should filter users by email', () {
    final result = searchUsers(users: testUsers, query: 'jane@example.com');
    expect(result.length, 1);
    expect(result.first.id, 2);
  });

  test('should trim search query to handle leading and trailing spaces', () {
    final result = searchUsers(users: testUsers, query: '  smith  ');
    expect(result.length, 1);
    expect(result.first.id, 2);
  });
}
