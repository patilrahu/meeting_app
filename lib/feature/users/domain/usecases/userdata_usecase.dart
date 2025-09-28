import 'package:meeting_app/feature/auth/domain/entities/user_entity.dart';
import 'package:meeting_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:meeting_app/feature/users/domain/entities/userdata_entity.dart';
import 'package:meeting_app/feature/users/domain/repositories/user_repository.dart';

class UserdataUsecase {
  final UserRepository repository;

  UserdataUsecase(this.repository);

  Future<UserdataEntity> call() {
    return repository.getUserData();
  }
}
