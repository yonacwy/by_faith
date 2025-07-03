import 'package:flutter/material.dart';

class PrayRemindersScreen extends StatelessWidget {
  const PrayRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Reminders'),
      ),
      body: const Center(
        child: Text('Pray Reminders Screen Content'),
      ),
    );
  }
}