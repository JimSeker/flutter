import 'package:flutter/material.dart';
import 'package:navigation_drawer_demo/drawer_widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main View'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To Main View'),
        ),
      ),
     //endDrawer:  const DrawerWidget(),
      drawer: const DrawerWidget(screen: 3),
    );
  }
}