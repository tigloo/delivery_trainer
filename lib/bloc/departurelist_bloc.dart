import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:delivery_trainer/departure.dart';
import 'package:delivery_trainer/extensions.dart';
import 'package:equatable/equatable.dart';

part 'departurelist_event.dart';
part 'departurelist_state.dart';

class DepartureListBloc extends Bloc<DepartureListEvent, DepartureListState> {
  static const _nrOfDepartures = 10;

  static const _callsigns = <String>[
    'DLH414',
    'AUA74R',
    'CFG724',
    'DLH9814',
    'DEIPA',
    'TUI1RG',
    'EZY28U',
    'BAW742L',
    'SAS242',
    'RYR362',
    'GWI7EK'
  ];

  static const _destinations = <String>[
    'EDDF',
    'EDDM',
    'EDDB',
    'LSZH',
    'EKCH',
    'EBBR',
    'EHAM',
    'KJFK',
    'ESSA',
    'EFHK',
    'LFMN',
  ];

  static const _routes = <String>[
    'AKANU6M',
    'AKANU8K',
    'DKB4M',
    'DKB4K',
    'ERETO6M',
    'ERETO7K',
    'IBAGA2M',
    'IBAGA2K',
    'RODIS4M',
    'RODIS3K',
    'SUKAD2M',
    'SUKAD2K',
    'SULUS3M',
    'SULUS3K',
    'ERL9M',
    'ERL8K',
  ];

  static const _squawks = <String>[
    '1000',
    '2342',
    '2345',
    '2348',
    '2349',
    '2350',
    '2353',
  ];

  final Random _random = Random();

  DepartureListBloc()
      : super(
            const CurrentDepartureList(currentDeparture: -1, departures: [])) {
    on<DepartureCleared>((event, emit) {
      // remove current departure from the list, generate a new one
      // and publish the state
      final currentState = state as CurrentDepartureList;

      List<Departure> updatedList =
          List.from(currentState.departures, growable: true);

      if (currentState.currentDeparture >= 0 &&
          currentState.currentDeparture < currentState.departures.length) {
        updatedList.removeAt(currentState.currentDeparture);
      }

      while (updatedList.length < _nrOfDepartures) {
        updatedList.add(_generateDeparture());
      }

      emit(CurrentDepartureList(
          departures: updatedList,
          currentDeparture: _random.nextInt(updatedList.length - 1)));
    });

    // manually clear one departure to force initialization of the bloc
    add(DepartureCleared());
  }

  Departure _generateDeparture() {
    return Departure(
      callsign: _callsigns.randomElement(),
      destination: _destinations.randomElement(),
      sid: _routes.randomElement(),
      squawk: _squawks.randomElement(),
    );
  }
}
