import 'package:flutter/material.dart';

/// an example of how to use a listview with tap event for each item
/// and an imput dialog to add more ot the list
/// This page was of great help for the dialog boxes.
/// https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'ListView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var values = [
    "Android",
    "iPhone",
    "WindowsMobile",
    "Blackberry",
    "WebOS",
    "Ubuntu",
    "Windows7",
    "Max OS X",
    "Linux",
    "OS/2"
  ];

  TextEditingController _textFieldController = TextEditingController();
  String valueText;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add an OS to the list'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter name here"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    values.add(valueText);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _ontap(String item) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Material Dialog"),
              content: new Text("Hi Value is $item"),
              actions: <Widget>[
                TextButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${values[index]}'),
            onTap: () {
              _ontap(values[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textFieldController
              .clear(); //since we use several times. clear before it called.
          _displayTextInputDialog(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
