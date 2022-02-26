part of 'speech_bloc.dart';

@immutable
abstract class SpeechState {}

class SpeechStopped extends SpeechState {}

class SpeechPlaying extends SpeechState {}
