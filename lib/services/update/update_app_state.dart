part of 'update_app_bloc.dart';

@immutable
abstract class UpdateAppState {}

class UpdateAppInitial extends UpdateAppState {}

class CheckingForUpdateState extends UpdateAppState {}
class UpdatingAppState extends UpdateAppState {}
class AppUpdatedState extends UpdateAppState {}
class ErrorUpdateState extends UpdateAppState {}
