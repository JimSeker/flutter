import 'package:flutter/material.dart';

import 'drawer_widget.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});
  static const String routeName = '/first';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First View'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To First View'),
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}