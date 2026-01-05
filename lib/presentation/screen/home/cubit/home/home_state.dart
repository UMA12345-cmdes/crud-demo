part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<NoteModel> notes;

  HomeSuccess({required this.notes});
}

class HomeFailed extends HomeState {
  final String error;
  HomeFailed({required this.error});
}
