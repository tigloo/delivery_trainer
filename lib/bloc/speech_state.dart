part of 'speech_bloc.dart';

@immutable
abstract class SpeechState {}

class SpeechText extends SpeechState {
  final List<String> segments;
  final int currentSegment;
  final bool playing;

  SpeechText(
      {required this.segments,
      required this.currentSegment,
      required this.playing});

  SpeechText copy(
      {List<String>? segments, int? currentSegment, bool? playing}) {
    return SpeechText(
      segments: segments ?? this.segments,
      currentSegment: currentSegment ?? this.currentSegment,
      playing: playing ?? this.playing,
    );
  }
}
