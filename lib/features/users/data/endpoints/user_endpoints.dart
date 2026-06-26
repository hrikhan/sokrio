class UserEndpoints {
  UserEndpoints._();

  //user endpoints
  static const String listUsers = '/users';
  static String userDetail(int id) => '/users/$id';
}
