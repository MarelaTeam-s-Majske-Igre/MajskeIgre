part of 'push_notification_bloc.dart';

@immutable
abstract class PushNotificationEvent {
  final EventType type;
  final int eventId;

  const PushNotificationEvent(this.type, this.eventId);
}

class PushNotificationInitialLoadEvent extends PushNotificationEvent {
  const PushNotificationInitialLoadEvent(EventType type, int eventId) : super(type, eventId);
}

class PushNotificationLoadEvent extends PushNotificationEvent {
  const PushNotificationLoadEvent(EventType type, int eventId) : super(type, eventId);
}

class PushNotificationSubscribeEvent extends PushNotificationEvent {
  const PushNotificationSubscribeEvent(EventType type, int eventId) : super(type, eventId);
}

class PushNotificationUnsubscribeEvent extends PushNotificationEvent {
  const PushNotificationUnsubscribeEvent(EventType type, int eventId) : super(type, eventId);
}
