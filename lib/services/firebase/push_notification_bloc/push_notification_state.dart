part of 'push_notification_bloc.dart';

@immutable
abstract class PushNotificationState {}

class PushNotificationInitial extends PushNotificationState {}

class PushNotificationLoadingState extends PushNotificationState {}

class PushNotificationLoadedState extends PushNotificationState {
  final EventType eventType;
  final int eventId;
  final bool subscribed;

  PushNotificationLoadedState(
    this.eventType,
    this.eventId,
    this.subscribed,
  );
}

class PushNotificationErrorState extends PushNotificationLoadedState {
  final String exceptionMessage;

  PushNotificationErrorState(
    this.exceptionMessage,
    EventType eventType,
    int eventId,
    bool subscribed,
  ) : super(eventType, eventId, subscribed);
}
