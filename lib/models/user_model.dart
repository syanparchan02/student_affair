// models/user_model.dart
class UserModel {
  final int userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String roleName;
  final int isPasswordChanged;
  final String? fcmToken;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.roleName,
    required this.isPasswordChanged,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userPhone: json['user_phone'],
      userEmail: json['user_email'],
      roleName: json['role_name'],
      isPasswordChanged: json['is_password_changed'],
      fcmToken: json['fcm_token'],
    );
  }
}
