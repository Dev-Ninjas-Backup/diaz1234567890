class Endpoints {
  static const String baseUrl = 'https://api.floridayachttrader.com/api';

  static const String login = '$baseUrl/auth/login';
  static const String getMyBoats = '$baseUrl/boats/seller/get-own-boats';
  // Build boat-by-id endpoint
  static String getBoatById(String id) => '$baseUrl/boats/$id/details';
  static String deleteBoat(String boatId) =>
      '$baseUrl/boats/seller/delete-listing/$boatId';
  static const String allBoats = '$baseUrl/boats';
  static const String featuredBoats = '$baseUrl/boats/featured';
  static const String premiumDeals = '$baseUrl/boats/premium-deals/florida';
  // Normalized to a single slash to avoid relying on tolerant URI parsing
  static const String userMe = '$baseUrl/auth/profile';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String filters = '$baseUrl/boats/filter-options';

  // AI Chat endpoints live on a different host
  static const String aiBaseUrl = 'https://ai.jupitermarinesales.com/api';
  static const String floridaChat = '$aiBaseUrl/v1/florida_chat';
  static const String floridaChatHistory = '$aiBaseUrl/v1/florida_chat_history';

  // Florida Query (boat search) endpoint
  static const String floridaQuery = '$aiBaseUrl/v1/florida_query';
}
