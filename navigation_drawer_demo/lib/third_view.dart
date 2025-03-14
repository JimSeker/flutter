import 'package:flutter/material.dart';

import 'drawer_widget.dart';

class ThirdView extends StatelessWidget {
  const ThirdView({super.key});
  static const String routeName = '/third';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third View'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To Third View'),
        ),
      ),
      drawer: const DrawerWidget(screen: 2,),
    );
  }
}