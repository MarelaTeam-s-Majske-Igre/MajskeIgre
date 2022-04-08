import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'concert_detail_state.dart';

class ConcertDetailCubit extends Cubit<ConcertDetailState> {
  final EventsRepo eventsRepo;
  ConcertDetailCubit(this.eventsRepo) : super(ConcertDetailInitial());

  loadEvent(int id) async {
    emit(ConcertDetailLoadingState());

    try {
      emit(ConcertDetailLoadedState(await eventsRepo.getConcertEvent(id)));
    } on Exception {
      emit(ConcertDetailErrorState());
    }
  }
}
