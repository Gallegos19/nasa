import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/apod_entity.dart';

abstract class ApodRepository {
  Future<Either<Failure, ApodEntity>> getTodayApod();
  Future<Either<Failure, ApodEntity>> getApodByDate(String date);
  Future<Either<Failure, List<ApodEntity>>> getApodRange(String startDate, String endDate);
}