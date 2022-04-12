part of 'sport_notification_cubit.dart';

@immutable
abstract class SportNotificationState {}

class SportNotificationInitial extends SportNotificationState {}

class SportNotificationLoadingState extends SportNotificationState {}

class SportNotificationLoadedState extends SportNotificationState {
  final bool subscribed;
  SportNotificationLoadedState(this.subscribed);
}
