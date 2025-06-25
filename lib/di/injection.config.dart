// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/navigation/cubit/navigation_cubit.dart' as _i315;
import '../core/network/api_client.dart' as _i510;
import '../core/network/network_info.dart' as _i6;
import '../core/services/cache_service.dart' as _i800;
import '../features/discovery/data/datasource/neo_local_datasource.dart'
    as _i766;
import '../features/discovery/data/datasource/neo_remote_datasource.dart'
    as _i4;
import '../features/discovery/data/repositories/neo_repository_impl.dart'
    as _i314;
import '../features/discovery/domain/repositories/neo_repository.dart'
    as _i1062;
import '../features/discovery/domain/usescases/get_neos_by_date_range_usecase.dart'
    as _i547;
import '../features/discovery/domain/usescases/get_today_neos_usecase.dart'
    as _i489;
import '../features/discovery/presentation/cubit/discovery_cubit.dart'
    as _i1065;
import '../features/gallery/data/datasource/mars_photo_local_datasource.dart'
    as _i841;
import '../features/gallery/data/datasource/mars_photo_remote_datasource.dart'
    as _i807;
import '../features/gallery/data/repositories/mars_photo_repository_impl.dart'
    as _i571;
import '../features/gallery/domain/repositories/mars_photo_repository.dart'
    as _i302;
import '../features/gallery/domain/usescases/get_latest_mars_photos_usecase.dart'
    as _i64;
import '../features/gallery/domain/usescases/get_mars_photos_by_sol_usecase.dart'
    as _i644;
import '../features/gallery/presentation/cubit/gallery_cubit.dart' as _i911;
import '../features/home/data/datasource/apod_local_datasource.dart' as _i593;
import '../features/home/data/datasource/apod_remote_datasource.dart' as _i167;
import '../features/home/data/repositories/apod_repository_impl.dart' as _i1051;
import '../features/home/domain/repositories/apod_repository.dart' as _i506;
import '../features/home/domain/usescases/get_apod_by_date_usecase.dart'
    as _i765;
import '../features/home/domain/usescases/get_today_apod_usecase.dart' as _i563;
import '../features/home/presentation/cubit/home_cubit.dart' as _i1017;
import 'modules/external_module.dart' as _i649;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalModule = _$ExternalModule();
    gh.factory<_i315.NavigationCubit>(() => _i315.NavigationCubit());
    gh.lazySingleton<_i800.CacheService>(() => _i800.CacheService());
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity);
    gh.lazySingleton<_i766.NeoLocalDataSource>(
        () => _i766.NeoLocalDataSourceImpl(gh<_i800.CacheService>()));
    gh.lazySingleton<_i841.MarsPhotoLocalDataSource>(
        () => _i841.MarsPhotoLocalDataSourceImpl(gh<_i800.CacheService>()));
    gh.lazySingleton<_i593.ApodLocalDataSource>(
        () => _i593.ApodLocalDataSourceImpl(gh<_i800.CacheService>()));
    gh.lazySingleton<_i6.NetworkInfo>(
        () => _i6.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i510.ApiClient>(
        () => _i510.ApiClient(gh<_i6.NetworkInfo>()));
    gh.lazySingleton<_i4.NeoRemoteDataSource>(
        () => _i4.NeoRemoteDataSourceImpl(gh<_i510.ApiClient>()));
    gh.lazySingleton<_i167.ApodRemoteDataSource>(
        () => _i167.ApodRemoteDataSourceImpl(gh<_i510.ApiClient>()));
    gh.lazySingleton<_i807.MarsPhotoRemoteDataSource>(
        () => _i807.MarsPhotoRemoteDataSourceImpl(gh<_i510.ApiClient>()));
    gh.lazySingleton<_i1062.NeoRepository>(() => _i314.NeoRepositoryImpl(
          gh<_i4.NeoRemoteDataSource>(),
          gh<_i766.NeoLocalDataSource>(),
          gh<_i6.NetworkInfo>(),
        ));
    gh.lazySingleton<_i547.GetNeosByDateRangeUseCase>(
        () => _i547.GetNeosByDateRangeUseCase(gh<_i1062.NeoRepository>()));
    gh.lazySingleton<_i489.GetTodayNeosUseCase>(
        () => _i489.GetTodayNeosUseCase(gh<_i1062.NeoRepository>()));
    gh.lazySingleton<_i302.MarsPhotoRepository>(
        () => _i571.MarsPhotoRepositoryImpl(
              gh<_i807.MarsPhotoRemoteDataSource>(),
              gh<_i841.MarsPhotoLocalDataSource>(),
              gh<_i6.NetworkInfo>(),
            ));
    gh.lazySingleton<_i64.GetLatestMarsPhotosUseCase>(
        () => _i64.GetLatestMarsPhotosUseCase(gh<_i302.MarsPhotoRepository>()));
    gh.lazySingleton<_i644.GetMarsPhotosBySolUseCase>(
        () => _i644.GetMarsPhotosBySolUseCase(gh<_i302.MarsPhotoRepository>()));
    gh.factory<_i911.GalleryCubit>(() => _i911.GalleryCubit(
          getLatestPhotosUseCase: gh<_i64.GetLatestMarsPhotosUseCase>(),
          getPhotosBySolUseCase: gh<_i644.GetMarsPhotosBySolUseCase>(),
        ));
    gh.lazySingleton<_i506.ApodRepository>(() => _i1051.ApodRepositoryImpl(
          gh<_i167.ApodRemoteDataSource>(),
          gh<_i593.ApodLocalDataSource>(),
          gh<_i6.NetworkInfo>(),
        ));
    gh.factory<_i1065.DiscoveryCubit>(() => _i1065.DiscoveryCubit(
          getTodayNeosUseCase: gh<_i489.GetTodayNeosUseCase>(),
          getNeosByDateRangeUseCase: gh<_i547.GetNeosByDateRangeUseCase>(),
        ));
    gh.lazySingleton<_i765.GetApodByDateUseCase>(
        () => _i765.GetApodByDateUseCase(gh<_i506.ApodRepository>()));
    gh.lazySingleton<_i563.GetTodayApodUseCase>(
        () => _i563.GetTodayApodUseCase(gh<_i506.ApodRepository>()));
    gh.factory<_i1017.HomeCubit>(() => _i1017.HomeCubit(
          getTodayApodUseCase: gh<_i563.GetTodayApodUseCase>(),
          getApodByDateUseCase: gh<_i765.GetApodByDateUseCase>(),
        ));
    return this;
  }
}

class _$ExternalModule extends _i649.ExternalModule {}
