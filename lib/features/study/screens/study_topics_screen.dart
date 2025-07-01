import 'package:flutter/material.dart';

class StudyTopicsScreen extends StatelessWidget {
  const StudyTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics Screen'),
      ),
      body: const Center(
        child: Text('Topics Screen Content'),
      ),
    );
  }
}