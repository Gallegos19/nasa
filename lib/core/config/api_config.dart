class ApiConfig {
  static const String baseUrl = 'https://api.nasa.gov';
  static const String apiKey = 'NZ3qmdWLDeMzB4wgvfTWb8UPwub2hkoch66G0LPK'; 
  
  // Endpoints
  static const String apodEndpoint = '/planetary/apod';
  static const String marsRoverEndpoint = '/mars-photos/api/v1/rovers';
  static const String neoEndpoint = '/neo/rest/v1';
  static const String planetaryEndpoint = '/planetary';
  
  // Request timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}