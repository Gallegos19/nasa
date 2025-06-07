import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';
import 'package:nasa_explorer/features/home/data/datasource/apod_local_datasource.dart';
import 'package:nasa_explorer/features/home/data/datasource/apod_remote_datasource.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';


class ApodRepositoryImpl implements ApodRepository {
  final ApodRemoteDataSource _remoteDataSource;
  final ApodLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ApodRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, ApodEntity>> getTodayApod() async {
    const cacheKey = 'today_apod';
    
    if (await _networkInfo.isConnected) {
      try {
        final remoteApod = await _remoteDataSource.getTodayApod();
        await _localDataSource.cacheApod(cacheKey, remoteApod);
        return Right(remoteApod);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localApod = await _localDataSource.getCachedApod(cacheKey);
        if (localApod != null) {
          return Right(localApod);
        } else {
          return const Left(CacheFailure('No cached data available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, ApodEntity>> getApodByDate(String date) async {
    final cacheKey = 'apod_$date';
    
    if (await _networkInfo.isConnected) {
      try {
        final remoteApod = await _remoteDataSource.getApodByDate(date);
        await _localDataSource.cacheApod(cacheKey, remoteApod);
        return Right(remoteApod);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localApod = await _localDataSource.getCachedApod(cacheKey);
        if (localApod != null) {
          return Right(localApod);
        } else {
          return const Left(CacheFailure('No cached data available for this date'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<ApodEntity>>> getApodRange(
    String startDate,
    String endDate,
  ) async {
    final cacheKey = 'apod_range_${startDate}_$endDate';
    
    if (await _networkInfo.isConnected) {
      try {
        final remoteApods = await _remoteDataSource.getApodRange(startDate, endDate);
        await _localDataSource.cacheApodList(cacheKey, remoteApods);
        return Right(remoteApods);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localApods = await _localDataSource.getCachedApodList(cacheKey);
        if (localApods.isNotEmpty) {
          return Right(localApods);
        } else {
          return const Left(CacheFailure('No cached data available for this range'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}