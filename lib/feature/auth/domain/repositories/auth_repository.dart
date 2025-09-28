import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String email, String password);
}
