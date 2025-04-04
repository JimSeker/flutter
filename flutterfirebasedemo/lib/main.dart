import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

/// note, flutter is using a default of min of 16, required min is 21.  changed
/// manually in the android build.gradle file to 24.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
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
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: ThemeData.dark(),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(providers: [EmailAuthProvider()]);
        }

        // Render your application if authenticated
        return MyHomePage(title: "Firebase Demo");
      },
    );
  }
}

List<dataInfo> _dataInfos = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<QuerySnapshot>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _dataSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Fb Firestore example"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(FirebaseAuth.instance.currentUser?.email ?? "No email"),
              const SignOutButton(),
            ],
          ),
          ListTile(
            title: Text('This is the data:'),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          Flexible(
            //so this can draw the rest of the screen.
            child: ListView.builder(
              itemCount: _dataInfos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Card(
                    child: SizedBox(
                      width: 300,
                      height: 100,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              removeData(_dataInfos[index].id);
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          Text(
                            '${_dataInfos[index].last}, ${_dataInfos[index].first}, ${_dataInfos[index].middle} ${_dataInfos[index].born}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    updateData(index);
                  },
                );
              },
            ),
          ),
          //main list of data.
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add data",
        child: const Icon(Icons.add),
        onPressed: () {
          addData();
        },
      ),
    );
  }

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser != null) {
      //we are logged in and should get data.
      // Add from here
      _dataSubscription = FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((snapshot) {
            //first clear the data structure
            _dataInfos = [];
            setState(() {
              //add everything to the data structure, and which updates the UI.
              for (var document in snapshot.docs) {
                log("value is " + document.data()['first']);
                log(document.data()['born'].toString());
                log("id is ${document.id}");
                _dataInfos.add(
                  dataInfo(
                    first: document.data()['first'],
                    middle: document.data()['middle'] ?? "none",
                    last: document.data()['last'],
                    //born: document.data()['born'],
                    //this is getting a weird error string to int, so this is a workaround.
                    born:
                        document.data()['born'] is int
                            ? document.data()['born']
                            : int.parse(document.data()['born']),
                    id: document.id,
                  ),
                );
              }
            });
          });
    } else {
      // Add from here
      setState(() {
        _dataInfos = [];
      });
      _dataSubscription?.cancel();
      // to here.
    }
    ;
  }

  void addData() {
    final TextEditingController firstName = TextEditingController();
    final TextEditingController middleName = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController bDay = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstName,
                decoration: const InputDecoration(helperText: "First Name"),
              ),
              TextFormField(
                controller: middleName,
                decoration: const InputDecoration(helperText: "Middle Name"),
              ),
              TextFormField(
                controller: lastName,
                decoration: const InputDecoration(helperText: "Last Name"),
              ),
              TextFormField(
                controller: bDay,
                decoration: const InputDecoration(helperText: "Birth Year"),
              ),
            ],
          ),
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
      if (val == "OK") {
        fireStoreAddData(
          //making sure there is data here.
          firstName.text != "" ? firstName.text : "Fred",
          middleName.text != "" ? middleName.text : "George",
          lastName.text != "" ? lastName.text : "Flintstone",
          bDay.text != "" ? int.parse(bDay.text) : -10,
        );
      }
    });
  }

  Future<void> fireStoreAddData(
    String first,
    String middle,
    String last,
    int born,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first': first,
      'last': last,
      'born': born,
      'middle': middle,
    });
  }

  void updateData(int index) {
    final TextEditingController firstName = TextEditingController();
    final TextEditingController middleName = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController bYear = TextEditingController();

    firstName.text = _dataInfos[index].first;
    middleName.text = _dataInfos[index].middle;
    lastName.text = _dataInfos[index].last;
    bYear.text = "${_dataInfos[index].born}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstName,
                decoration: const InputDecoration(helperText: "First Name"),
              ),
              TextFormField(
                controller: middleName,
                decoration: const InputDecoration(helperText: "Middle Name"),
              ),
              TextFormField(
                controller: lastName,
                decoration: const InputDecoration(helperText: "Last Name"),
              ),
              TextFormField(
                controller: bYear,
                decoration: const InputDecoration(helperText: "Birth Year"),
              ),
            ],
          ),
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
      if (val == "OK") {
        fireStoreUpdateData(
          _dataInfos[index].id,
          firstName.text != "" ? firstName.text : "Fred",
          middleName.text != "" ? middleName.text : "none",
          lastName.text != "" ? lastName.text : "Flintstone",
          bYear.text != "" ? int.parse(bYear.text) : -10,
        );
      }
    });
  }

  Future fireStoreUpdateData(
    String id,
    String first,
    String middle,
    String last,
    int born,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'first': first,
      'last': last,
      'born': born,
      'middle': middle,
    });
  }

  Future removeData(String id) {
    return FirebaseFirestore.instance.collection('users').doc(id).delete();
  }
}

class dataInfo {
  dataInfo({
    required this.first,
    required this.middle,
    required this.last,
    required this.born,
    required this.id,
  });

  final String first;
  final String middle;
  final String last;
  final int born;
  final String id;
}
