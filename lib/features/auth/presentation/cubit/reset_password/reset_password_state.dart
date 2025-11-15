import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  final List<String>? validationErrors;

  const ResetPasswordError(this.message, {this.validationErrors});

  @override
  List<Object?> get props => [message, validationErrors];
}

