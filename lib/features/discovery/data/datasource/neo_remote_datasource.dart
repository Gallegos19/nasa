import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/neo_model.dart';

abstract class NeoRemoteDataSource {
  Future<List<NeoModel>> getTodayNeos();
  Future<List<NeoModel>> getNeosByDateRange(String startDate, String endDate);
  Future<NeoModel> getNeoById(String neoId);
}

class NeoRemoteDataSourceImpl implements NeoRemoteDataSource {
  final ApiClient _apiClient;

  NeoRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<NeoModel>> getTodayNeos() async {
    try {
      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final response = await _apiClient.get(
        '${ApiConfig.neoEndpoint}/feed',
        queryParameters: {
          'start_date': dateStr,
          'end_date': dateStr,
        },
      );
      
      final Map<String, dynamic> data = response.data;
      final Map<String, dynamic> nearEarthObjects = data['near_earth_objects'];
      
      final List<NeoModel> neos = [];
      for (final dateKey in nearEarthObjects.keys) {
        final List<dynamic> dateNeos = nearEarthObjects[dateKey];
        neos.addAll(dateNeos.map((json) => NeoModel.fromJson(json)));
      }
      
      return neos;
    } catch (e) {
      throw ServerException('Failed to fetch today\'s NEOs: $e');
    }
  }

  @override
  Future<List<NeoModel>> getNeosByDateRange(String startDate, String endDate) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.neoEndpoint}/feed',
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );
      
      final Map<String, dynamic> data = response.data;
      final Map<String, dynamic> nearEarthObjects = data['near_earth_objects'];
      
      final List<NeoModel> neos = [];
      for (final dateKey in nearEarthObjects.keys) {
        final List<dynamic> dateNeos = nearEarthObjects[dateKey];
        neos.addAll(dateNeos.map((json) => NeoModel.fromJson(json)));
      }
      
      return neos;
    } catch (e) {
      throw ServerException('Failed to fetch NEOs by date range: $e');
    }
  }

  @override
  Future<NeoModel> getNeoById(String neoId) async {
    try {
      final response = await _apiClient.get('${ApiConfig.neoEndpoint}/$neoId');
      return NeoModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to fetch NEO details: $e');
    }
  }
}