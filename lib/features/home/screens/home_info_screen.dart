import 'package:flutter/material.dart';

class HomeInfoScreen extends StatelessWidget {
  const HomeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const Center(
        child: Text('Info Screen Content'),
      ),
    );
  }
}