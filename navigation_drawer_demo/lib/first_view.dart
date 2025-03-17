import 'package:flutter/material.dart';

import 'drawer_widget.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});
  static const String routeName = '/first';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('First View'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To First View'),
        ),
      ),
      endDrawer: const DrawerWidget(screen: 0),
    );
  }
}