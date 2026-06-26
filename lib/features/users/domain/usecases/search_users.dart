import '../entities/user.dart';

//search users usecase
class SearchUsers {
  List<User> call({required List<User> users, required String query}) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return users;

    final lowercaseQuery = trimmedQuery.toLowerCase();
    return users.where((user) {
      return user.fullName.toLowerCase().contains(lowercaseQuery) ||
          user.email.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
