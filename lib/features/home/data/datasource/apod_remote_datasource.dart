import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/apod_model.dart';

abstract class ApodRemoteDataSource {
  Future<ApodModel> getTodayApod();
  Future<ApodModel> getApodByDate(String date);
  Future<List<ApodModel>> getApodRange(String startDate, String endDate);
}
@LazySingleton(as: ApodRemoteDataSource)
class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  final ApiClient _apiClient;

  ApodRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ApodModel> getTodayApod() async {
    try {
      final response = await _apiClient.get(ApiConfig.apodEndpoint);
      return ApodModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to fetch today\'s APOD: $e');
    }
  }

  @override
  Future<ApodModel> getApodByDate(String date) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.apodEndpoint,
        queryParameters: {'date': date},
      );
      return ApodModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to fetch APOD for date $date: $e');
    }
  }

  @override
  Future<List<ApodModel>> getApodRange(String startDate, String endDate) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.apodEndpoint,
        queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        },
      );
      
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ApodModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch APOD range: $e');
    }
  }
}