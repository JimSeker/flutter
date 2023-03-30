import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_demo/speechtotext.dart';
import 'package:speech_demo/texttospeech.dart';

//note android build.gradle hard coded set to minsdk of 24, because plugins require higher then 16.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (selectedIndex == 0) ? const TextToSpeech() : const SpeechToTextWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            label: 'Test to speech',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Speech to Text',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
