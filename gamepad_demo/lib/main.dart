import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<GamepadEvent>? _subscription;

  List<GamepadController> _gamepads = [];
  List<GamepadEvent> _lastEvents = [];
  bool loading = false;

  Future<void> _getValue() async {
    setState(() => loading = true);
    final response = await Gamepads.list();
    setState(() {
      _gamepads = response;
      loading = false;
    });
  }

  void _clear() {
    setState(() => _lastEvents = []);
  }

  @override
  void initState() {
    super.initState();
    _subscription = Gamepads.events.listen((event) {
      setState(() {
        final newEvents = [
          event,
          ..._lastEvents,
        ];
        if (newEvents.length > 3) {
          newEvents.removeRange(3, newEvents.length);
        }
        _lastEvents = newEvents;
      });
    });
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamepads Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Last Events:'),
            ..._lastEvents.map((e) => Text(e.toString())),
            TextButton(
              onPressed: _clear,
              child: const Text('clear events'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _getValue,
              child: const Text('listGamepads()'),
            ),
            const Text('Gamepads:'),
            if (loading)
              const CircularProgressIndicator()
            else ...[
              for (final gamepad in _gamepads) ...[
                Text('${gamepad.id} - ${gamepad.name}'),
                Text('  Analog inputs: ${gamepad.state.analogInputs}'),
                Text('  Button inputs: ${gamepad.state.buttonInputs}'),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

