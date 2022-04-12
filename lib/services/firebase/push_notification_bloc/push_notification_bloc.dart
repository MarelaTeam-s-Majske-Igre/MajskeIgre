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
    if (prefs.getBool(_generateKey(event)) ?? false) {
      emit(PushNotificationLoadedState(
        event.type,
        event.eventId,
        true,
      ));
    } else {
      if (event.type == EventType.SPORT) {
        final apiSuccess =
            await notificationRepo.subscribeToSportNotification(event.eventId);
        if (apiSuccess) {
          emit(PushNotificationLoadedState(
            event.type,
            event.eventId,
            true,
          ));
          prefs.setBool(_generateKey(event), true);
          ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
              .showSnackBar(
            SnackBar(
              backgroundColor: ThemeColors.primaryBlue,
              content: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 80),
                  child: Text("Prijava na dogodek je bila uspešna")),
            ),
          );
        } else {
          emit(PushNotificationErrorState(
            "Napaka pri shranjevanju, poskusite ponovno kasneje",
            event.type,
            event.eventId,
            true,
          ));
        }
      } else if (event.type == EventType.CULTURE) {
        final apiSuccess = await notificationRepo
            .subscribeToCultureNotification(event.eventId);
        if (apiSuccess) {
          emit(PushNotificationLoadedState(
            event.type,
            event.eventId,
            true,
          ));
        } else {
          emit(PushNotificationErrorState(
            "Napaka pri shranjevanju, poskusite ponovno kasneje",
            event.type,
            event.eventId,
            true,
          ));
        }
      }
    }
  }

  _onEventUnsubscribe(
      PushNotificationUnsubscribeEvent event, Emitter emit) async {
    emit(PushNotificationLoadingState());
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_generateKey(event)) ?? false) {
      emit(PushNotificationLoadedState(
        event.type,
        event.eventId,
        false,
      ));
    } else {
      if (event.type == EventType.SPORT) {
        final apiSuccess = await notificationRepo
            .unsubscribeToSportNotification(event.eventId);
        if (apiSuccess) {
          emit(PushNotificationLoadedState(
            event.type,
            event.eventId,
            false,
          ));
          prefs.setBool(_generateKey(event), false);
        } else {
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
          emit(PushNotificationLoadedState(
            event.type,
            event.eventId,
            false,
          ));
        } else {
          emit(PushNotificationErrorState(
            "Napaka pri shranjevanju, poskusite ponovno kasneje",
            event.type,
            event.eventId,
            false,
          ));
        }
      }
    }
  }
}
