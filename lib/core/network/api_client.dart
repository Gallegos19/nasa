import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/api_config.dart';
import '../config/app_config.dart';
import '../errors/exceptions.dart';
import '../network/auth_interceptor.dart';
import '../network/cache_interceptor.dart';
import 'network_info.dart';

@lazySingleton
class ApiClient {
  late final Dio _dio;
  final NetworkInfo _networkInfo;

  ApiClient(this._networkInfo) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConfig.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth Interceptor (adds API key)
    _dio.interceptors.add(AuthInterceptor());
    
    // Cache Interceptor (for offline support)
    _dio.interceptors.add(CacheInterceptor());

    // Logger (only in debug mode)
    if (AppConfig.enableNetworkLogging && AppConfig.isDebug) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: {'forceRefresh': forceRefresh}) ??
            Options(extra: {'forceRefresh': forceRefresh}),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerException('Connection timeout');
      
      case DioExceptionType.connectionError:
        return const ServerException('No internet connection');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = error.response?.data?['error']?['message'] ?? 
                       'Server error occurred';
        return ServerException('$message (Code: $statusCode)');
      
      case DioExceptionType.cancel:
        return const ServerException('Request cancelled');
      
      default:
        return const ServerException('Unexpected error occurred');
    }
  }
}