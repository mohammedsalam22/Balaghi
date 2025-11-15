import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository repository;

  ResetPasswordCubit({required this.repository}) : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());

    final request = ResetPasswordRequest(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    final result = await repository.resetPassword(request);

    result.fold(
      (failure) => emit(ResetPasswordError(failure.message)),
      (response) => emit(ResetPasswordSuccess(response.message)),
    );
  }
}

