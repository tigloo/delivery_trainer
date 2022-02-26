import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:meta/meta.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final flutterTts = FlutterTts();

  List<String> segments = [];
  int currentSegment = 0;
  bool playing = false;

  SpeechBloc() : super(SpeechStopped()) {
    // the line below is needed as otherwise the plugin will crash and also not
    // call any completion handlers
    flutterTts.awaitSpeakCompletion(true);

    flutterTts.setCompletionHandler(advance);

    segments = [];
    currentSegment = 0;
    playing = false;

    on<Started>((event, emit) {
      emit(SpeechStopped());
    });

    on<Stopped>((event, emit) {
      emit(SpeechPlaying());
    });
  }

  void _playSegment(int segment) {
    flutterTts.stop();

    if (segment >= segments.length) {
      return;
    }

    flutterTts.speak(segments[segment]);
    currentSegment = segment;

    add(Started());
  }

  void initialize(List<String> segments) {
    if (playing) {
      stop();
    }
    currentSegment = 0;
    this.segments = segments;
  }

  void start() {
    if (playing) {
      return;
    }

    _playSegment(0);
  }

  void stop() {
    flutterTts.stop();
    add(Stopped());
  }

  void advance() {
    if (currentSegment - 1 < segments.length) {
      _playSegment(currentSegment + 1);
    }
  }
}
