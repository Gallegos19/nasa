import 'package:nasa_explorer/core/usecases/usecase.dart';
import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/neo_entity.dart';
import '../repositories/neo_repository.dart';

class GetTodayNeosUseCase implements NoParamsUseCase<List<NeoEntity>> {
  final NeoRepository _repository;

  GetTodayNeosUseCase(this._repository);

  @override
  Future<Either<Failure, List<NeoEntity>>> call() async {
    return await _repository.getTodayNeos();
  }
}