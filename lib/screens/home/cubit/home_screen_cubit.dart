import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:app/extensions/date_only_compare.dart';
import 'package:collection/collection.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final EventsRepo eventsRepository;
  
  HomeScreenCubit(this.eventsRepository) : super(HomeScreenInitial());

  loadData() async {
    emit(HomeScreenLoadingState());
    try {
      var events = await eventsRepository.getEvents();
      emit(HomeScreenLoadedState(events));
    } on Exception {
      emit(HomeScreenErrorState());
    }
  }
}
