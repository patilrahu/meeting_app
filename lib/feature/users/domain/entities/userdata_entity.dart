import 'package:meeting_app/feature/users/data/model/userdata_model.dart';

class UserdataEntity {
  final UserResponse userData;
  final String? errorMessage;

  UserdataEntity({required this.userData, this.errorMessage});
}
