import 'dart:convert';

import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/firebase/notification_repo.dart';
import 'package:app/data/interceptors/fcm_token_interceptor.dart';
import 'package:app/data/repo_consts.dart';
import 'package:http_interceptor/http/http.dart';

class EventsRepo {
  final baseUrl = RepoConstants.BASE_URL;

  final client = InterceptedClient.build(
    interceptors: [FcmTokenInterceptor()],
  );

  static List<DayEventModel>? _events;

  Future<List<DayEventModel>> getEvents() async {
    if (_events == null) {
      try {
        _events = await _getEvents();
      } on Exception {
        rethrow;
      }
    }
    return _events!;
  }

  Future<List<DayEventModel>> _getEvents() async {
    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
    };

    final response =
        await client.get(Uri.parse(baseUrl + "events"), headers: headers);

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      var model = List<DayEventModel>.from(
          l.map((model) => DayEventModel.fromJson(model)));
      return model;
    } else {
      throw Exception(response.body);
    }
  }

  Future<SportEvent> getSportEvent(int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
    };

    final response = await client.get(Uri.parse(baseUrl + "event/sport/$id"),
        headers: headers);

    if (response.statusCode == 200) {
      return SportEvent.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<CultureEvent> getCultureEvent(int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
    };

    final response = await client.get(Uri.parse(baseUrl + "event/culture/$id"),
        headers: headers);

    if (response.statusCode == 200) {
      return CultureEvent.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<ConcertEvent> getConcertEvent(int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
    };

    final response = await client.get(Uri.parse(baseUrl + "event/concert/$id"),
        headers: headers);

    if (response.statusCode == 200) {
      return ConcertEvent.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}
