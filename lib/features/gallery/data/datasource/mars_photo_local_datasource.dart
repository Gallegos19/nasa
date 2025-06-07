import 'package:nasa_explorer/features/gallery/data/models/mars_photo.dart';

import '../../../../core/services/cache_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class MarsPhotoLocalDataSource {
  Future<List<MarsPhotoModel>?> getCachedPhotos(String key);
  Future<void> cachePhotos(String key, List<MarsPhotoModel> photos);
  Future<void> clearCache();
}

class MarsPhotoLocalDataSourceImpl implements MarsPhotoLocalDataSource {
  final CacheService _cacheService;

  MarsPhotoLocalDataSourceImpl(this._cacheService);

  @override
  Future<List<MarsPhotoModel>?> getCachedPhotos(String key) async {
    try {
      final cachedData = await _cacheService.get<List<dynamic>>(key);
      if (cachedData != null) {
        return cachedData.map((json) => MarsPhotoModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached Mars photos: $e');
    }
  }

  @override
  Future<void> cachePhotos(String key, List<MarsPhotoModel> photos) async {
    try {
      final jsonList = photos.map((photo) => photo.toJson()).toList();
      await _cacheService.set(
        key,
        jsonList,
        duration: const Duration(hours: AppConstants.defaultCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache Mars photos: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _cacheService.clear();
    } catch (e) {
      throw CacheException('Failed to clear Mars photos cache: $e');
    }
  }
}