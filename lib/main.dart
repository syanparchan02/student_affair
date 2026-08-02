import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_affair/firebase_options.dart';
import 'package:student_affair/screens/login_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocalNotifications();
  await setupFirebaseMessaging();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> setupLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        debugPrint('📱 Notification tapped: ${response.payload}');
        _handleNotificationTap(response.payload!);
      }
    },
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Top-Up Notifications',
    description: 'Notifications for top-up transactions',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

Future<void> setupFirebaseMessaging() async {
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

  debugPrint('📱 Permission status: ${settings.authorizationStatus}');
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint('📱 FCM Token: $token');
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('📱 FCM Token Refreshed: $newToken');
    _sendTokenToServer(newToken);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('📱 Foreground message: ${message.notification?.title}');
    _showLocalNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('📱 App opened from background: ${message.notification?.title}');
    _handleBackgroundMessage(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      debugPrint(
        '📱 App opened from terminated: ${message.notification?.title}',
      );
      _handleTerminatedMessage(message);
    }
  });
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'Top-Up Notifications',
    channelDescription: 'Notifications for top-up transactions',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title: message.notification?.title ?? 'New Notification',
    body: message.notification?.body ?? 'You have a new notification',
    notificationDetails: details,
    payload: message.data['type'] ?? 'general',
  );
}

void _handleNotificationTap(String payload) {
  debugPrint('📱 Notification tapped with payload: $payload');
}

void _handleBackgroundMessage(RemoteMessage message) {
  debugPrint('📱 Handling background message: ${message.messageId}');
}

void _handleTerminatedMessage(RemoteMessage message) {
  debugPrint('📱 Handling terminated message: ${message.messageId}');
}

Future<void> _sendTokenToServer(String token) async {
  debugPrint('📱 Sending token to server: $token');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Affair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
