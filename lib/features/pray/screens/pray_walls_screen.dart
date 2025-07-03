import 'package:flutter/material.dart';

class PrayWallsScreen extends StatelessWidget {
  const PrayWallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Walls'),
      ),
      body: const Center(
        child: Text('Pray Walls Screen Content'),
      ),
    );
  }
}