import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meeting_app/feature/users/data/model/userdata_model.dart';
import 'package:meeting_app/feature/users/domain/usecases/userdata_usecase.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_event.dart';
import 'package:meeting_app/feature/users/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserdataUsecase userUseCase;

  UserBloc(this.userUseCase) : super(UserIntial()) {
    on<GetUsers>(_getUsers);
  }
  Future<void> _getUsers(GetUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final response = await userUseCase.call();

      if (response.userData.data.isNotEmpty) {
        var box = Hive.box('usersBox');
        final userListJson = response.userData.data
            .map((user) => user.toJson())
            .toList();
        await box.put('users', userListJson);
        emit(UserSuccess(response.userData));
      } else {
        emit(UserFailed(response.errorMessage ?? 'Failed to fetch users'));
      }
    } catch (e) {
      var box = Hive.box('usersBox');
      final storedUsers = box.get('users', defaultValue: <Map>[]);
      if (storedUsers.isNotEmpty) {
        final cachedUserData = UserResponse(
          data: (storedUsers as List)
              .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
        emit(UserSuccess(cachedUserData));
      } else {
        emit(UserFailed('Failed to fetch users'));
      }
    }
  }
}
