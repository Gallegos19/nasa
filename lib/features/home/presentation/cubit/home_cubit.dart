import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:nasa_explorer/features/home/domain/usescases/get_apod_by_date_usecase.dart';
import 'package:nasa_explorer/features/home/domain/usescases/get_today_apod_usecase.dart';
import '../../domain/entities/apod_entity.dart';


// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final ApodEntity apod;
  final bool isFromCache;

  const HomeLoaded({
    required this.apod,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [apod, isFromCache];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeRefreshing extends HomeLoaded {
  const HomeRefreshing({
    required ApodEntity apod,
    bool isFromCache = false,
  }) : super(apod: apod, isFromCache: isFromCache);
}

// Cubit
@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetTodayApodUseCase _getTodayApodUseCase;
  final GetApodByDateUseCase _getApodByDateUseCase;

  HomeCubit({
    required GetTodayApodUseCase getTodayApodUseCase,
    required GetApodByDateUseCase getApodByDateUseCase,
  })  : _getTodayApodUseCase = getTodayApodUseCase,
        _getApodByDateUseCase = getApodByDateUseCase,
        super(HomeInitial());

  Future<void> loadTodayApod() async {
    emit(HomeLoading());
    
    final result = await _getTodayApodUseCase.call();
    
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (apod) => emit(HomeLoaded(apod: apod)),
    );
  }

  Future<void> loadApodByDate(String date) async {
    emit(HomeLoading());
    
    final result = await _getApodByDateUseCase.call(date);
    
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (apod) => emit(HomeLoaded(apod: apod)),
    );
  }

  Future<void> refreshApod() async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeRefreshing(apod: currentState.apod));
      
      final result = await _getTodayApodUseCase.call();
      
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (apod) => emit(HomeLoaded(apod: apod)),
      );
    } else {
      await loadTodayApod();
    }
  }
}
