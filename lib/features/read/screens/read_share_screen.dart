import 'package:flutter/material.dart';

class ReadShareScreen extends StatelessWidget {
  const ReadShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
      ),
      body: const Center(
        child: Text('Read Share Screen Content'),
      ),
    );
  }
}