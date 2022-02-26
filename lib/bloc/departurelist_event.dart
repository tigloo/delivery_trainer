part of 'departurelist_bloc.dart';

abstract class DepartureListEvent extends Equatable {
  const DepartureListEvent();

  @override
  List<Object> get props => [];
}

class DepartureCleared extends DepartureListEvent {}
