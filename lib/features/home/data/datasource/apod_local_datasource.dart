import '../../../../core/services/storage_service.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart' as error_exceptions;
import '../models/apod_model.dart';

abstract class ApodLocalDataSource {
  Future<ApodModel?> getCachedApod(String key);
  Future<void> cacheApod(String key, ApodModel apod);
  Future<List<ApodModel>> getCachedApodList(String key);
  Future<void> cacheApodList(String key, List<ApodModel> apods);
  Future<void> clearCache();
}

class ApodLocalDataSourceImpl implements ApodLocalDataSource {
  final CacheService _cacheService;

  ApodLocalDataSourceImpl(this._cacheService);

  @override
  Future<ApodModel?> getCachedApod(String key) async {
    try {
      final cachedData = await _cacheService.get<Map<String, dynamic>>(key);
      if (cachedData != null) {
        return ApodModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw error_exceptions.CacheException('Failed to get cached APOD: $e');
    }
  }

  @override
  Future<void> cacheApod(String key, ApodModel apod) async {
    try {
      await _cacheService.set(
        key,
        apod.toJson(),
        duration: const Duration(hours: AppConstants.defaultCacheDuration),
      );
    } catch (e) {
      throw error_exceptions.CacheException('Failed to cache APOD: $e');
    }
  }

  @override
  Future<List<ApodModel>> getCachedApodList(String key) async {
    try {
      final cachedData = await _cacheService.get<List<dynamic>>(key);
      if (cachedData != null) {
        return cachedData.map((json) => ApodModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw error_exceptions.CacheException('Failed to get cached APOD list: $e');
    }
  }

  @override
  Future<void> cacheApodList(String key, List<ApodModel> apods) async {
    try {
      final jsonList = apods.map((apod) => apod.toJson()).toList();
      await _cacheService.set(
        key,
        jsonList,
        duration: const Duration(hours: AppConstants.defaultCacheDuration),
      );
    } catch (e) {
      throw error_exceptions.CacheException('Failed to cache APOD list: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _cacheService.clear();
    } catch (e) {
      throw error_exceptions.CacheException('Failed to clear APOD cache: $e');
    }
  }
}
