import 'package:flutter/material.dart';
import 'package:navigation_drawer_demo/second_view.dart';
import 'package:navigation_drawer_demo/third_view.dart';
import 'package:navigation_drawer_demo/first_view.dart';
import 'package:navigation_drawer_demo/main_view.dart';
import 'package:navigation_drawer_demo/routes/routes.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainView(),
      routes: {
        routes.main: (context) => MainView(),
        routes.first: (context) => FirstView(),
        routes.second: (context) => SecondView(),
        routes.third: (context) => ThirdView(),
      },
    );
  }
}
