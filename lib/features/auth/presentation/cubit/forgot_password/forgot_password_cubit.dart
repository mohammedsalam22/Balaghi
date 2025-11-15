import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository repository;

  ForgotPasswordCubit({required this.repository}) : super(ForgotPasswordInitial());

  Future<void> forgotPassword({required String email}) async {
    emit(ForgotPasswordLoading());

    final request = ForgotPasswordRequest(email: email);

    final result = await repository.forgotPassword(request);

    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (response) => emit(ForgotPasswordSuccess(response.message)),
    );
  }
}

