import 'dart:convert';

import 'package:app/data/interceptors/fcm_token_interceptor.dart';
import 'package:app/data/repo_consts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    Map<String, dynamic> model = {
      "androidId": androidInfo.androidId,
      "brand": androidInfo.brand,
      "device": androidInfo.device,
      "fingerprint": androidInfo.fingerprint,
      "manufacturer": androidInfo.manufacturer,
      "model": androidInfo.model,
      "androidRelease": androidInfo.version.release,
      "androidSkdInt": androidInfo.version.sdkInt,
      "androidSecurityPatch": androidInfo.version.securityPatch
    };

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'FCM-token': token
    };

    try {
      var response = await client.post(
        Uri.parse(baseUrl + "login"),
        body: json.encode(model),
        headers: headers,
      );

      while (response.statusCode == 308) {
        if (response.headers.containsKey("location")) {
          response = await client.post(
            Uri.parse(response.headers["location"]!),
            body: json.encode(model),
            headers: headers,
          );
        }
      }

      if (response.statusCode == 200) {
      } else {
        throw Exception();
      }
    } catch (e) {
      var x = e;
    }
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
