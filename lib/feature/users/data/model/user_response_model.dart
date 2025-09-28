import 'package:meeting_app/feature/users/data/model/userdata_model.dart';
import 'package:meeting_app/feature/users/domain/entities/userdata_entity.dart';

class UserResponseModel extends UserdataEntity {
  UserResponseModel({required super.userData, super.errorMessage});

  factory UserResponseModel.fromJson(Map<String, dynamic>? json) {
    return UserResponseModel(
      errorMessage: json?['error']?['error'] ?? '',
      userData: UserResponse.fromJson(json),
    );
  }
}
