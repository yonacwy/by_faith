import 'package:flutter/material.dart';

class ReadMemorizationsScreen extends StatelessWidget {
  const ReadMemorizationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorizations'),
      ),
      body: const Center(
        child: Text('Memorizations Screen Content'),
      ),
    );
  }
}