// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';

// import 'package:student_affair/main.dart';
// import 'package:student_affair/models/notification_model.dart';
// import 'package:student_affair/providers/notification_provider.dart'; // Adjust import path

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log("Background Noti Received: ${message.messageId}");
// }

// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNoti =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     // 1. Request Notification Permissions[cite: 3]
//     await _messaging.requestPermission(alert: true, badge: true, sound: true);

//     // 2. Local Notifications Initialization Settings
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: DarwinInitializationSettings(),
//         );

//     //await _localNoti.initialize(initializationSettings);
//     // ✅ Correct (Named argument)
//     await _localNoti.initialize(settings: initializationSettings);
//     // 3. Create Android Notification Channel
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );

//     await _localNoti
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     // 4. Foreground Message Handler (App active/open)[cite: 3]
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;

//       if (notification != null) {
//         // Generate Unique Notification ID
//         int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//         // A. Display Local Banner
//         _localNoti.show(
//           id: notificationId,
//           title: notification.title,
//           body: notification.body,
//           notificationDetails: NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               importance: Importance.max,
//               priority: Priority.high,
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//         );

//         // B. Dynamic Addition to NotificationProvider
//         final context = navigatorKey.currentContext;
//         if (context != null) {
//           final String notificationType =
//               message.data['type']?.toString().toLowerCase() ?? '';

//           final newNotification = NotificationModel(
//             id: notificationId,
//             type:
//                 (notificationType == 'transaction' ||
//                     notificationType == 'wallet' ||
//                     notificationType == 'points')
//                 ? NotificationType.transaction
//                 : NotificationType.order,
//             title: notification.title ?? 'New Notification',
//             message: notification.body ?? '',
//             time: 'Just now',
//             isRead: false,
//           );

//           // Push new notification directly to provider
//           Provider.of<NotificationProvider>(
//             context,
//             listen: false,
//           ).addNotification(newNotification);
//         }
//       }
//     });
//   }

//   /// Get Device FCM Token[cite: 3]
//   static Future<String?> getToken() async {
//     String? token = await _messaging.getToken();
//     log("=== YOUR FCM TOKEN ===");
//     log(token ?? "No Token Found");
//     return token;
//   }
// }
