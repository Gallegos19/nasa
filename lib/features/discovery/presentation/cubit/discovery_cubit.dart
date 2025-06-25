import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/features/discovery/domain/usescases/get_neos_by_date_range_usecase.dart';
import 'package:nasa_explorer/features/discovery/domain/usescases/get_today_neos_usecase.dart';
import '../../domain/entities/neo_entity.dart';

// States
abstract class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
}

class DiscoveryInitial extends DiscoveryState {}

class DiscoveryLoading extends DiscoveryState {}

class DiscoveryLoaded extends DiscoveryState {
  final List<NeoEntity> neos;
  final bool isFromCache;

  const DiscoveryLoaded({
    required this.neos,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [neos, isFromCache];
}

class DiscoveryError extends DiscoveryState {
  final String message;

  const DiscoveryError(this.message);

  @override
  List<Object?> get props => [message];
}

class DiscoveryRefreshing extends DiscoveryLoaded {
  const DiscoveryRefreshing({
    required List<NeoEntity> neos,
    bool isFromCache = false,
  }) : super(neos: neos, isFromCache: isFromCache);
}

@injectable
class DiscoveryCubit extends Cubit<DiscoveryState> {
  final GetTodayNeosUseCase _getTodayNeosUseCase;
  final GetNeosByDateRangeUseCase _getNeosByDateRangeUseCase;

  DiscoveryCubit({
    required GetTodayNeosUseCase getTodayNeosUseCase,
    required GetNeosByDateRangeUseCase getNeosByDateRangeUseCase,
  })  : _getTodayNeosUseCase = getTodayNeosUseCase,
        _getNeosByDateRangeUseCase = getNeosByDateRangeUseCase,
        super(DiscoveryInitial());

  Future<void> loadTodayNeos() async {
    emit(DiscoveryLoading());
    
    final result = await _getTodayNeosUseCase.call();
    
    result.fold(
      (failure) => emit(DiscoveryError(failure.message)),
      (neos) => emit(DiscoveryLoaded(neos: neos)),
    );
  }

  Future<void> loadNeosByDateRange(String startDate, String endDate) async {
    emit(DiscoveryLoading());
    
    final result = await _getNeosByDateRangeUseCase.call(
      NeoDateRangeParams(startDate: startDate, endDate: endDate),
    );
    
    result.fold(
      (failure) => emit(DiscoveryError(failure.message)),
      (neos) => emit(DiscoveryLoaded(neos: neos)),
    );
  }

  Future<void> refresh() async {
    if (state is DiscoveryLoaded) {
      final currentState = state as DiscoveryLoaded;
      emit(DiscoveryRefreshing(neos: currentState.neos));
      
      final result = await _getTodayNeosUseCase.call();
      
      result.fold(
        (failure) => emit(DiscoveryError(failure.message)),
        (neos) => emit(DiscoveryLoaded(neos: neos)),
      );
    } else {
      await loadTodayNeos();
    }
  }
}