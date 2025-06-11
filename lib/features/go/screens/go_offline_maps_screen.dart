import 'package:flutter/material.dart';

class GoOfflineMapsScreen extends StatelessWidget {
  const GoOfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Offline Maps'),
      ),
      body: const Center(
        child: Text('Go Offline Maps Screen Content'),
      ),
    );
  }
}