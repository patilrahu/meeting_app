import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/feature/auth/domain/usecases/login_usecase.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_event.dart';
import 'package:meeting_app/feature/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final response = await loginUseCase.call(
      event.username,
      event.email,
      event.password,
    );

    if (response.token != '') {
      emit(AuthSuccess(response.token));
    } else {
      emit(
        AuthFailure(
          response.errorMessage ?? 'Invalid username, email, or password',
        ),
      );
    }
  }
}
