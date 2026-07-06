import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Simple API client wrapper for the backend.
class ApiClient {
  ApiClient._internal() : _dio = _createDio();

  static Dio _createDio() {
    // ----------------------------------------------------------------------
    // 1. 设置 Base URL
    // 使用你 Render 部署成功的生产环境地址
    // ----------------------------------------------------------------------
    const String baseUrl = 'https://supply-chain-api-uw0j.onrender.com';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,

        // ----------------------------------------------------------------------
        // 2. 关键修改：增加超时时间
        // Render 免费版在休眠后唤醒需要约 30-50 秒。
        // 设置为 60 秒可以防止 App 在第一次启动时报错 "Connection Timeout"。
        // ----------------------------------------------------------------------
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),

        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (obj) {
          if (kDebugMode) {
            print('[API] $obj');
          }
        },
      ),
    );

    return dio;
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  final Dio _dio;

  Dio get client => _dio;

  /// Get the current base URL (useful for debugging)
  String get baseUrl => _dio.options.baseUrl;
}
