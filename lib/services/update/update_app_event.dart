part of 'update_app_bloc.dart';

@immutable
abstract class UpdateAppEvent {}

class CheckForUpdateEvent extends UpdateAppEvent {}
