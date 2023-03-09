import 'package:flutter/material.dart';
import 'dialogslider.dart';
import 'DialogExample.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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
  double value = 50;
  String okcanel = "No value";
  String input1 = "nothing1",
      input2 = "nothing2";

  void showdialog() {}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Answer is : $okcanel"),
            //this is an inline simple dialog box.  it would be a question with
            // a yes or no/cancel that return back via the .then and updates the
            // text field above.
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('AlertDialog Title'),
                        content: const Text('AlertDialog description'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  ).then((val) {
                    setState(() {
                      okcanel = val;
                    });
                  });
                },
                child: const Text("Answer it")),
            Text("Slider value is $value"),
            //this one uses async to get the return value and the dialog in in the dialogslider.dart file.
            ElevatedButton(
                onPressed: () async {
                  double? val = await showDialog<double>(
                    context: context,
                    builder: (context) => DialogSlider(val: value),
                  );
                  //val has the return value, so now set it in a setState so widget updates.
                  setState(() {
                    value = val!;
                  });
                },
                child: const Text('Slider dialog')),
            Text("dialog example data: $input1, $input2"),
            //this one uses async to get the return of 2 strings vai a callback method.
            //the dialog in in the dialogExample.dart file.
            ElevatedButton(
                onPressed: () {
                  showDialog(context: context,
                      builder: (context) => DialogExample(
                        onConfirm: (String one, String two) {
                           setState( () {
                              input1 = one;
                              input2 = two;
                           });
                        },
                      ));
                  //val has the return value, so now set it in a setState so widget updates.

                },
                child: const Text('Slider dialog')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
