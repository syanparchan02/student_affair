class ApiEndpoints {
  static const String baseUrl = 'http://192.168.190.171:8000/api';

  static const String login = '/login';
  static const String registerShop = "/register-shop";
  static const String adminShopMenus = "/admin/shops/menus";

  static const String topupbypone = "/topup/by-phone";
  static const String allHistory = "/recent-topups";
  static const String exchangePoint = "/student-affairs/shop/exchange-point";
  static const String userInfoByQr = "/user-info-by-qr/";
  static const String recentExchanges = "/recent-exchanges";
  static const String logout = '/logout';

  static const String pendingExchanges = "/student-affairs/exchanges/pending";
  static String confirmPayout(int id) =>
      "/student-affairs/exchanges/$id/confirm-payout";
  static const String exchangeSummary =
      "/student-affairs/reports/exchange-summary";
  static const String monthlySummary = "/student-affairs/summary/monthly";
}
