import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/events/events_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'culture_detail_state.dart';

class CultureDetailCubit extends Cubit<CultureDetailState> {
  final EventsRepo eventsRepo;
  CultureDetailCubit(this.eventsRepo) : super(CultureDetailInitial());

  loadEvent(int id) async {
    emit(CultureDetailLoadingState());

    try {
      emit(CultureDetailLoadedState(await eventsRepo.getCultureEvent(id)));
    } on Exception {
      emit(CultureDetailErrorState());
    }
  }
}
