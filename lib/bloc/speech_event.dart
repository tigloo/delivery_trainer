part of 'speech_bloc.dart';

@immutable
abstract class SpeechEvent {}

class Initialized extends SpeechEvent {
  final List<String> newSegments;
  Initialized({required this.newSegments});
}

class Advanced extends SpeechEvent {}

class Started extends SpeechEvent {}

class Stopped extends SpeechEvent {}
