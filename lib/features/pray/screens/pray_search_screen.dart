import 'package:flutter/material.dart';

class PraySearchScreen extends StatelessWidget {
  const PraySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Search'),
      ),
      body: const Center(
        child: Text('Pray Search Screen Content'),
      ),
    );
  }
}