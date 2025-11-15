import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await remoteDataSource.register(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> verifyOtp(
    VerifyOtpRequest request,
  ) async {
    try {
      final response = await remoteDataSource.verifyOtp(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(LoginRequest request) async {
    try {
      final response = await remoteDataSource.login(request);
      await storageService.saveAccessToken(response.accessToken);
      final authEntity = AuthEntity(accessToken: response.accessToken);
      return Right(authEntity);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> refreshToken() async {
    try {
      final response = await remoteDataSource.refreshToken();
      await storageService.saveAccessToken(response.accessToken);
      final authEntity = AuthEntity(
        accessToken: response.accessToken,
        expiresAt: response.expiresAt,
      );
      return Right(authEntity);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> logout() async {
    try {
      final response = await remoteDataSource.logout();
      await storageService.clearAll();
      return Right(response);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await remoteDataSource.forgotPassword(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MessageResponse>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await remoteDataSource.resetPassword(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(_mapNetworkExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Failure _mapNetworkExceptionToFailure(NetworkException exception) {
    switch (exception.statusCode) {
      case 400:
        return ValidationFailure(exception.message);
      case 401:
        return AuthenticationFailure(exception.message);
      case 403:
        return AuthorizationFailure(exception.message);
      case 404:
        return NotFoundFailure(exception.message);
      case 409:
        return ValidationFailure(exception.message);
      case 429:
        return ServerFailure(exception.message);
      case 500:
        return ServerFailure(exception.message);
      default:
        if (exception.message.contains('timeout') ||
            exception.message.contains('connection')) {
          return NetworkFailure(exception.message);
        }
        return UnknownFailure(exception.message);
    }
  }
}
