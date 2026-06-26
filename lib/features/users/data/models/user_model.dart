import '../../domain/entities/user.dart';

//model class of the user
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.avatar,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return UserModel(
      id: id,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      // Mocking phone as Reqres doesn't provide it
      phone:
          json['phone'] as String? ??
          '+1-555-01${id.toString().padLeft(2, '0')}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'phone': phone,
    };
  }
}
