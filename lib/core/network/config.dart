// Configuration constants for the network layer

class NetworkConfig {
  // Load from .env or fallback to a default HTTPS base URL
  static const String baseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://api.example.com');

  // Timeout values
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
