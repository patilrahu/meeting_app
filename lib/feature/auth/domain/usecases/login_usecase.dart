import 'package:meeting_app/feature/auth/domain/entities/user_entity.dart';
import 'package:meeting_app/feature/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String username, String email, String password) {
    return repository.login(username, email, password);
  }
}
