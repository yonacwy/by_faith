import 'package:flutter/material.dart';

class StudySearchScreen extends StatelessWidget {
  const StudySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Search'),
      ),
      body: const Center(
        child: Text('Study Search Screen Content'),
      ),
    );
  }
}