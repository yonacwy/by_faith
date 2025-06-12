import 'package:flutter/material.dart';

class HomeSupportScreen extends StatelessWidget {
  const HomeSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: const Center(
        child: Text('Support Screen Content'),
      ),
    );
  }
}