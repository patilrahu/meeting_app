import 'package:meeting_app/feature/users/data/datasource/userdatasource.dart';
import 'package:meeting_app/feature/users/domain/entities/userdata_entity.dart';
import 'package:meeting_app/feature/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserdataEntity> getUserData() async {
    final response = await remoteDataSource.getUsers();
    return response;
  }
}
