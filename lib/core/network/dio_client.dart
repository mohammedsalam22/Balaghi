import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'network_exceptions.dart';
import 'api_endpoints.dart';
import '../storage/secure_storage_service.dart';

class DioClient {
  late Dio _dio;
  final SecureStorageService _storageService;
  final CookieJar _cookieJar;

  DioClient({
    required SecureStorageService storageService,
    CookieJar? cookieJar,
  }) : _storageService = storageService,
       _cookieJar = cookieJar ?? CookieJar() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) {
          // Don't throw exception for redirects (3xx) - let Dio handle them
          return status! < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // For development: Allow self-signed certificates if using HTTPS
    if (kDebugMode && ApiEndpoints.baseUrl.startsWith('https://')) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    // Add cookie manager for HTTP-only cookies (refresh token)
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Add token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Debug logging for errors
          if (kDebugMode) {
            print('*** Dio Error ***');
            print('Type: ${error.type}');
            print('Message: ${error.message}');
            print('Response Status: ${error.response?.statusCode}');
            print('Response Data: ${error.response?.data}');
            print('Request Path: ${error.requestOptions.path}');
            print('Request Base URL: ${error.requestOptions.baseUrl}');
          }

          // Handle 401 - Try to refresh token
          if (error.response?.statusCode == 401) {
            try {
              final newToken = await _refreshToken();
              if (newToken != null) {
                // Retry the original request with new token
                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                final response = await _dio.request(
                  opts.path,
                  options: Options(method: opts.method, headers: opts.headers),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(response);
              }
            } catch (e) {
              // Refresh failed, clear tokens and reject
              await _storageService.clearAll();
            }
          }

          final networkException = NetworkException.fromDioError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: networkException,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );

    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final response = await _dio.post(ApiEndpoints.refreshToken);
      final accessToken = response.data['accessToken'] as String;
      await _storageService.saveAccessToken(accessToken);
      return accessToken;
    } catch (e) {
      return null;
    }
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
