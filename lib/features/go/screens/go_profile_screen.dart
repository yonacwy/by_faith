import 'package:flutter/material.dart';

class GoProfileScreen extends StatelessWidget {
  const GoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Profile'),
      ),
      body: const Center(
        child: Text('Go Profile Screen Content'),
      ),
    );
  }
}