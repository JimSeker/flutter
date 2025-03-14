import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const FirstRoute(title: 'First Route'),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key, required this.title});
  final String title;

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {

  String returnvalue = "none";

   SetReturnvalue(String value) {
    setState(() {
      returnvalue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'First Route',
            ),
            ElevatedButton(
              child: const Text('Go to Second Route'),
              onPressed: () {
                navigateAndDisplaySelection(context, "Hi there");
              },
            ),
            Text("Return value: $returnvalue"),
          ],
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
  Future<void> navigateAndDisplaySelection(BuildContext context, String sendData) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute(data: sendData)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!context.mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
    SetReturnvalue(result);
  }

}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key, required this.data });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Second Route"),
      ),
      body: Center(
        child:  Column(
          children: <Widget>[
            Text("Second Route"),
            Text("Data: $data"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "Hi back!");
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}