import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:student_affair/models/user_model.dart';
import 'package:student_affair/service/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;

  AuthState({this.isLoading = false, this.errorMessage, this.user});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final response = await ApiService().login(email, password);

      if (response['success'] == true) {
        var user = UserModel.fromJson(response['user']);

        debugPrint("======================================");
        debugPrint("✅ LOGIN SUCCESSFUL!");
        debugPrint("Token: ${response['token']}");
        debugPrint("User Name: ${user.userName}");
        debugPrint("User Email: ${user.userEmail}");
        debugPrint("Role: ${user.roleName}");
        debugPrint("======================================");

        state = AuthState(isLoading: false, user: user);
        return true;
      } else {
        state = AuthState(isLoading: false, errorMessage: response['message']);
        return false;
      }
    } catch (e) {
      debugPrint("❌ LOGIN ERROR: $e");
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> registerShop({
    required String userName,
    required String userEmail,
    required String userPassword,
    required String shopName,
    required String shopPhone,
    required String userPhone,
    required String walletPin,
  }) async {
    state = AuthState(isLoading: true);
    try {
      final response = await ApiService().registerShop(
        userName: userName,
        userEmail: userEmail,
        userPassword: userPassword,
        shopName: shopName,
        shopPhone: shopPhone,
        userPhone: userPhone,
        walletPin: walletPin,
      );

      if (response['success'] == true) {
        state = AuthState(isLoading: false);
        return true;
      } else {
        state = AuthState(isLoading: false, errorMessage: response['message']);
        return false;
      }
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
