import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:flutter/material.dart';

class EventCardListModel {
  late final List<EventCardModel> events;

  EventCardListModel(this.events);

  EventCardListModel.fromRepo(List<DayEventModel> dayEventModel) {
    List<EventCardModel> ev = [];

    for (var day in dayEventModel) {
      if (day.sportEvents != null && day.sportEvents!.isNotEmpty) {
        ev.addAll(day.sportEvents!.map((e) => EventCardModel(
              id: e.id,
              title: e.title,
              startTime: e.startTime!,
              location: e.location,
              type: EventType.SPORT,
              imageUrl: e.imageUrls != null && e.imageUrls!.isNotEmpty
                  ? e.imageUrls![0]
                  : null,
            )));
      }

      if (day.cultureEvents != null && day.cultureEvents!.isNotEmpty) {
        ev.addAll(day.cultureEvents!.map((e) => EventCardModel(
              id: e.id,
              title: e.title,
              startTime: e.startTime!,
              type: EventType.CULTURE,
            )));
      }

      // ev = ev..sort((a, b) => a.startTime.compareTo(b.startTime));

      if (day.concertTitle != null) {
        ev.add(EventCardModel(
          id: day.id,
          title: day.concertTitle!,
          startTime: day.date!,
          location: day.concertLocation!,
          type: EventType.FUN,
        ));
      }
    }

    events = _sort(ev);
  }

  List<EventCardModel> _sort(List<EventCardModel> events) {
    events = events;
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    return events;
  }
}

class EventCardModel {
  final int id;
  final String title;
  final DateTime startTime;
  final EventType type;
  final String? location;
  final String? imageUrl;

  EventCardModel({
    required this.id,
    required this.title,
    required this.startTime,
    required this.type,
    this.location,
    this.imageUrl,
  });

  void onClick(BuildContext context) {
    switch (type) {
      case EventType.CULTURE:
        Navigator.pushNamed(
          context,
          "/event/culture",
          arguments: {'id': id},
        );
        break;
      case EventType.FUN:
        Navigator.pushNamed(
          context,
          "/event/fun",
          arguments: {'id': id},
        );
        break;
      case EventType.SPORT:
        Navigator.pushNamed(
          context,
          "/event/sport",
          arguments: {'id': id},
        );
        break;
    }
  }
}
