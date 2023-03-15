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
  double value = 50;
  String okcanel = "No value";
  String input1 = "nothing1", input2 = "nothing2";
  String selectedLanguage = "none";

  @override
  Widget build(BuildContext context) {
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
                  showDialog(
                      context: context,
                      builder: (context) => DialogExample(
                            onConfirm: (String one, String two) {
                              setState(() {
                                input1 = one;
                                input2 = two;
                              });
                            },
                          ));
                  // so now set it in a setState so widget updates.
                },
                child: const Text('Slider dialog')),
            Text("Selected langage is $selectedLanguage")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {showSimpleAlertDialog(context);},
        tooltip: 'Pick a language',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //Uses the future values to setup a dialog.  Note this is in the same class above
  //so we can use the variable above.

  showSimpleAlertDialog(BuildContext context) {
    //Create a SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Select a language'),
      children: <Widget>[
        SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'JavaScript');
            },
            child: const Text('JavaScript')),
        SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'Dart');
            },
            child: const Text('Dart')),
        SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'Java');
            },
            child: const Text('Java')),
        SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'Kotlin');
            },
            child: const Text('Kotlin'))
      ],
    );

// Call showDialog function to show dialog.
    Future futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
    futureValue.then((language) => {
          setState(() {
            selectedLanguage = language;
          })
        });
  }
}
