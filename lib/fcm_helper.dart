import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmHelper {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final Dio _dio = Dio();

  /// 1. FCM Token ရယူခြင်းနှင့် Notification Permission တောင်းခံခြင်း
  static Future<String?> getToken() async {
    try {
      // Notification Permission တောင်းခံခြင်း (iOS & Android 13+)
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('Notification Permission: Granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('Notification Permission: Provisional');
      } else {
        log('Notification Permission: Denied');
      }

      // Device FCM Token ရယူခြင်း
      String? token = await _firebaseMessaging.getToken();

      log("==========================================");
      log("DEVICE FCM TOKEN: $token");
      log("==========================================");

      return token;
    } catch (e) {
      log("Error fetching FCM Token: $e");
      return null;
    }
  }

  /// 2. Token ရယူပြီး Backend သိသို့ တိုက်ရိုက်ပေးပို့ပေးမည့် Helper Function
  static Future<bool> syncTokenWithBackend({
    required String userAuthToken,
    required String baseUrl,
  }) async {
    final String? fcmToken = await getToken();

    if (fcmToken == null || fcmToken.isEmpty) {
      log("❌ Cannot send FCM Token to backend: FCM Token is null or empty");
      return false;
    }

    // Backend သို့ ပို့ပေးခြင်း
    final success = await sendTokenToBackend(
      fcmToken: fcmToken,
      userAuthToken: userAuthToken,
      baseUrl: baseUrl,
    );

    // Refresh ဖြစ်တိုင်း Auto Re-sync လုပ်ရန် Listen သတ်မှတ်ခြင်း
    if (success) {
      _listenToTokenRefresh(userAuthToken: userAuthToken, baseUrl: baseUrl);
    }

    return success;
  }

  /// 3. Token ပြောင်းလဲသွားပါက Auto Refresh လုပ်ပြီး Backend သို့ ပြန်ပို့ပေးခြင်း
  static void _listenToTokenRefresh({
    required String userAuthToken,
    required String baseUrl,
  }) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log("FCM Token Refreshed: $newToken");
      await sendTokenToBackend(
        fcmToken: newToken,
        userAuthToken: userAuthToken,
        baseUrl: baseUrl,
      );
    });
  }

  /// 4. Dio ကို အသုံးပြု၍ FCM Token ကို Laravel Backend API သို့ ပို့ပေးမည့် Function
  static Future<bool> sendTokenToBackend({
    required String fcmToken,
    required String userAuthToken, // User ရဲ့ Login Bearer Token
    required String baseUrl, // ဥပမာ - https://your-domain.com/api
  }) async {
    final String url = '$baseUrl/update-fcm-token';

    try {
      final response = await _dio.post(
        url,
        data: {'fcm_token': fcmToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userAuthToken',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ FCM Token successfully updated on Backend Server via Dio.");
        return true;
      } else {
        log(
          "❌ Failed to update FCM Token. Status Code: ${response.statusCode}",
        );
        return false;
      }
    } on DioException catch (e) {
      log("❌ Dio Error sending FCM Token: ${e.message}");
      if (e.response != null) {
        log("Response Data: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      }
      return false;
    } catch (e) {
      log("❌ Unexpected Error: $e");
      return false;
    }
  }
}
