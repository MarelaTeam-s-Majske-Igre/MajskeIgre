part of 'sport_detail_cubit.dart';

@immutable
abstract class SportDetailState {}

class SportDetailInitial extends SportDetailState {}

class SportDetailLoadingState extends SportDetailState {}

class SportDetailErrorState extends SportDetailState {}

class SportDetailLoadedState extends SportDetailState {
  final SportEvent event;

  SportDetailLoadedState(this.event);
}