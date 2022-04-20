import 'dart:convert';

import 'package:app/data/interceptors/fcm_token_interceptor.dart';
import 'package:app/data/repo_consts.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class NotificationRepo {
  final baseUrl = RepoConstants.BASE_URL;
  static String? fcmToken;

  final client = InterceptedClient.build(
    interceptors: [FcmTokenInterceptor()],
  );

  Future<String> getFcmToken() async {
    fcmToken ??= await _getFcmToken();
    return fcmToken ?? 'napaka';
  }

  Future<String?> _getFcmToken() async {
    await Firebase.initializeApp();
    var _messaging = FirebaseMessaging.instance;
    return await _messaging.getToken();
  }

  Future<void> login({String? token}) async {
    token ??= await getFcmToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Content-Length': utf8.encode(token).length.toString()
    };

    try {
      final response = await client.post(Uri.parse(baseUrl + "login"),
          body: utf8.encode(token), headers: headers);

      if (response.statusCode == 200) {
      } else {
        throw Exception();
      }
    } on Exception {}
  }

  Future<bool> subscribeToSportNotification(int eventId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var response = await client.post(
      Uri.parse(baseUrl + "notifications/sport?eventId=$eventId"),
      headers: headers,
    );

    while (response.statusCode == 308) {
      if (response.headers.containsKey("location")) {
        response = await client.post(
          Uri.parse(response.headers["location"]!),
          headers: headers,
        );
      }
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> subscribeToCultureNotification(int eventId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var response = await client.post(
      Uri.parse(baseUrl + "notifications/culture?eventId=$eventId"),
      headers: headers,
    );

    while (response.statusCode == 308) {
      if (response.headers.containsKey("location")) {
        response = await client.post(
          Uri.parse(response.headers["location"]!),
          headers: headers,
        );
      }
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unsubscribeToSportNotification(int eventId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var response = await client.delete(
      Uri.parse(baseUrl + "notifications/sport?eventId=$eventId"),
      headers: headers,
    );

    while (response.statusCode == 308) {
      if (response.headers.containsKey("location")) {
        response = await client.delete(
          Uri.parse(response.headers["location"]!),
          headers: headers,
        );
      }
    }

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unsubscribeToCultureNotification(int eventId) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var response = await client.delete(
      Uri.parse(baseUrl + "notifications/culture?eventId=$eventId"),
      headers: headers,
    );

    while (response.statusCode == 308) {
      if (response.headers.containsKey("location")) {
        response = await client.delete(Uri.parse(response.headers["location"]!),
            headers: headers);
        response = response;
      }
    }

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
