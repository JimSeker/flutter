import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

///NOte for this to work on android, you must go add permission the manifest.xml file and a queries
///see documentation, https://pub.dev/packages/speech_to_text

class SpeechToTextWidget extends StatefulWidget {
  const SpeechToTextWidget({super.key});

  @override
  SpeechToTextState createState() => SpeechToTextState();
}

class SpeechToTextState extends State<SpeechToTextWidget> {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool listening = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  /// This has to happen only once per app
   initSpeech() async {
    speechToText
        .initialize(onError: errorListener, onStatus: statusListener)
        .then((value) {
      setState(() {
        message += "initialized is $value.\n";
      });
      speechEnabled = value;
      return ;
    });
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    if (speechEnabled) {
      //await speechToText.listen(onResult: onSpeechResult, partialResults: false);
      await speechToText.listen(onResult: onSpeechResult);
      setState(() {
        message += "Speech to text started.\n";
        listening = true;
      });
    } else {
      setState(() {
        message += "Speech not started, not initialized?.\n";
      });
    }
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      listening = speechToText.isListening;
      message += '${error.errorMsg} - ${error.permanent} \n';
    });
  }

  void statusListener(String status) {
    setState(() {
      listening = speechToText.isListening;
      message += 'Received listener status: $status \n';
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    if (speechEnabled) await speechToText.stop();
    setState(() {
      message += "Speech to text stopped.\n";
      listening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      String words = result.recognizedWords;
      if (words.isNotEmpty) {
        message += "$words\n";
      } else {
        message += "no words recognized.\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (listening)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: stopListening,
                    icon: const Icon(Icons.stop, color: Colors.red),
                    label: const Text('Stop'),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Text(
                    "Logger:\n $message",
                    overflow: TextOverflow.visible,
                  ))),
                ],
              )
            : Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: startListening,
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.green,
                    ),
                    label: const Text('Start'),
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
