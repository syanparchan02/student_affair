import 'package:student_affair/config/env_config.dart';

class ApiEndpoints {
  static const String baseUrl = 'http://192.168.100.9:8000/api';

  static const String login = '/login';
  static const String registerShop = "/register-shop";
  static const String adminShopMenus = "/admin/shops/menus";

  static const String topupbypone = "/topup/by-phone";
  static const String allHistory = "/recent-topups";
  static const String exchangePoint = "/student-affairs/shop/exchange-point";
}
