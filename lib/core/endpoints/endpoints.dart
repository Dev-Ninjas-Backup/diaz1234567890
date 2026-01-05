class Endpoints {
  static const String baseUrl = 'https://api.floridayachttrader.com/api';

  static const String login = '$baseUrl/auth/login';
  static const String getMyBoats = '$baseUrl/boats/seller/get-own-boats';
  // Build boat-by-id endpoint
  static String getBoatById(String id) => '$getMyBoats/$id';
}
