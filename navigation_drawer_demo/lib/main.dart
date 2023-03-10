import 'package:flutter/material.dart';
import 'package:navigation_drawer_demo/drawer_widget.dart';

/// This example uses a lot of code from https://github.com/am1994/navigation_drawer
/// some changes and additions have been made as well.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const DrawerWidget(),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome to Home Screen'),
        ),
      ),
    );
  }

}

