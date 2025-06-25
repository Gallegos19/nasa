import 'package:injectable/injectable.dart';

import '../../../../core/services/cache_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/neo_model.dart';

abstract class NeoLocalDataSource {
  Future<List<NeoModel>?> getCachedNeos(String key);
  Future<void> cacheNeos(String key, List<NeoModel> neos);
  Future<NeoModel?> getCachedNeoById(String neoId);
  Future<void> cacheNeoById(String neoId, NeoModel neo);
  Future<void> clearCache();
}

@LazySingleton(as: NeoLocalDataSource)
class NeoLocalDataSourceImpl implements NeoLocalDataSource {
  final CacheService _cacheService;

  NeoLocalDataSourceImpl(this._cacheService);

  @override
  Future<List<NeoModel>?> getCachedNeos(String key) async {
    try {
      final cachedData = await _cacheService.get<List<dynamic>>(key);
      if (cachedData != null) {
        return cachedData.map((json) => NeoModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached NEOs: $e');
    }
  }

  @override
  Future<void> cacheNeos(String key, List<NeoModel> neos) async {
    try {
      final jsonList = neos.map((neo) => neo.toJson()).toList();
      await _cacheService.set(
        key,
        jsonList,
        duration: const Duration(hours: AppConstants.shortCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache NEOs: $e');
    }
  }

  @override
  Future<NeoModel?> getCachedNeoById(String neoId) async {
    try {
      final cachedData = await _cacheService.get<Map<String, dynamic>>('neo_$neoId');
      if (cachedData != null) {
        return NeoModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached NEO: $e');
    }
  }

  @override
  Future<void> cacheNeoById(String neoId, NeoModel neo) async {
    try {
      await _cacheService.set(
        'neo_$neoId',
        neo.toJson(),
        duration: const Duration(hours: AppConstants.longCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache NEO: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _cacheService.clear();
    } catch (e) {
      throw CacheException('Failed to clear NEO cache: $e');
    }
  }
}