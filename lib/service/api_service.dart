import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:student_affair/service/end_points.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _currentToken;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        debugPrint('📱 FCM Token: $fcmToken');
      } catch (e) {
        debugPrint('⚠️ FCM Token ရယူရာမှာ အမှားရှိနေတယ်: $e');
        fcmToken = null;
      }

      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          "user_email": email,
          "user_password": password,
          "fcm_token": fcmToken,
        },
      );
      debugPrint('📡 Full Response: ${response.data}');
      debugPrint('📡 Token: ${response.data['token']}');
      debugPrint('📡 Success: ${response.data['success']}');
      debugPrint('📡 User: ${response.data['user']}');
      if (response.data != null && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);

        if (fcmToken != null) {
          await prefs.setString('fcm_token', fcmToken);
        }
      }

      return response.data;
    } on DioException catch (e) {
      debugPrint("🔥 Status Code: ${e.response?.statusCode}");
      debugPrint("🔥 Response Data: ${e.response?.data}");

      final errorMessage =
          e.response?.data['message'] ??
          e.response?.data.toString() ??
          'ဝင်ရောက်ရန် ကြိုးပမ်းမှု မအောင်မြင်ပါ။';
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> registerShop({
    required String userName,
    required String userEmail,
    required String userPassword,
    required String shopName,
    required String shopPhone,
    required String userPhone,
    required String walletPin,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.post(
        ApiEndpoints.registerShop,
        data: {
          "user_name": userName,
          "user_email": userEmail,
          "user_password": userPassword,
          "role_name": "shop",
          "shop_name": shopName,
          "shop_phone": shopPhone,
          "user_phone": userPhone,
          "wallet_pin": walletPin,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          'ဆိုင်အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ။';
    }
  }

  Future<List<dynamic>> fetchAdminShopMenus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.adminShopMenus,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data is List) {
        return response.data;
      } else if (response.data['data'] is List) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          'ဆိုင်နှင့် မီနူးအချက်အလက်များကို ထုတ်ယူ၍မရပါ။';
    }
  }

  Future<Map<String, dynamic>> topupByPhone({
    required String phone,
    required double amount,
    required String pin,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.post(
        ApiEndpoints.topupbypone,
        data: {"phone": phone, "amount": amount, "pin": pin},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'ငွေလွှဲခြင်း မအောင်မြင်ပါ။';
    }
  }

  // Future<List<dynamic>> getAllHistory() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token') ?? '';

  //     final response = await _dio.get(
  //       ApiEndpoints.allHistory,
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );

  //     if (response.data is List) {
  //       return response.data;
  //     } else if (response.data['data'] is List) {
  //       return response.data['data'];
  //     }
  //     return [];
  //   } on DioException catch (e) {
  //     throw e.response?.data['message'] ?? 'မှတ်တမ်းများကို ထုတ်ယူ၍မရပါ။';
  //   }
  // }
  Future<Map<String, dynamic>> getAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.allHistory,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'မှတ်တမ်းများကို ထုတ်ယူ၍မရပါ။';
    }
  }

  Future<Map<String, dynamic>> exchangePoint({
    required int shopId,
    required String phone,
    required double amount,
    required String pin,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.post(
        ApiEndpoints.exchangePoint,
        data: {"shop_id": shopId, "phone": phone, "amount": amount, "pin": pin},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'ပွိုင့်လဲလှယ်ခြင်း မအောင်မြင်ပါ။';
    }
  }

  Future<Map<String, dynamic>> getUserInfoByQr(String scannedData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final encodedData = Uri.encodeComponent(scannedData);
      print("Encoded Data: '$encodedData'");

      final response = await _dio.get(
        '${ApiEndpoints.userInfoByQr}$encodedData',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("Response Data: ${e.response?.data}");
      throw e.response?.data['message'] ?? 'အသုံးပြုသူ အချက်အလက် ရယူ၍မရပါ။';
    }
  }

  Future<List<dynamic>> getRecentExchanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.recentExchanges,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data is List) {
        return response.data;
      } else if (response.data['data'] is List) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'မှတ်တမ်းများကို ထုတ်ယူ၍မရပါ။';
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      try {
        await _dio.post(
          ApiEndpoints.logout,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
      } catch (_) {}

      await prefs.remove('token');
      await prefs.remove('fcm_token');
    } catch (e) {
      throw 'ထွက်ခွာရန် မအောင်မြင်ပါ။';
    }
  }

  Future<Map<String, dynamic>> getExchangeSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.exchangeSummary,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'အချက်အလက်များကို ထုတ်ယူ၍မရပါ။';
    }
  }

  // Pending Exchanges တွေကို ဆွဲထုတ်မယ့် Method
  Future<List<dynamic>> getPendingExchanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.pendingExchanges,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // JSON structure အရ response.data['data']['data'] ကို ယူပါတယ်
      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data']['data'] ?? [];
      }
      return [];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'တောင်းဆိုမှုများကို ထုတ်ယူ၍မရပါ။';
    }
  }

  // Payout Confirm လုပ်မည့် Method
  Future<Map<String, dynamic>> confirmPayout(int transactionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.post(
        // သို့မဟုတ် Server ပေါ်မူတည်၍ .post သုံးပါ
        '${ApiEndpoints.baseUrl}${ApiEndpoints.confirmPayout(transactionId)}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'အတည်ပြုခြင်း မအောင်မြင်ပါ။';
    }
  }

  Future<Map<String, dynamic>> getMonthlySummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        ApiEndpoints.monthlySummary,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      debugPrint("Status: ${e.response?.statusCode}");
      debugPrint("Error: ${e.response?.data}");

      throw e.response?.data['message'] ?? 'Summary data ရယူ၍မရပါ။';
    }
  }
}
