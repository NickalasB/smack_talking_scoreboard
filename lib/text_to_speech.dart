import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { PLAYING, STOPPED }

class TextToSpeech {
  FlutterTts flutterTts;

  TtsState ttsState = TtsState.STOPPED;

  double volume = 1.0;

  get isPlaying => ttsState == TtsState.PLAYING;

  get isStopped => ttsState == TtsState.STOPPED;

  void initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      print("playing");
      ttsState = TtsState.PLAYING;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.STOPPED;
    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState = TtsState.STOPPED;
    });
  }

  Future speak(String phrase) async {
    await flutterTts.setVolume(volume);

    if (ttsState != TtsState.PLAYING) {
      var result = await flutterTts.speak(phrase);
      if (result == 1) ttsState = TtsState.PLAYING;
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.STOPPED;
  }
}
