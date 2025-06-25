import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/core/usecases/usecase.dart';
import 'package:nasa_explorer/core/utils/either.dart';

import '../../../../core/errors/failures.dart';
import '../entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

@lazySingleton
class GetTodayApodUseCase implements NoParamsUseCase<ApodEntity> {
  final ApodRepository _repository;

  GetTodayApodUseCase(this._repository);

  @override
  Future<Either<Failure, ApodEntity>> call() async {
    return await _repository.getTodayApod();
  }
}