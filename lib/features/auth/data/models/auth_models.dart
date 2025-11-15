// Request Models
class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class VerifyOtpRequest {
  final String email;
  final String code;

  VerifyOtpRequest({required this.email, required this.code});

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'token': token,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}

// Response Models
class RegisterResponse {
  final String message;
  final bool success;

  RegisterResponse({required this.message, required this.success});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }
}

class LoginResponse {
  final String accessToken;

  LoginResponse({required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(accessToken: json['accessToken'] as String);
  }
}

class RefreshTokenResponse {
  final String accessToken;
  final String expiresAt;

  RefreshTokenResponse({required this.accessToken, required this.expiresAt});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['accessToken'] as String,
      expiresAt: json['expiresAt'] as String,
    );
  }
}

class MessageResponse {
  final String message;

  MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(message: json['message'] as String);
  }
}
