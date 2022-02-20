import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:meta/meta.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final flutterTts = FlutterTts();

  SpeechBloc()
      : super(
            SpeechText(segments: const [], currentSegment: 0, playing: false)) {
    // the line below is needed as otherwise the plugin will crash and also not
    // call any completion handlers
    flutterTts.awaitSpeakCompletion(true);

    flutterTts.setCompletionHandler(advance);

    on<Initialized>((event, emit) {
      emit(SpeechText(
          segments: event.newSegments, currentSegment: 0, playing: false));
    });

    on<Advanced>((event, emit) {
      final currentState = state as SpeechText;

      emit(currentState.copy(
          currentSegment: currentState.currentSegment + 1, playing: true));
    });

    on<Started>((event, emit) {
      final currentState = state as SpeechText;

      emit(currentState.copy(playing: true));
    });

    on<Stopped>((event, emit) {
      final currentState = state as SpeechText;

      emit(currentState.copy(playing: false));
    });
  }

  void _playSegment(int segment) {
    flutterTts.stop();

    final currentState = state as SpeechText;

    if (segment >= currentState.segments.length) {
      return;
    }

    flutterTts.speak(currentState.segments[segment]);
  }

  void initialize(List<String> segments) {
    final currentState = state as SpeechText;

    if (currentState.playing) {
      stop();
    }

    add(Initialized(newSegments: segments));
  }

  void start() {
    final currentState = state as SpeechText;

    if (currentState.playing) {
      return;
    }

    _playSegment(0);

    add(Started());
  }

  void stop() {
    flutterTts.stop();
    add(Stopped());
  }

  void advance() {
    final currentState = state as SpeechText;

    if (currentState.currentSegment - 1 < currentState.segments.length) {
      _playSegment(currentState.currentSegment + 1);
      add(Advanced());
    }
  }
}
