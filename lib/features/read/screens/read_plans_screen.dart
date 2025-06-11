import 'package:flutter/material.dart';

class ReadPlansScreen extends StatelessWidget {
  const ReadPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Plans'),
      ),
      body: const Center(
        child: Text('Read Plans Screen Content'),
      ),
    );
  }
}