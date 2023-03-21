import 'package:flutter/material.dart';

import 'drawer_widget.dart';

class SecondView extends StatelessWidget {
  const SecondView({super.key});
  static const String routeName = '/second';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Second View'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To Second View'),
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}