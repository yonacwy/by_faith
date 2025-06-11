import 'package:flutter/material.dart';

class HomeAppInfoScreen extends StatelessWidget {
  const HomeAppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
      ),
      body: const Center(
        child: Text('App Info Screen Content'),
      ),
    );
  }
}