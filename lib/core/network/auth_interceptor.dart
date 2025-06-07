import 'package:dio/dio.dart';
import '../config/api_config.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add API key to all requests
    options.queryParameters['api_key'] = ApiConfig.apiKey;
    super.onRequest(options, handler);
  }
}