part of 'concert_detail_cubit.dart';

@immutable
abstract class ConcertDetailState {}

class ConcertDetailInitial extends ConcertDetailState {}

class ConcertDetailLoadingState extends ConcertDetailState {}

class ConcertDetailErrorState extends ConcertDetailState {}

class ConcertDetailLoadedState extends ConcertDetailState {
  final ConcertEvent event;

  ConcertDetailLoadedState(this.event);
}