import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exceptions.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<MessageResponse> verifyOtp(VerifyOtpRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<RefreshTokenResponse> refreshToken();
  Future<MessageResponse> logout();
  Future<MessageResponse> forgotPassword(ForgotPasswordRequest request);
  Future<MessageResponse> resetPassword(ResetPasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to register: ${e.toString()}');
    }
  }

  @override
  Future<MessageResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );
      return MessageResponse.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      // Check if response data is valid
      if (response.data == null) {
        throw NetworkException(
          message: 'Invalid response from server: response data is null',
        );
      }

      // Handle different response types
      Map<String, dynamic> responseData;
      if (response.data is Map<String, dynamic>) {
        responseData = response.data as Map<String, dynamic>;
      } else if (response.data is Map) {
        responseData = Map<String, dynamic>.from(response.data as Map);
      } else if (response.data is String) {
        // If response is a string, try to parse it as JSON
        throw NetworkException(
          message: 'Server returned unexpected string response. Expected JSON.',
        );
      } else {
        throw NetworkException(
          message: 'Unexpected response type: ${response.data.runtimeType}',
        );
      }

      return LoginResponse.fromJson(responseData);
    } on NetworkException {
      // Re-throw network exceptions as-is
      rethrow;
    } on DioException catch (e) {
      // Catch DioException and convert to NetworkException
      throw NetworkException.fromDioError(e);
    } catch (e) {
      // Catch any other exceptions
      throw NetworkException(message: 'Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<RefreshTokenResponse> refreshToken() async {
    try {
      final response = await dioClient.post(ApiEndpoints.refreshToken);
      return RefreshTokenResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        message: 'Failed to refresh token: ${e.toString()}',
      );
    }
  }

  @override
  Future<MessageResponse> logout() async {
    try {
      final response = await dioClient.post(ApiEndpoints.logout);
      return MessageResponse.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: 'Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<MessageResponse> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      return MessageResponse.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        message: 'Failed to send forgot password: ${e.toString()}',
      );
    }
  }

  @override
  Future<MessageResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );
      return MessageResponse.fromJson(response.data as Map<String, dynamic>);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        message: 'Failed to reset password: ${e.toString()}',
      );
    }
  }
}
