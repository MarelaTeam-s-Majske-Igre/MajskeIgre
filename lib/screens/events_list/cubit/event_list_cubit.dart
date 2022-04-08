import 'dart:math';

import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import 'package:app/extensions/date_only_compare.dart';


part 'event_list_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final EventsRepo eventsRepo;

  EventListCubit(this.eventsRepo) : super(EventListInitial());

  loadData() async {
    emit(EventListLoadingState());
    try {
      var events = await eventsRepo.getEvents();
      emit(EventListLoadedState(events));
    } on Exception {
      emit(EventListErrorState());
    }
  }

  changeSelectedDate(EventListLoadedState state, DateTime newDate) {
      emit(EventListLoadedState.copyWith(state, date: newDate));
  }
}
