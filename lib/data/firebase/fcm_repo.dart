import 'dart:convert';

import 'package:app/data/interceptors/fcm_token_interceptor.dart';
import 'package:app/data/repo_consts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_interceptor/http/http.dart';

class FCMRepo {
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

    final response = await client.post(Uri.parse(baseUrl + "login"),
        body: utf8.encode(token), headers: headers);

    if (response.statusCode == 200) {
      bool model = response.body == "true";
    } else {
      throw Exception();
    }
  }
}
