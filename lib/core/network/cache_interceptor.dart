import 'package:dio/dio.dart';
import '../services/cache_service.dart';
import '../constants/app_constants.dart';

class CacheInterceptor extends Interceptor {
  final CacheService _cacheService = CacheService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final forceRefresh = options.extra['forceRefresh'] == true;
    
    if (!forceRefresh) {
      final cacheKey = _generateCacheKey(options);
      final cachedResponse = await _cacheService.get<Map<String, dynamic>>(cacheKey);
      
      if (cachedResponse != null) {
        // Return cached response
        final response = Response(
          requestOptions: options,
          data: cachedResponse,
          statusCode: 200,
        );
        handler.resolve(response);
        return;
      }
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Cache successful responses
    if (response.statusCode == 200 && response.data != null) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      await _cacheService.set(
        cacheKey,
        response.data,
        duration: const Duration(hours: AppConstants.defaultCacheDuration),
      );
    }
    
    super.onResponse(response, handler);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    return uri.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  }
}

