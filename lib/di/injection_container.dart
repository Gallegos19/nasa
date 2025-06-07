import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Core
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/cache_service.dart';
import '../core/navigation/cubit/navigation_cubit.dart';

// Home Feature
import '../features/home/data/datasource/apod_remote_datasource.dart';
import '../features/home/data/datasource/apod_local_datasource.dart';
import '../features/home/data/repositories/apod_repository_impl.dart';
import '../features/home/domain/repositories/apod_repository.dart';
import '../features/home/domain/usescases/get_today_apod_usecase.dart';
import '../features/home/domain/usescases/get_apod_by_date_usecase.dart';
import '../features/home/presentation/cubit/home_cubit.dart';

// Gallery Feature
import '../features/gallery/data/datasource/mars_photo_remote_datasource.dart';
import '../features/gallery/data/datasource/mars_photo_local_datasource.dart';
import '../features/gallery/data/repositories/mars_photo_repository_impl.dart';
import '../features/gallery/domain/repositories/mars_photo_repository.dart';
import '../features/gallery/domain/usescases/get_latest_mars_photos_usecase.dart';
import '../features/gallery/domain/usescases/get_mars_photos_by_sol_usecase.dart';
import '../features/gallery/presentation/cubit/gallery_cubit.dart';

// Discovery Feature
import '../features/discovery/data/datasource/neo_remote_datasource.dart';
import '../features/discovery/data/datasource/neo_local_datasource.dart';
import '../features/discovery/data/repositories/neo_repository_impl.dart';
import '../features/discovery/domain/repositories/neo_repository.dart';
import '../features/discovery/domain/usescases/get_today_neos_usecase.dart';
import '../features/discovery/domain/usescases/get_neos_by_date_range_usecase.dart';
import '../features/discovery/presentation/cubit/discovery_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // ========================
  // HOME FEATURE (APOD)
  // ========================
  
  // Cubit
  sl.registerFactory(() => HomeCubit(
    getTodayApodUseCase: sl(),
    getApodByDateUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetTodayApodUseCase(sl()));
  sl.registerLazySingleton(() => GetApodByDateUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ApodRepository>(() => ApodRepositoryImpl(
    sl(), // remote datasource
    sl(), // local datasource
    sl(), // network info
  ));

  // Data sources
  sl.registerLazySingleton<ApodRemoteDataSource>(() => ApodRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ApodLocalDataSource>(() => ApodLocalDataSourceImpl(sl()));

  // ========================
  // GALLERY FEATURE (MARS)
  // ========================
  
  // Cubit
  sl.registerFactory(() => GalleryCubit(
    getLatestPhotosUseCase: sl(),
    getPhotosBySolUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetLatestMarsPhotosUseCase(sl()));
  sl.registerLazySingleton(() => GetMarsPhotosBySolUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MarsPhotoRepository>(() => MarsPhotoRepositoryImpl(
    sl(), // remote datasource
    sl(), // local datasource
    sl(), // network info
  ));

  // Data sources
  sl.registerLazySingleton<MarsPhotoRemoteDataSource>(() => MarsPhotoRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MarsPhotoLocalDataSource>(() => MarsPhotoLocalDataSourceImpl(sl()));

  // ========================
  // DISCOVERY FEATURE (NEO)
  // ========================
  
  // Cubit
  sl.registerFactory(() => DiscoveryCubit(
    getTodayNeosUseCase: sl(),
    getNeosByDateRangeUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetTodayNeosUseCase(sl()));
  sl.registerLazySingleton(() => GetNeosByDateRangeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NeoRepository>(() => NeoRepositoryImpl(
    sl(), // remote datasource
    sl(), // local datasource
    sl(), // network info
  ));

  // Data sources
  sl.registerLazySingleton<NeoRemoteDataSource>(() => NeoRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NeoLocalDataSource>(() => NeoLocalDataSourceImpl(sl()));

  // ========================
  // NAVIGATION
  // ========================
  sl.registerFactory(() => NavigationCubit());

  //! Core
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => CacheService());

  //! External
  sl.registerLazySingleton(() => Connectivity());
}