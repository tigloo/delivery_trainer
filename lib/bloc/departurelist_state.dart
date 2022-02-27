part of 'departurelist_bloc.dart';

class DepartureListEntry {}

abstract class DepartureListState extends Equatable {
  const DepartureListState();

  @override
  List<Object> get props => [];
}

class CurrentDepartureList extends DepartureListState {
  final List<Departure> departures;
  final int currentDeparture;

  const CurrentDepartureList(
      {required this.departures, required this.currentDeparture});

  @override
  List<Object> get props => [departures, currentDeparture];
}
