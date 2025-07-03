import 'package:flutter/material.dart';

class PrayTimersScreen extends StatelessWidget {
  const PrayTimersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Timers'),
      ),
      body: const Center(
        child: Text('Pray Timers Screen Content'),
      ),
    );
  }
}