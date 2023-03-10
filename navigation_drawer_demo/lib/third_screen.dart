import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Welcome To Third Screen'),
        ),
      ),
    );
  }
}