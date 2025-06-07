import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/either.dart'; // AÑADIDO
import '../../domain/entities/neo_entity.dart';
import '../../domain/repositories/neo_repository.dart';
import '../datasource/neo_remote_datasource.dart';
import '../datasource/neo_local_datasource.dart';

class NeoRepositoryImpl implements NeoRepository {
  final NeoRemoteDataSource _remoteDataSource;
  final NeoLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  NeoRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<NeoEntity>>> getTodayNeos() async {
    const cacheKey = 'today_neos';
    
    if (await _networkInfo.isConnected) {
      try {
        final remoteNeos = await _remoteDataSource.getTodayNeos();
        await _localDataSource.cacheNeos(cacheKey, remoteNeos);
        return Right(remoteNeos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localNeos = await _localDataSource.getCachedNeos(cacheKey);
        if (localNeos != null && localNeos.isNotEmpty) {
          return Right(localNeos);
        } else {
          return const Left(CacheFailure('No cached NEO data available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<NeoEntity>>> getNeosByDateRange(
    String startDate,
    String endDate,
  ) async {
    final cacheKey = 'neos_${startDate}_$endDate';
    
    if (await _networkInfo.isConnected) {
      try {
        final remoteNeos = await _remoteDataSource.getNeosByDateRange(startDate, endDate);
        await _localDataSource.cacheNeos(cacheKey, remoteNeos);
        return Right(remoteNeos);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localNeos = await _localDataSource.getCachedNeos(cacheKey);
        if (localNeos != null && localNeos.isNotEmpty) {
          return Right(localNeos);
        } else {
          return const Left(CacheFailure('No cached NEO data available for this range'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, NeoEntity>> getNeoById(String neoId) async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteNeo = await _remoteDataSource.getNeoById(neoId);
        await _localDataSource.cacheNeoById(neoId, remoteNeo);
        return Right(remoteNeo);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localNeo = await _localDataSource.getCachedNeoById(neoId);
        if (localNeo != null) {
          return Right(localNeo);
        } else {
          return const Left(CacheFailure('No cached NEO details available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}