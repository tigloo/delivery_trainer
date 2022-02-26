import 'package:equatable/equatable.dart';

class Departure extends Equatable {
  final String callsign;
  final String destination;
  final String sid;
  final String squawk;

  const Departure(
      {required this.callsign,
      required this.destination,
      required this.sid,
      required this.squawk});

  @override
  List<Object?> get props => [callsign, destination, sid, squawk];
}
