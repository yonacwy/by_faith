import 'package:flutter/material.dart';

class ReadHighlightsScreen extends StatelessWidget {
  const ReadHighlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights'),
      ),
      body: const Center(
        child: Text('Highlights Screen Content'),
      ),
    );
  }
}