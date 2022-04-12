import 'package:app/data/firebase/notification_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sport_notification_state.dart';

class SportNotificationCubit extends Cubit<SportNotificationState> {
  final NotificationRepo notificationRepo;
  SportNotificationCubit(this.notificationRepo) : super(SportNotificationInitial());

  subscribe(int eventId) async {
    emit(SportNotificationLoadingState());
    if(await notificationRepo.subscribeToSportNotification(eventId)) {
      emit(SportNotificationLoadedState(true));
    } else {
      emit(SportNotificationLoadedState(false));
    }
  }

  ubsubscribe(int eventId) async {
    emit(SportNotificationLoadingState());
    if(await notificationRepo.unsubscribeToSportNotification(eventId)) {
      emit(SportNotificationLoadedState(false));
    } else {
      emit(SportNotificationLoadedState(true));
    }
  }
}
