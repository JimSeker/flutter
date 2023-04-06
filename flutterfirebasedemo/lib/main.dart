import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

/// note, flutter is using a default of min of 16, required min is 21.  changed
/// manually in the android build.gradle file to 24.

Future<void> main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _fbapp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        darkTheme: ThemeData.dark(),
        home: FutureBuilder(
          future: _fbapp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('You have an error! ${snapshot.error.toString()}');
              return const Text('Something went wrong!');
            } else if (snapshot.hasData) {
              return const MyHomePage(
                title: "Firebase Demo",
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
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
        title: const Text("Fb Firestone example"),
      ),
      body: Column(children: <Widget>[
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
            email: appState.email,
            loginState: appState.loginState,
            startLoginFlow: appState.startLoginFlow,
            verifyEmail: appState.verifyEmail,
            signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
            cancelRegistration: appState.cancelRegistration,
            registerAccount: appState.registerAccount,
            signOut: appState.signOut,
          ),
        ),
        const ListTile(
          title: Text(
            'This is the data:',
          ),
          tileColor: Colors.blue,
        ),
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Expanded(child: dataList()),
        ),
      ]),
      floatingActionButton: Consumer<ApplicationState>(
          builder: (context, appState, _) => FloatingActionButton(
              tooltip: "Add data",
              child: const Icon(Icons.add),
              onPressed: () {
                addData(appState);
              })),
    );
  }

  void addData(appState) {
    final TextEditingController firstName = TextEditingController();
    final TextEditingController middleName = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController bDay = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Data'),
          content: Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                    controller: firstName,
                    decoration:
                        const InputDecoration(helperText: "First Name")),
                TextFormField(
                    controller: middleName,
                    decoration:
                        const InputDecoration(helperText: "Middle Name")),
                TextFormField(
                    controller: lastName,
                    decoration: const InputDecoration(helperText: "Last Name")),
                TextFormField(
                    controller: bDay,
                    decoration:
                        const InputDecoration(helperText: "Birth Year")),
              ]),
            ),
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
        appState.addData(
            //making sure there is data here.
            firstName.text != "" ? firstName.text : "Fred",
            middleName.text != "" ? middleName.text : "George",
            lastName.text != "" ? lastName.text : "Flintstone",
            bDay.text != "" ? int.parse(bDay.text) : -10);
      }
    });
  }
}

List<dataInfo> _dataInfos = [];

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        // Add from here
        _dataSubscription = FirebaseFirestore.instance
            .collection('users')
            .snapshots()
            .listen((snapshot) {
          _dataInfos = [];
          for (var document in snapshot.docs) {
            print("value is " + document.data()['first']);
            print("id is " + document.id);

            _dataInfos.add(
              dataInfo(
                first: document.data()['first'],
                middle: document.data()['middle'] ?? "none",
                last: document.data()['last'],
                born: document.data()['born'],
                id: document.id,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        // Add from here
        _dataInfos = [];
        _dataSubscription?.cancel();
        // to here.
      }
      notifyListeners();
    });
  }

  StreamSubscription<QuerySnapshot>? _dataSubscription;

  Future<DocumentReference> addData(
      String first, String middle, String last, int born) {
    return FirebaseFirestore.instance.collection('users').add({
      'first': first,
      'last': last,
      'born': born,
      'middle': middle,
    });
  }

  Future updateData(
      String id, String first, String middle, String last, int born) {
    return FirebaseFirestore.instance.collection('users').doc(id).update({
      'first': first,
      'last': last,
      'born': born,
      'middle': middle,
    });
  }

  Future removeData(String id) {
    return FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  //everything needed for the authentication method

  ApplicationLoginState get loginState => _loginState;
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  String? _email;

  String? get email => _email;

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //await credential.user!.updateProfile(displayName: displayName);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

//---------------------------------------------------
}

class dataInfo {
  dataInfo(
      {required this.first,
      required this.middle,
      required this.last,
      required this.born,
      required this.id});

  final String first;
  final String middle;
  final String last;
  final int born;
  final String id;
}

class dataList extends StatefulWidget {
  @override
  dataListState createState() => dataListState();
}

class dataListState extends State<dataList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => ListView.builder(
              itemCount: _dataInfos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          appState.removeData(_dataInfos[index].id);
                        },
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      Text(
                          '${_dataInfos[index].last}, ${_dataInfos[index].first}, ${_dataInfos[index].born}'),
                    ],
                  ),
                  onTap: () {updateData(appState, index);},
                );
              },
            ));
  }


  void updateData(appState, int index) {
    final TextEditingController firstName = TextEditingController();
    final TextEditingController middleName = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController bYear = TextEditingController();

    firstName.text = _dataInfos[index].first;
    middleName.text = _dataInfos[index].middle;
    lastName.text = _dataInfos[index].last;
    bYear.text =  "${_dataInfos[index].born}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Data'),
          content: Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                    controller: firstName,
                    decoration:
                    const InputDecoration(helperText: "First Name")),
                TextFormField(
                    controller: middleName,
                    decoration:
                    const InputDecoration(helperText: "Middle Name")),
                TextFormField(
                    controller: lastName,
                    decoration: const InputDecoration(helperText: "Last Name")),
                TextFormField(
                    controller: bYear,
                    decoration:
                    const InputDecoration(helperText: "Birth Year")),
              ]),
            ),
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
        appState.updateData(
          _dataInfos[index].id,
            firstName.text != "" ? firstName.text : "Fred",
            middleName.text != "" ? middleName.text : "George",
            lastName.text != "" ? lastName.text : "Flintstone",
            bYear.text != "" ? int.parse(bYear.text) : -10);
      }
    });
  }
}
