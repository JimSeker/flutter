import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To First Screen'),
        ),
      ),
    );
  }
}