import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('order')
  order,
  @JsonValue('transaction')
  transaction,
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class NotificationModel {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(unknownEnumValue: NotificationType.order)
  final NotificationType type;

  @JsonKey(defaultValue: '')
  final String title;

  @JsonKey(defaultValue: '')
  final String message;

  @JsonKey(defaultValue: '')
  final String time;

  @JsonKey(defaultValue: false)
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}