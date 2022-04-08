part of 'event_list_cubit.dart';

@immutable
abstract class EventListState {}

class EventListInitial extends EventListState {}

class EventListLoadingState extends EventListState {}

class EventListErrorState extends EventListState {}

class EventListLoadedState extends EventListState {
  final List<DayEventModel> events;

  late final DateTime selectedDate;

  EventListLoadedState(this.events) {
    var now = DateTime.now();
    var firstOfMay = DateTime(now.year, 5, 1);

    if (now.isBefore(firstOfMay)) {
      selectedDate = events
          .firstWhere((element) => element.date!.isAfter(firstOfMay))
          .date!;
    } else {
      selectedDate = now;
    }
  }

  EventListLoadedState.withDate(this.events, this.selectedDate);

  static EventListLoadedState copyWith(
    EventListLoadedState state, {
    List<DayEventModel>? events,
    DateTime? date,
  }) =>
      EventListLoadedState.withDate(
        events ?? state.events,
        date ?? state.selectedDate,
      );

  bool typeOfEventOnDate(DateTime date, EventType type) {
    var day =
        events.firstWhereOrNull((element) => date.isSameDate(element.date));

    return day == null ? false : hasTypeOfEvent(day, type);
  }

  bool hasTypeOfEvent(DayEventModel day, EventType type) {
    switch (type) {
      case EventType.SPORT:
        return day.sportEvents != null && day.sportEvents!.isNotEmpty;
      case EventType.CULTURE:
        return day.cultureTitle != null;
      case EventType.FUN:
        return day.concertTitle != null;
    }
  }
}
