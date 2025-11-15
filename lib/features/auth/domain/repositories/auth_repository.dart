import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';
import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> register(RegisterRequest request);
  Future<Either<Failure, MessageResponse>> verifyOtp(VerifyOtpRequest request);
  Future<Either<Failure, AuthEntity>> login(LoginRequest request);
  Future<Either<Failure, AuthEntity>> refreshToken();
  Future<Either<Failure, MessageResponse>> logout();
  Future<Either<Failure, MessageResponse>> forgotPassword(
    ForgotPasswordRequest request,
  );
  Future<Either<Failure, MessageResponse>> resetPassword(
    ResetPasswordRequest request,
  );
}
