import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:student_affair/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Fetch notifications history from Backend API
  Future<void> fetchNotifications({
    required String userToken,
    required String baseUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Dio().get(
        '$baseUrl/notifications',
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        _notifications.clear();
        _notifications.addAll(
          data.map((item) => NotificationModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a single notification by id
  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// Add new dynamic incoming FCM notification
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // /// Mark single notification as read
  // void markAsRead(String id) {
  //   final index = _notifications.indexWhere((n) => n.id == id);
  //   if (index != -1) {
  //     _notifications[index].isRead = true;
  //     notifyListeners();
  //   }
  // }
  // notification_provider.dart

  /// Mark single notification as read
  void markAsRead(int id) {
    // 👈 Change String to int
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  /// Mark all as read
  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}
