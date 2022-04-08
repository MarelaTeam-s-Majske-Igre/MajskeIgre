import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sport_detail_state.dart';

class SportDetailCubit extends Cubit<SportDetailState> {
  final EventsRepo eventsRepo;

  SportDetailCubit(this.eventsRepo) : super(SportDetailInitial());

  loadEvent(int id) async {
    emit(SportDetailLoadingState());

    try {
      emit(SportDetailLoadedState(await eventsRepo.getSportEvent(id)));
    } on Exception {
      emit(SportDetailErrorState());
    }
  }
}
