part of 'speech_bloc.dart';

@immutable
abstract class SpeechEvent {}

class Started extends SpeechEvent {}

class Stopped extends SpeechEvent {}
