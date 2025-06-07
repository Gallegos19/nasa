import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/mars_photo_entity.dart';

abstract class MarsPhotoRepository {
  Future<Either<Failure, List<MarsPhotoEntity>>> getLatestPhotos(String roverName);
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosBySol(String roverName, int sol);
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosByEarthDate(String roverName, String earthDate);
  Future<Either<Failure, List<MarsPhotoEntity>>> getPhotosByCamera(String roverName, String camera, {int? sol});
}