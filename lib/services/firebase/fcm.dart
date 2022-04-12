import 'package:app/data/firebase/notification_repo.dart';
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
      _showNotification(notification.title ?? '', notification.body ?? '',
          "${message.data['eventType']}___${message.data['eventId']}");
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _showNotification(notification.title ?? '', notification.body ?? '',
          "${message.data['eventType']}___${message.data['eventId']}");
    }
    // Navigator.pushNamed(context, '/message',
    //     arguments: MessageArguments(message, true));
  });

  var notificationRepo = NotificationRepo();
  await notificationRepo.login();
}

void _showNotification(String title, String content, String payload) =>
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
          ),
        ),
        payload: payload);

void _initializeNotificationPlugin() {
  final initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid);

  _flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: _onSelectNotification,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  _showNotification(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      "${message.data['eventType']}___${message.data['eventId']}");
}

void _onSelectNotification(payload) {
  final context = NavigationService.navigatorKey.currentContext;
  try {
    final data = payload!.split("___");
    final eventType = data[0];
    final eventId = int.parse(data[1]);
    if (eventType == 'SPORT') {
      Navigator.pushNamed(
        context!,
        "/event/sport",
        arguments: {'id': eventId},
      );
    } else if (eventType == 'CULTURE') {
      Navigator.pushNamed(
        context!,
        "/event/culture",
        arguments: {'id': eventId},
      );
    } else {
      throw Exception();
    }
  } on Exception {
    Navigator.pushNamed(
      context!,
      "/events",
    );
  }
}
