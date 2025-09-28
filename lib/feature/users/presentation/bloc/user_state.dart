import 'package:equatable/equatable.dart';
import 'package:meeting_app/feature/users/data/model/userdata_model.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserIntial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserResponse data;
  const UserSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class UserFailed extends UserState {
  final String error;
  const UserFailed(this.error);

  @override
  List<Object?> get props => [error];
}
