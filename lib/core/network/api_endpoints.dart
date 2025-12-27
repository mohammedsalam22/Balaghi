import 'dart:io';

class ApiEndpoints {
  static String get baseUrl {
    if (Platform.isAndroid) {
      //change this to your ipV4
      return 'https://10.218.59.81:5001';
    } else {
      // Backend serves files (uploads) via HTTPS as well.
      return 'https://localhost:5001';
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

  // Complaints endpoints
  static const String complaints = '/api/complaints';
  static String complaintStatus(String complaintId) =>
      '/api/complaints/$complaintId/status';

  /// Fetch complaints for the current user (new backend endpoint).
  static const String getComplaintsByUser =
      '/api/complaints/GetComplaintsByUser';

  /// Submit a complaint (Citizen/User) - multipart/form-data.
  static const String submitComplaint = '/api/complaints/submit';

  /// Government agency picklist (for selecting `agencyId`).
  static const String governmentAgenciesPicklist =
      '/api/GovernmentAgency/picklist';

  /// Resolve a relative backend file path (e.g. `/uploads/...`) to a full URL.
  static String resolveUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    // Backend returns URLs like "/uploads/...".
    // Build it as: API_BASE + url  (example: https://localhost:5001 + /uploads/x.png)
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    if (trimmed.startsWith('/')) {
      return '$base$trimmed';
    }
    return '$base/$trimmed';
  }

  // Helper method to replace path parameters
  static String replacePathParams(String path, Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }
}
