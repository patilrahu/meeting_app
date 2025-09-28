import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String email;
  final String password;
  const LoginSubmitted(this.email, this.password, this.username);

  @override
  List<Object?> get props => [email, password, username];
}
