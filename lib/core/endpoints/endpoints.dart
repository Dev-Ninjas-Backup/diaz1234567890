class Endpoints {
  static const String baseUrl = 'https://api.floridayachttrader.com/api';

  static const String login = '$baseUrl/auth/login';
  static const String getMyBoats = '$baseUrl/boats/seller/get-own-boats';
  // Build boat-by-id endpoint
  static String getBoatById(String id) => '$getMyBoats/$id';
  static const String allBoats = '$baseUrl/boats';
  static const String featuredBoats = '$baseUrl/boats/featured';
  static const String premiumDeals = '$baseUrl/boats/premium-deals/florida';
}
