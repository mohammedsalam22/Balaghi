import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository repository;

  VerifyOtpCubit({required this.repository}) : super(VerifyOtpInitial());

  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    emit(VerifyOtpLoading());

    final request = VerifyOtpRequest(
      email: email,
      code: code,
    );

    final result = await repository.verifyOtp(request);

    result.fold(
      (failure) => emit(VerifyOtpError(failure.message)),
      (response) => emit(VerifyOtpSuccess(response.message)),
    );
  }
}

