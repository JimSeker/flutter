import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_tts/flutter_tts.dart';

///Simple example of text to speech.  There lots more settings and
///things you can do.  this just gets the basics going.
///
/// https://pub.dev/packages/flutter_tts

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  TextToSpeechState createState() => TextToSpeechState();
}

class TextToSpeechState extends State<TextToSpeech> {
  bool listening = false;
  String message = "";
  TextEditingController msg = TextEditingController();

  late FlutterTts flutterTts;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWindows => !kIsWeb && Platform.isWindows;

  bool get isWeb => kIsWeb;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        developer.log("Playing");
        message += "Playing\n";
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          developer.log("TTS Initialized");
          message += "TTS Initialized\n";
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        developer.log("Complete");
        message += "Playing Complete\n";
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        developer.log("Cancel");
        message += "Cancel\n";
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        developer.log("Paused");
        message += "Paused\n";
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        developer.log("Continued");
        message += "continued\n";
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        developer.log("error: $msg");
        message += "error: $msg";
      });
    });
  }

  void speak() async {
    if (msg.text.isEmpty) return;

    //start speaking.
    await flutterTts.speak(msg.text);
  }

  Future stop() async {
    if (isWeb) {
      setState(() => message += "Stop is broken on web, ignoring.\n");
      return;
    }

    var result = await flutterTts.stop();
    if (result == 1) setState(() => message += "Stop\n");
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => message += "Paused\n");
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
            controller: msg,
            decoration:
                const InputDecoration(helperText: "Enter message to speak")),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: speak,
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.green,
              ),
              label: const Text('Play'),
            ),
            ElevatedButton.icon(
              onPressed: pause,
              icon: const Icon(Icons.pause, color: Colors.amber),
              label: const Text('Pause'),
            ),
            ElevatedButton.icon(
              onPressed: stop,
              icon: const Icon(Icons.stop, color: Colors.red),
              label: const Text('Stop'),
            ),
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Text(
          "Logger:\n $message",
          overflow: TextOverflow.visible,
        ))),
      ],
    ));
  }
}
