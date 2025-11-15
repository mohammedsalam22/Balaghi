import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthEntity authEntity;

  const AuthAuthenticated(this.authEntity);

  @override
  List<Object?> get props => [authEntity];
}

class AuthUnauthenticated extends AuthState {}

class AuthRegistered extends AuthState {
  final String message;

  const AuthRegistered(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthOtpVerified extends AuthState {
  final String message;

  const AuthOtpVerified(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  final String message;

  const AuthPasswordResetSent(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSuccess extends AuthState {
  final String message;

  const AuthPasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;
  final List<String>? validationErrors;

  const AuthError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}
