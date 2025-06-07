import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nasa_explorer/features/gallery/domain/usescases/get_latest_mars_photos_usecase.dart';
import 'package:nasa_explorer/features/gallery/domain/usescases/get_mars_photos_by_sol_usecase.dart';
import '../../domain/entities/mars_photo_entity.dart';

// States
abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<MarsPhotoEntity> photos;
  final String currentRover;
  final bool isFromCache;

  const GalleryLoaded({
    required this.photos,
    required this.currentRover,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [photos, currentRover, isFromCache];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}

class GalleryRefreshing extends GalleryLoaded {
  const GalleryRefreshing({
    required List<MarsPhotoEntity> photos,
    required String currentRover,
    bool isFromCache = false,
  }) : super(photos: photos, currentRover: currentRover, isFromCache: isFromCache);
}

// Cubit
class GalleryCubit extends Cubit<GalleryState> {
  final GetLatestMarsPhotosUseCase _getLatestPhotosUseCase;
  final GetMarsPhotosBySolUseCase _getPhotosBySolUseCase;

  String _currentRover = 'curiosity';

  GalleryCubit({
    required GetLatestMarsPhotosUseCase getLatestPhotosUseCase,
    required GetMarsPhotosBySolUseCase getPhotosBySolUseCase,
  })  : _getLatestPhotosUseCase = getLatestPhotosUseCase,
        _getPhotosBySolUseCase = getPhotosBySolUseCase,
        super(GalleryInitial());

  String get currentRover => _currentRover;

  Future<void> loadLatestPhotos({String roverName = 'curiosity'}) async {
    _currentRover = roverName;
    emit(GalleryLoading());
    
    final result = await _getLatestPhotosUseCase.call(roverName);
    
    result.fold(
      (failure) => emit(GalleryError(failure.message)),
      (photos) => emit(GalleryLoaded(photos: photos, currentRover: roverName)),
    );
  }

  Future<void> loadPhotosBySol(int sol, {String? roverName}) async {
    final rover = roverName ?? _currentRover;
    emit(GalleryLoading());
    
    final result = await _getPhotosBySolUseCase.call(
      MarsPhotosBySolParams(roverName: rover, sol: sol),
    );
    
    result.fold(
      (failure) => emit(GalleryError(failure.message)),
      (photos) => emit(GalleryLoaded(photos: photos, currentRover: rover)),
    );
  }

  Future<void> changeRover(String roverName) async {
    if (_currentRover != roverName) {
      await loadLatestPhotos(roverName: roverName);
    }
  }

  Future<void> refresh() async {
    if (state is GalleryLoaded) {
      final currentState = state as GalleryLoaded;
      emit(GalleryRefreshing(
        photos: currentState.photos,
        currentRover: currentState.currentRover,
      ));
      
      await loadLatestPhotos(roverName: currentState.currentRover);
    } else {
      await loadLatestPhotos();
    }
  }
}