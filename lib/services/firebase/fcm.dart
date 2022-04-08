import 'package:app/data/firebase/fcm_repo.dart';
import 'package:app/services/firebase/push_notification.dart';
import 'package:app/services/global/global_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'majske_igre-marela_team_app', // id
  'Push opomniki', // title
  description:
      'Kanal je uporabljen za obveščanje uporabnikov o dogodkih', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> notificationSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_channel);

  _initializeNotificationPlugin();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _showNotification(notification.title ?? '', notification.body ?? '');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _showNotification(notification.title ?? '', notification.body ?? '');
    }
    // Navigator.pushNamed(context, '/message',
    //     arguments: MessageArguments(message, true));
  });

  var fcmRepo = FCMRepo();
  await fcmRepo.login();
}

void _showNotification(String title, String content) =>
    _flutterLocalNotificationsPlugin.show(
      content.hashCode,
      title,
      content,
      NotificationDetails(
          android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
      )),
    );

void _initializeNotificationPlugin() {
  final initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid);

  _flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  _showNotification(
    message.notification?.title ?? '',
    message.notification?.body ?? '',
  );
}
