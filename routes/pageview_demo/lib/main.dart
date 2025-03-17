import 'package:flutter/material.dart';

/// Example of using the pageview. while it has the code for android, ios and web
/// it doesn't actually work on the web. I can't trigger a page change in the browser with a swipe.
/// works fine on mobile.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageView Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'PageView demo Page'),
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
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PageView(
        controller: controller,
        // scrollDirection: Axis.vertical,
        children: const <Widget>[
          Icon(Icons.flight, size: 350),
          Icon(Icons.directions_bike, size: 350),
          Icon(Icons.directions_boat, size: 350),
          Icon(Icons.directions_bus, size: 350),
          Icon(Icons.directions_car, size: 350),
        ],
      ),
    );
  }
}
