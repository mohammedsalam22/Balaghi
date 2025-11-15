import 'dart:io';

class ApiEndpoints {

  static String get baseUrl {
    if (Platform.isAndroid) {
//change this to your ipV4
      return 'https://10.161.102.81:5001';
    } else {
      return 'http://localhost:5001';
    }
  }

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String login = '/api/auth/login';
  static const String refreshToken = '/api/auth/refresh-token';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';



  // Helper method to replace path parameters
  static String replacePathParams(String path, Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }
}
