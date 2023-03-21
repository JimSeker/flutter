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

  final Future<FirebaseApp> _fbapp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

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
      body: ListView(children: <Widget>[
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is the data:',
            ),
          ],
        ),
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(children: [
                  SizedBox(height: 400, child: dataList()),
                ])),
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(children: [
                  StyledButton(
                      child: Text('Add new data'),
                      onPressed: () {
                        appState.addData();
                      })
                ])),
      ]),
    );
  }
}

List<dataInfo> _dataInfos = [];

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    //anonymous authentication
    /*
    FirebaseAuth.instance.signInAnonymously().whenComplete(() =>
        _dataSubscription = FirebaseFirestore.instance
            .collection('users')
            .snapshots()
            .listen((snapshot) {
          _dataInfos = [];
          snapshot.docs.forEach((document) {
            print("value is " + document.data()!['first']);

            _dataInfos.add(
              dataInfo(
                first: document.data()!['first'],
                //middle:  document.data?()['middle']  ,
                last: document.data()!['last'],
                born: document.data()!['born'],
              ),
            );
          });
          notifyListeners();
        }));
     */
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        // Add from here
        _dataSubscription = FirebaseFirestore.instance
            .collection('users')
            .snapshots()
            .listen((snapshot) {
          _dataInfos = [];
          snapshot.docs.forEach((document) {
            print("value is " + document.data()!['first']);

            _dataInfos.add(
              dataInfo(
                first: document.data()!['first'],
                //middle:  document.data?()['middle']  ,
                last: document.data()!['last'],
                born: document.data()!['born'],
              ),
            );
          });
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

  Future<DocumentReference> addData() {
    return FirebaseFirestore.instance.collection('users').add({
      'first': "Fred",
      'last': "Flintstone",
      'born': -10000,
      'middle': "George"
    });
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
      //   required this.middle,
      required this.last,
      required this.born});

  final String first;

  // final String middle;
  final String last;
  final int born;
}

class dataList extends StatefulWidget {
  @override
  _dataListState createState() => _dataListState();
}

class _dataListState extends State<dataList> {
  @override
  // Modify from here
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _dataInfos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${_dataInfos[index].last}, ${_dataInfos[index].first}'),
        );
      },
    );
  }
}
