import 'package:dio/dio.dart';
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
        connectTimeout: const Duration(seconds: 60), // အချိန်ကို တိုးပေးပါ
        receiveTimeout: const Duration(seconds: 60), // အချိန်ကို တိုးပေးပါ
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {"user_email": email, "user_password": password},
      );

      // ===== Login အောင်မြင်ပါက Token ကို SharedPreferences တွင် သိမ်းဆည်းမည် =====
      if (response.data != null && response.data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
      }
      // =================================================================

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
      // SharedPreferences မှ သိမ်းထားသော Token ကို ယူခြင်း
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('token') ?? ''; // Login ဝင်စဉ်က သိမ်းခဲ့သော Key

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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Header တွင် Token ထည့်ခြင်း
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          'ဆိုင်အကောင့်ဖွင့်ခြင်း မအောင်မြင်ပါ။';
    }
  }
}
