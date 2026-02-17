class Endpoints {
  static const String baseUrl = 'https://api.floridayachttrader.com';

  static const String login = '$baseUrl/api/auth/login';
  static const String getMyBoats = '$baseUrl/api/boats/seller/get-own-boats';
  // Build boat-by-id endpoint
  static String getBoatById(String id) => '$baseUrl/api/boats/$id/details';
  static String deleteBoat(String boatId) =>
      '$baseUrl/api/boats/seller/delete-listing/$boatId';
  static const String allBoats = '$baseUrl/api/boats';
  static const String featuredBoats = '$baseUrl/api/boats/featured';
  static const String premiumDeals = '$baseUrl/api/boats/premium-deals/florida';
  // Normalized to a single slash to avoid relying on tolerant URI parsing
  static const String userMe = '$baseUrl/api/auth/profile';
  static const String changePassword = '$baseUrl/api/auth/change-password';
  static const String filters = '$baseUrl/api/boats/filter-options';

  // AI Chat endpoints live on a different host
  static const String aiBaseUrl = 'https://ai.jupitermarinesales.com/api';
  static const String floridaChat = '$aiBaseUrl/v1/florida_chat';
  static const String floridaChatHistory = '$aiBaseUrl/v1/florida_chat_history';

  // Florida Query (boat search) endpoint
  static const String floridaQuery = '$aiBaseUrl/v1/florida_query';

  // Notification endpoints
  static const String getUserAllNotifications =
      '$baseUrl/api/auth/notification';
  static String markOneNotificationAsRead(String notificationId) =>
      '$baseUrl/api/auth/notification/mark-as-read/$notificationId';
  static const String markAllNotificationAsRead =
      '$baseUrl/api/auth/notification/mark-all-as-read';
}
