import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/neo_entity.dart';

abstract class NeoRepository {
  Future<Either<Failure, List<NeoEntity>>> getTodayNeos();
  Future<Either<Failure, List<NeoEntity>>> getNeosByDateRange(String startDate, String endDate);
  Future<Either<Failure, NeoEntity>> getNeoById(String neoId);
}