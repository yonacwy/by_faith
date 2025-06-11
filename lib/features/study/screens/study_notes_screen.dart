import 'package:flutter/material.dart';

class StudyNotesScreen extends StatelessWidget {
  const StudyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Notes'),
      ),
      body: const Center(
        child: Text('Study Notes Screen Content'),
      ),
    );
  }
}