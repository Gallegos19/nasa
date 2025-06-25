import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/features/gallery/data/models/mars_photo.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';

abstract class MarsPhotoRemoteDataSource {
  Future<List<MarsPhotoModel>> getLatestPhotos(String roverName);
  Future<List<MarsPhotoModel>> getPhotosBySol(String roverName, int sol);
  Future<List<MarsPhotoModel>> getPhotosByEarthDate(String roverName, String earthDate);
  Future<List<MarsPhotoModel>> getPhotosByCamera(String roverName, String camera, {int? sol});
}
@LazySingleton(as: MarsPhotoRemoteDataSource)
class MarsPhotoRemoteDataSourceImpl implements MarsPhotoRemoteDataSource {
  final ApiClient _apiClient;

  MarsPhotoRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<MarsPhotoModel>> getLatestPhotos(String roverName) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.marsRoverEndpoint}/$roverName/latest_photos',
      );
      
      final List<dynamic> photos = response.data['latest_photos'];
      return photos.map((json) => MarsPhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch latest Mars photos: $e');
    }
  }

  @override
  Future<List<MarsPhotoModel>> getPhotosBySol(String roverName, int sol) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.marsRoverEndpoint}/$roverName/photos',
        queryParameters: {'sol': sol.toString()},
      );
      
      final List<dynamic> photos = response.data['photos'];
      return photos.map((json) => MarsPhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch Mars photos by sol: $e');
    }
  }

  @override
  Future<List<MarsPhotoModel>> getPhotosByEarthDate(String roverName, String earthDate) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.marsRoverEndpoint}/$roverName/photos',
        queryParameters: {'earth_date': earthDate},
      );
      
      final List<dynamic> photos = response.data['photos'];
      return photos.map((json) => MarsPhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch Mars photos by date: $e');
    }
  }

  @override
  Future<List<MarsPhotoModel>> getPhotosByCamera(
    String roverName, 
    String camera, {
    int? sol,
  }) async {
    try {
      final queryParams = <String, String>{'camera': camera};
      if (sol != null) {
        queryParams['sol'] = sol.toString();
      }

      final response = await _apiClient.get(
        '${ApiConfig.marsRoverEndpoint}/$roverName/photos',
        queryParameters: queryParams,
      );
      
      final List<dynamic> photos = response.data['photos'];
      return photos.map((json) => MarsPhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch Mars photos by camera: $e');
    }
  }
}
