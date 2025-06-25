import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/core/utils/either.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/neo_entity.dart';
import '../repositories/neo_repository.dart';

class NeoDateRangeParams {
  final String startDate;
  final String endDate;

  NeoDateRangeParams({required this.startDate, required this.endDate});
}

@lazySingleton
class GetNeosByDateRangeUseCase implements UseCase<List<NeoEntity>, NeoDateRangeParams> {
  final NeoRepository _repository;

  GetNeosByDateRangeUseCase(this._repository);

  @override
  Future<Either<Failure, List<NeoEntity>>> call(NeoDateRangeParams params) async {
    return await _repository.getNeosByDateRange(params.startDate, params.endDate);
  }
}
