part of 'home_screen_cubit.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoadingState extends HomeScreenState {}

class HomeScreenErrorState extends HomeScreenState {}

class HomeScreenLoadedState extends HomeScreenState {
  HomeScreenLoadedState(this.events);

  final List<DayEventModel> events;

  DayEventModel? getTodaysEvents() {
    var today = DateTime.now();
    return events.firstWhereOrNull(
        (element) => element.date?.isSameDate(today) ?? false);
  }

  List<DayEventModel> getNextEvents({int noOfEvents = 5}) {
    var today = DateTime.now();
    List<DayEventModel> ev = [];
    int selectedEvents = 0;

    for (var day in events) {
      if (day.date?.isBefore(today) ??
          true && !(day.date?.isSameDate(today) ?? false)) {
        continue;
      }

      ev.add(day);
      selectedEvents += ((day.concertTitle != null ? 1 : 0) +
          (day.cultureEvents?.length ?? 0) +
          (day.sportEvents?.length ?? 0));

      if (selectedEvents >= noOfEvents) {
        break;
      }
    }

    return ev;
  }
}
