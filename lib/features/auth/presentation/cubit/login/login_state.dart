import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthEntity authEntity;

  const LoginSuccess(this.authEntity);

  @override
  List<Object?> get props => [authEntity];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

