class AppConstants {
  // App Info
  static const String appName = 'NASA Explorer';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Explora el cosmos con datos oficiales de NASA';
  
  // Cache Keys
  static const String apodCacheKey = 'apod_cache';
  static const String marsPhotosCacheKey = 'mars_photos_cache';
  static const String neoCacheKey = 'neo_cache';
  static const String planetaryCacheKey = 'planetary_cache';
  
  // Cache Duration (in hours)
  static const int defaultCacheDuration = 24;
  static const int shortCacheDuration = 1;
  static const int longCacheDuration = 168; // 1 week
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Mars Rovers - Lista actualizada
  static const List<String> marsRovers = [
    'curiosity',
    'perseverance', 
    'opportunity',
    'spirit',
    'ingenuity'
  ];

  // Mars Rover Status
  static const Map<String, String> roverStatus = {
    'curiosity': 'active',
    'perseverance': 'active',
    'opportunity': 'complete',
    'spirit': 'complete',
    'ingenuity': 'active',
  };

  // Mars Cameras
  static const Map<String, List<String>> roverCameras = {
    'curiosity': ['FHAZ', 'RHAZ', 'MAST', 'CHEMCAM', 'MAHLI', 'MARDI'],
    'perseverance': ['EDL_RUCAM', 'EDL_RDCAM', 'EDL_DDCAM', 'EDL_PUCAM1', 'EDL_PUCAM2', 'NAVCAM_LEFT', 'NAVCAM_RIGHT', 'MCZ_RIGHT', 'MCZ_LEFT', 'FRONT_HAZCAM_LEFT_A', 'FRONT_HAZCAM_RIGHT_A', 'REAR_HAZCAM_LEFT', 'REAR_HAZCAM_RIGHT', 'SKYCAM', 'SHERLOC_WATSON'],
    'opportunity': ['FHAZ', 'RHAZ', 'NAVCAM', 'PANCAM', 'MINITES'],
    'spirit': ['FHAZ', 'RHAZ', 'NAVCAM', 'PANCAM', 'MINITES'],
  };

  // Date Limits
  static final DateTime firstApodDate = DateTime(1995, 6, 16);
  static final DateTime maxFutureDate = DateTime.now().add(const Duration(days: 7));

  // URL Patterns
  static const String nasaBaseUrl = 'https://api.nasa.gov';
  static const String nasaWebsiteUrl = 'https://www.nasa.gov';
  static const String apodWebsiteUrl = 'https://apod.nasa.gov/apod/';

  // Error Messages
  static const String networkError = 'Error de conexión. Verifica tu internet.';
  static const String serverError = 'Error del servidor. Intenta más tarde.';
  static const String cacheError = 'Error al acceder a datos guardados.';
  static const String generalError = 'Algo salió mal. Intenta nuevamente.';

  // Success Messages  
  static const String dataLoaded = 'Datos cargados exitosamente';
  static const String dataRefreshed = 'Datos actualizados';
  static const String offlineMode = 'Modo offline activado';
}

