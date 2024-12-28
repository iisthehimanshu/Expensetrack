import 'package:expensetracker/Presentation/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize the notifications plugin
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification system
  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification clicked!');
      },
    );

    // Show a notification on app launch
    showHelloNotification();
  }

  // Show a "Hello User" notification
  void showHelloNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'welcome_channel', // Channel ID
      'Welcome Notifications', // Channel Name
      channelDescription: 'This channel is for welcome notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Hello User', // Notification Title
      'Welcome to the Expense Tracker!', // Notification Body
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize notifications when the app starts
    initializeNotifications();

    return const MaterialApp(
      home: FinanceDashboard(),
    );
  }
}
