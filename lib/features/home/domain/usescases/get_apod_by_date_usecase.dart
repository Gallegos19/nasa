import 'package:nasa_explorer/core/usecases/usecase.dart';
import 'package:nasa_explorer/core/utils/either.dart';

import '../../../../core/errors/failures.dart';
import '../entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class GetApodByDateUseCase implements UseCase<ApodEntity, String> {
  final ApodRepository _repository;

  GetApodByDateUseCase(this._repository);

  @override
  Future<Either<Failure, ApodEntity>> call(String date) async {
    return await _repository.getApodByDate(date);
  }
}
