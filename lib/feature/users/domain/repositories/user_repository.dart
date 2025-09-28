import 'package:meeting_app/feature/users/domain/entities/userdata_entity.dart';

abstract class UserRepository {
  Future<UserdataEntity> getUserData();
}
