import 'package:flutter/material.dart';

class ReadSettingsScreen extends StatelessWidget {
  const ReadSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Settings'),
      ),
      body: const Center(
        child: Text('Read Settings Screen Content'),
      ),
    );
  }
}