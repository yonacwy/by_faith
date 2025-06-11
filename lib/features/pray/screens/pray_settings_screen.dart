import 'package:flutter/material.dart';

class PraySettingsScreen extends StatelessWidget {
  const PraySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Settings'),
      ),
      body: const Center(
        child: Text('Pray Settings Screen Content'),
      ),
    );
  }
}