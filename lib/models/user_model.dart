import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  @JsonKey(name: 'user_id')
  final int userId;
  
  @JsonKey(name: 'user_name')
  final String? userName;
  
  @JsonKey(name: 'user_phone')
  final String? userPhone;
  
  @JsonKey(name: 'user_email')
  final String? userEmail;
  
  @JsonKey(name: 'role_name')
  final String? roleName;
  
  @JsonKey(name: 'is_password_changed')
  final int isPasswordChanged;
  
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  UserModel({
    required this.userId,
    this.userName,
    this.userPhone,
    this.userEmail,
    this.roleName,
    required this.isPasswordChanged,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}