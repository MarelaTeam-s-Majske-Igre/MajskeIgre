import 'package:app/data/firebase/notification_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class FcmTokenInterceptor implements InterceptorContract {
  static String? fcmToken;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    fcmToken ??= await _getFcmToken();

    Map<String, String> header = {
      'FCM-token': fcmToken ?? 'napaka',
    };
    data.headers.addAll(header);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }

  Future<String?> _getFcmToken() async {
    await Firebase.initializeApp();
    var _messaging = FirebaseMessaging.instance;
    return await _messaging.getToken();
  }
}
