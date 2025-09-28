import '../../domain/entities/user_entity.dart';

class LoginResponseModel extends UserEntity {
  LoginResponseModel({required super.token, super.errorMessage});

  factory LoginResponseModel.fromJson(Map<String, dynamic>? json) {
    return LoginResponseModel(
      token: json?['token'] ?? '',
      errorMessage: json?['error']?['error'] ?? '',
    );
  }
}
