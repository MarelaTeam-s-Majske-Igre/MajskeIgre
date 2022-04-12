import 'package:app/data/event_type/event_type.dart';
import 'package:app/data/event_type/event_type_services.dart';
import 'package:app/data/events/day_event_model.dart';
import 'package:app/data/firebase/notification_repo.dart';
import 'package:app/services/global/global_context.dart';
import 'package:app/style/theme_colors.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  final NotificationRepo notificationRepo;

  PushNotificationBloc(this.notificationRepo)
      : super(PushNotificationInitial()) {
    on<PushNotificationInitialLoadEvent>(_onInitialLoad);
    on<PushNotificationSubscribeEvent>(_onEventSubscribe);
    on<PushNotificationUnsubscribeEvent>(_onEventUnsubscribe);
  }

  String _generateKey(PushNotificationEvent event) {
    return "${event.type == EventType.SPORT ? "SPORT" : "CULTURE"}___${event.eventId}";
  }

  _onInitialLoad(PushNotificationInitialLoadEvent event, Emitter emit) async {
    emit(PushNotificationLoadingState());
    final prefs = await SharedPreferences.getInstance();

    bool subscribed = prefs.getBool(_generateKey(event)) ?? false;
    emit(PushNotificationLoadedState(
      event.type,
      event.eventId,
      subscribed,
    ));
  }

  _onEventSubscribe(PushNotificationSubscribeEvent event, Emitter emit) async {
    emit(PushNotificationLoadingState());
    final prefs = await SharedPreferences.getInstance();

    if (event.type == EventType.SPORT) {
      final apiSuccess =
          await notificationRepo.subscribeToSportNotification(event.eventId);
      if (apiSuccess) {
        _showSnackbar("Prijava na dogodek je bila uspešna");
        emit(PushNotificationLoadedState(
          event.type,
          event.eventId,
          true,
        ));
        prefs.setBool(_generateKey(event), true);
      } else {
        _showSnackbar("Napaka, poskusite ponovno kasneje");
        emit(PushNotificationErrorState(
          "Napaka pri shranjevanju, poskusite ponovno kasneje",
          event.type,
          event.eventId,
          false,
        ));
      }
    } else if (event.type == EventType.CULTURE) {
      final apiSuccess =
          await notificationRepo.subscribeToCultureNotification(event.eventId);
      if (apiSuccess) {
        _showSnackbar("Prijava na dogodek je bila uspešna");
        emit(PushNotificationLoadedState(
          event.type,
          event.eventId,
          true,
        ));
      } else {
        _showSnackbar("Napaka, poskusite ponovno kasneje");
        emit(PushNotificationErrorState(
          "Napaka pri shranjevanju, poskusite ponovno kasneje",
          event.type,
          event.eventId,
          false,
        ));
      }
    }
  }

  _onEventUnsubscribe(
      PushNotificationUnsubscribeEvent event, Emitter emit) async {
    emit(PushNotificationLoadingState());
    final prefs = await SharedPreferences.getInstance();
    if (event.type == EventType.SPORT) {
      final apiSuccess =
          await notificationRepo.unsubscribeToSportNotification(event.eventId);
      if (apiSuccess) {
        _showSnackbar("Odjava uspešna, o dogodku ne boste obveščeni");
        emit(PushNotificationLoadedState(
          event.type,
          event.eventId,
          false,
        ));
        prefs.setBool(_generateKey(event), false);
      } else {
        _showSnackbar("Napaka, poskusite ponovno kasneje");
        emit(PushNotificationErrorState(
          "Napaka pri shranjevanju, poskusite ponovno kasneje",
          event.type,
          event.eventId,
          false,
        ));
      }
    } else if (event.type == EventType.CULTURE) {
      final apiSuccess = await notificationRepo
          .unsubscribeToCultureNotification(event.eventId);
      if (apiSuccess) {
        _showSnackbar("Odjava uspešna, o dogodku ne boste obveščeni");
        emit(PushNotificationLoadedState(
          event.type,
          event.eventId,
          false,
        ));
      } else {
        _showSnackbar("Napaka, poskusite ponovno kasneje");
        emit(PushNotificationErrorState(
          "Napaka pri shranjevanju, poskusite ponovno kasneje",
          event.type,
          event.eventId,
          false,
        ));
      }
    }
  }

  _showSnackbar(String text) {
    var context = NavigationService.navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColors.primaryBlue.withOpacity(0.75),
        content: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.35),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                          child: Text(
                            "Zapri",
                            style: TextStyle(color: Colors.white),
                          ),
                          style:
                              ElevatedButton.styleFrom(primary: ThemeColors.purple),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
