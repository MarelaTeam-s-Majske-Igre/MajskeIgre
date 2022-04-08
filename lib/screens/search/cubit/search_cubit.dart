import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:app/data/models/event_card_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final EventsRepo eventsRepo;
  SearchCubit(this.eventsRepo) : super(SearchInitial());

  onSearchQueryChange(String query) async {
    print(query);

    List<EventCardModel> eventCards = [];
    if (query.length >= 2) {
      eventCards = await _getEvents(query);
    } else {
      await Future.delayed(Duration(milliseconds: 1));
    }

    emit(SearchLoadedState(eventCards));
  }

  _getEvents(String query) async {
    List<EventCardModel> eventCards = [];
    var events = await eventsRepo.getEvents();
    query = query.toLowerCase();

    for (var d in events) {
      if (d.sportEvents != null) {
        for (var sport in d.sportEvents!) {
          if (sport.title.toLowerCase().contains(query) &&
              sport.startTime != null) {
            eventCards.add(EventCardModel(
                id: sport.id,
                title: sport.title,
                startTime: sport.startTime!,
                type: EventType.SPORT,
                location: sport.location,
                imageUrl: sport.imageUrls != null && sport.imageUrls!.isNotEmpty
                    ? sport.imageUrls![0]
                    : null));
          }
        }
      }

      if (d.cultureEvents != null) {
        for (var culture in d.cultureEvents!) {
          if (culture.title.toLowerCase().contains(query) &&
              culture.startTime != null) {
            eventCards.add(
              EventCardModel(
                id: culture.id,
                title: culture.title,
                startTime: culture.startTime!,
                type: EventType.CULTURE,
                // imageUrl: sport.imageUrls != null && sport.imageUrls!.isNotEmpty
                //     ? sport.imageUrls![0]
                //     : null,
              ),
            );
          }
        }
      }

      events.sort((a, b) => a.date!.compareTo(b.date!));

      if (d.concertTitle != null &&
          d.concertTitle!.toLowerCase().contains(query)) {
        eventCards.add(EventCardModel(
            id: 0, //TODO - reši neki s tem
            title: d.concertTitle!,
            startTime: d.date!,
            type: EventType.FUN));
      }
    }
    return eventCards;
  }
}
