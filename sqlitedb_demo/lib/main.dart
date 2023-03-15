import 'dart:async';

import 'package:flutter/material.dart';
import 'highscore.dart';

//https://suragch.medium.com/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
//https://docs.flutter.dev/cookbook/persistence/sqlite#example

// Here we are using a global variable. You can use something like
// get_it in a production app.
final dbHelper = DatabaseHelper();
late List<HighScore>
    myList; //I'd prefer it not global, but con't find a better way.

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbHelper.init();
  myList = await dbHelper
      .queryAllRows(); //not sure if that is the correct way to do this, but I need list initialized for the listview.
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: myList.length ?? 0,
        //just in case the future hasn't returned yet.
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(myList[index].toString()),
            onTap: () {
              _ontap(myList[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: insert,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _ontap(HighScore item) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();
    nameController.text = item.name;
    scoreController.text = item.score.toString();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Update data"),
              content: Column(children: [
                TextFormField(
                  controller: nameController,
                ),
                TextFormField(
                  controller: scoreController,
                )
              ]),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    _delete(item.id);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    item.score = int.parse(scoreController.text);
                    item.name = nameController.text;
                    _update(item);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void insert() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Add data"),
              content: Column(children: [
                TextFormField(
                  controller: nameController,
                ),
                TextFormField(
                  controller: scoreController,
                )
              ]),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    HighScore row = HighScore(
                        id: -1,
                        name: nameController.text,
                        score: int.parse(scoreController.text));
                    _insert(row);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _insert(HighScore row) async {
    // row to insert id should be ignored, so -1 is okay.
    //HighScore row = HighScore(id:-1, name: 'Jim', score:3012);

    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
    _query().then((values) {
      setState(() {
        myList = values;
      });
    });
  }

  Future<List<HighScore>> _query() async {
    return await dbHelper.queryAllRows();
  }

  void _update(HighScore row) async {
    // row to update
    // HighScore row = const HighScore(
    //   id: 1,
    //   name: 'Mary',
    //   score: 32
    // );
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
    _query().then((values) {
      setState(() {
        myList = values;
      });
    });
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
    _query().then((values) {
      setState(() {
        myList = values;
      });
    });
  }
}
