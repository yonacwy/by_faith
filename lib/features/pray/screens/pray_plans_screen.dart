import 'package:flutter/material.dart';

class PrayPlansScreen extends StatelessWidget {
  const PrayPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray Plans'),
      ),
      body: const Center(
        child: Text('Pray Plans Screen Content'),
      ),
    );
  }
}