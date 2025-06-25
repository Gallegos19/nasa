import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/core/usecases/usecase.dart';
import 'package:nasa_explorer/core/utils/either.dart';
import 'package:nasa_explorer/di/injection_container.dart';

import '../../../../core/errors/failures.dart';
import '../entities/mars_photo_entity.dart';
import '../repositories/mars_photo_repository.dart';

@lazySingleton
class GetLatestMarsPhotosUseCase implements UseCase<List<MarsPhotoEntity>, String> {
  final MarsPhotoRepository _repository;

  GetLatestMarsPhotosUseCase(this._repository);

  @override
  Future<Either<Failure, List<MarsPhotoEntity>>> call(String roverName) async {
    return await _repository.getLatestPhotos(roverName);
  }
}