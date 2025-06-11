import 'package:flutter/material.dart';

class HomeCalendarScreen extends StatelessWidget {
  const HomeCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: const Center(
        child: Text('Calendar Screen Content'),
      ),
    );
  }
}