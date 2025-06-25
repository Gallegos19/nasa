import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/core/usecases/usecase.dart';
import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/mars_photo_entity.dart';
import '../repositories/mars_photo_repository.dart';

class MarsPhotosBySolParams {
  final String roverName;
  final int sol;

  MarsPhotosBySolParams({required this.roverName, required this.sol});
}

@lazySingleton
class GetMarsPhotosBySolUseCase implements UseCase<List<MarsPhotoEntity>, MarsPhotosBySolParams> {
  final MarsPhotoRepository _repository;

  GetMarsPhotosBySolUseCase(this._repository);

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> call(MarsPhotosBySolParams params) async {
    return await _repository.getPhotosBySol(params.roverName, params.sol);
  }
}