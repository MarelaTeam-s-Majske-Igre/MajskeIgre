part of 'culture_detail_cubit.dart';

@immutable
abstract class CultureDetailState {}

class CultureDetailInitial extends CultureDetailState {}

class CultureDetailLoadingState extends CultureDetailState {}

class CultureDetailErrorState extends CultureDetailState {}

class CultureDetailLoadedState extends CultureDetailState {
  final CultureEvent event;

  CultureDetailLoadedState(this.event);
}
