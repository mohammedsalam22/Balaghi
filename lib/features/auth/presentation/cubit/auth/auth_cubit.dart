import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../../data/models/auth_models.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/entities/auth_entity.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final SecureStorageService storageService;

  AuthCubit({required this.repository, required this.storageService})
    : super(AuthInitial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated on app start
  Future<void> _checkAuthStatus() async {
    emit(AuthLoading());
    final token = await storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      // User has a token, consider them authenticated
      // You might want to validate the token with the server
      emit(AuthAuthenticated(AuthEntity(accessToken: token)));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final request = LoginRequest(email: email, password: password);
    final result = await repository.login(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authEntity) => emit(AuthAuthenticated(authEntity)),
    );
  }

  /// Register user
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    final request = RegisterRequest(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    final result = await repository.register(request);

    result.fold(
      (failure) {
        // Check if it's a validation failure with array of errors
        if (failure is ValidationFailure) {
          final errors = _parseValidationErrors(failure.message);
          emit(AuthError(failure.message, validationErrors: errors));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (response) {
        // Registration successful, emit registered state
        emit(AuthRegistered(response.message));
      },
    );
  }

  /// Verify OTP after registration
  Future<void> verifyOtp({required String email, required String code}) async {
    emit(AuthLoading());

    final request = VerifyOtpRequest(email: email, code: code);
    final result = await repository.verifyOtp(request);

    result.fold((failure) => emit(AuthError(failure.message)), (response) {
      // OTP verified successfully
      emit(AuthOtpVerified(response.message));
      // After a delay, go back to unauthenticated (user needs to login)
      Future.delayed(const Duration(seconds: 1), () {
        emit(AuthUnauthenticated());
      });
    });
  }

  List<String>? _parseValidationErrors(String message) {
    // Try to parse validation errors if they're in array format
    try {
      if (message.startsWith('[') && message.endsWith(']')) {
        // This would need proper JSON parsing in real implementation
        return [message];
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    final result = await repository.refreshToken();

    result.fold((failure) {
      // If refresh fails, logout user
      logout();
    }, (authEntity) => emit(AuthAuthenticated(authEntity)));
  }

  /// Logout user
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await repository.logout();

    result.fold((failure) {
      // Even if logout fails on server, clear local data
      emit(AuthUnauthenticated());
    }, (_) => emit(AuthUnauthenticated()));
  }

  /// Forgot password
  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());

    final request = ForgotPasswordRequest(email: email);
    final result = await repository.forgotPassword(request);

    result.fold((failure) => emit(AuthError(failure.message)), (response) {
      emit(AuthPasswordResetSent(response.message));
      // After showing message, go back to unauthenticated
      Future.delayed(const Duration(seconds: 1), () {
        emit(AuthUnauthenticated());
      });
    });
  }

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    final request = ResetPasswordRequest(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    final result = await repository.resetPassword(request);

    result.fold((failure) => emit(AuthError(failure.message)), (response) {
      emit(AuthPasswordResetSuccess(response.message));
      // After showing message, go back to unauthenticated (user needs to login)
      Future.delayed(const Duration(seconds: 1), () {
        emit(AuthUnauthenticated());
      });
    });
  }
}
