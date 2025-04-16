import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Audio Player Demo'),
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
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
   // _audioPlayer.setAsset('assets/hmscream.mp3');

    // Set a sequence of audio sources that will be played by the audio player.
    _audioPlayer
        .setAudioSource(
          ConcatenatingAudioSource(
            children: [
              AudioSource.asset('assets/hmscream.mp3'),
              AudioSource.uri(
                Uri.parse(
                  "https://archive.org/download/IGM-V7/IGM%20-%20Vol.%207/25%20Diablo%20-%20Tristram%20%28Blizzard%29.mp3",
                ),
              ),
              AudioSource.uri(
                Uri.parse(
                  "https://archive.org/download/igm-v8_202101/IGM%20-%20Vol.%208/15%20Pokemon%20Red%20-%20Cerulean%20City%20%28Game%20Freak%29.mp3",
                ),
              ),
              AudioSource.uri(
                Uri.parse(
                  "https://scummbar.com/mi2/MI1-CD/01%20-%20Opening%20Themes%20-%20Introduction.mp3",
                ),
              ),
            ],
          ),
        )
        .catchError((error) {
          // catch load errors: 404, invalid url ...
          print("An error occurred $error");
        });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            // return _playerButton(playerState);
            if (playerState?.processingState == ProcessingState.loading ||
                playerState?.processingState == ProcessingState.buffering) {
              return const CircularProgressIndicator();
            } else {
              //we can play the audio
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.play();
                    },
                    child: const Text("Play"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.pause();
                    },
                    child: const Text("Pause"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.seek(Duration.zero);
                      _audioPlayer.play();
                    },
                    child: const Text("Replay"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
