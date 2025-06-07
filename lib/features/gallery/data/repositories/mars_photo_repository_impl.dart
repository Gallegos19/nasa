import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';
import 'package:nasa_explorer/features/gallery/data/datasource/mars_photo_local_datasource.dart';
import 'package:nasa_explorer/features/gallery/data/datasource/mars_photo_remote_datasource.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/mars_photo_entity.dart';
import '../../domain/repositories/mars_photo_repository.dart';


class MarsPhotoRepositoryImpl implements MarsPhotoRepository {
  final MarsPhotoRemoteDataSource _remoteDataSource;
  final MarsPhotoLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  MarsPhotoRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> getLatestPhotos(String roverName) async {
    final cacheKey = 'latest_photos_$roverName';
    
    if (await _networkInfo.isConnected) {
      try {
        final remotePhotos = await _remoteDataSource.getLatestPhotos(roverName);
        await _localDataSource.cachePhotos(cacheKey, remotePhotos);
        return Right(remotePhotos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPhotos = await _localDataSource.getCachedPhotos(cacheKey);
        if (localPhotos != null && localPhotos.isNotEmpty) {
          return Right(localPhotos);
        } else {
          return const Left(CacheFailure('No cached photos available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosBySol(
    String roverName,
    int sol,
  ) async {
    final cacheKey = 'photos_${roverName}_sol_$sol';
    
    if (await _networkInfo.isConnected) {
      try {
        final remotePhotos = await _remoteDataSource.getPhotosBySol(roverName, sol);
        await _localDataSource.cachePhotos(cacheKey, remotePhotos);
        return Right(remotePhotos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPhotos = await _localDataSource.getCachedPhotos(cacheKey);
        if (localPhotos != null && localPhotos.isNotEmpty) {
          return Right(localPhotos);
        } else {
          return const Left(CacheFailure('No cached photos available for this sol'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosByEarthDate(
    String roverName,
    String earthDate,
  ) async {
    final cacheKey = 'photos_${roverName}_date_$earthDate';
    
    if (await _networkInfo.isConnected) {
      try {
        final remotePhotos = await _remoteDataSource.getPhotosByEarthDate(roverName, earthDate);
        await _localDataSource.cachePhotos(cacheKey, remotePhotos);
        return Right(remotePhotos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPhotos = await _localDataSource.getCachedPhotos(cacheKey);
        if (localPhotos != null && localPhotos.isNotEmpty) {
          return Right(localPhotos);
        } else {
          return const Left(CacheFailure('No cached photos available for this date'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosByCamera(
    String roverName,
    String camera, {
    int? sol,
  }) async {
    final cacheKey = 'photos_${roverName}_camera_${camera}_sol_$sol';
    
    if (await _networkInfo.isConnected) {
      try {
        final remotePhotos = await _remoteDataSource.getPhotosByCamera(
          roverName,
          camera,
          sol: sol,
        );
        await _localDataSource.cachePhotos(cacheKey, remotePhotos);
        return Right(remotePhotos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localPhotos = await _localDataSource.getCachedPhotos(cacheKey);
        if (localPhotos != null && localPhotos.isNotEmpty) {
          return Right(localPhotos);
        } else {
          return const Left(CacheFailure('No cached photos available for this camera'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
