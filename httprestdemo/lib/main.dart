import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Http ReST API Example'),
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
  late Future<DataReturned> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
      RefreshIndicator(
          child: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //return title, if title is null, return no title instead.
            if (snapshot.data?.scores.isNotEmpty == true) {
              //build a listview of the data.
              return ListView.builder(
                itemCount: snapshot.data!.scores.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                  key: Key(snapshot.data!.scores[index].id.toString()),
                  onDismissed: (direction) {
                    deleteScore(snapshot.data!.scores[index].id);
                    //we need to run set state and clean up the UI, even thought
                    //the data is going to update, because no await above.
                    setState(() {
                      snapshot.data!.scores.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  child: ListTile(
                    onTap: () {_displayTextInputDialogUpdate(context, snapshot.data!.scores[index].id, snapshot.data!.scores[index].name, snapshot.data!.scores[index].score);}, //updated score, call dialog.
                    title: Card(
                      child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              snapshot.data!.scores[index].id.toString()
                            ),
                            Text(
                              snapshot.data!.scores[index].name
                            ),
                            Text(
                              snapshot.data!.scores[index].score.toString()
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  );
                },

              );
            } else {
              return const Text("no data");
            }
          } else if (snapshot.hasError) {
            //on error just return the error.
            return Text("${snapshot.error}");
          } else {
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }
        },
      ),
        onRefresh: () { setState(() {
          futureData = fetchScore();
        }); return futureData; },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_displayTextInputDialog(context);},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //this function is used to delete a name and score from the server.
  Future<void> deleteScore(int id) async {
    final response = await http.delete(
      Uri.parse('http://wardpi.eecs.uwyo.edu:3000/api/scores/$id'),
    );
    //response.body would hold the return information from the server.
    if (response.statusCode != 200) {
      throw Exception('Failed to delete score');
    }
    // Remove the item from the data source.
    setState(() {
      //call the fetchScore function to update the data.
      futureData = fetchScore();
    });
  }

  //dialog to add a new name and score to the server.
  void _displayTextInputDialog(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();
    TextEditingController textFieldController2 = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a new score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textFieldController2,
                decoration: const InputDecoration(hintText: "Enter your name"),
              ),
              TextField(
                controller: textFieldController,
                decoration: const InputDecoration(hintText: "Enter your score"),
              ),

            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                //add the score to the server.
                addScore(textFieldController2.text, int.parse(textFieldController.text))
                    .then( (onValue) {
                    //call the fetchScore function to update the data.
                    setState(() {
                    futureData = fetchScore();
                   });
                });
                Navigator.pop(context);
              },
            ),

          ],
        );
      },
    );
  }

  // This function is used to add a new name and score to the server.
  Future<void> addScore(String name, int score) async {
    final response = await http.post(
      Uri.parse('http://wardpi.eecs.uwyo.edu:3000/api/scores'),
      body: {
        'name': name,
        'score': score.toString(),
      },
    );
    //response.body would hold the return information from the server.
    if ( response.statusCode >= 300) {
      throw Exception('Failed to add score ${response.statusCode}');
    }
  }

  // dialog to update the score for a name.
  void _displayTextInputDialogUpdate(BuildContext context, int id, String name, int score) {
    TextEditingController nameController = TextEditingController();
    TextEditingController scoreController = TextEditingController();
    nameController.text = name;
    scoreController.text = score.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update a score'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                id.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Enter your Name"),
              ),
              TextField(
                controller: scoreController,
                decoration: const InputDecoration(hintText: "Enter your score"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                //add the score to the server.
                log("updating score for $name to ${nameController.text}");
                updateScore(id, nameController.text, int.parse(scoreController.text)).then(
                    (value) {
                      //call the fetchScore function to update the data.
                      setState(() {
                        futureData = fetchScore();
                      });
                    }
                );
                Navigator.pop(context);
              },
            ),

          ],
        );
      },
    );
  }

  // this function is used to update the score for a name.
  Future<void> updateScore(int id, String name, int score) async {
    final response = await http.put(
      Uri.parse('http://wardpi.eecs.uwyo.edu:3000/api/scores/$id'),
      body: { 'name': name,
              'score': score.toString()},
    );
    //response.body would hold the return information from the server.
    if (response.statusCode >= 300) {
      throw Exception('Failed to update score');
    }
  }

  // This function is used to fetch the data from the server.
  Future<DataReturned> fetchScore() async {
    final response = await http.get(
      Uri.parse('http://wardpi.eecs.uwyo.edu:3000/api/scores'),
    );
    //response.body would hold the return information from the server.
    if (response.statusCode == 200) {
      return DataReturned.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load score');
    }
  }
}

class DataReturned {
  final bool error;
  List<Score> scores;

  DataReturned({required this.error, required this.scores});

  factory DataReturned.fromJson(Map<String, dynamic> json) {
    return DataReturned(
      error: json['error'],
      scores: (json['data'] as List).map((i) => Score.fromJson(i)).toList(),
    );
  }
}

class Score {
  final int id;
  final String name;
  final int score;

  Score({required this.id, required this.name, required this.score});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(id: json['id'], name: json['name'], score: json['score']);
  }
}
