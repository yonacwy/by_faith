import 'package:flutter/material.dart';

class GoContactsScreen extends StatelessWidget {
  const GoContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Contacts'),
      ),
      body: const Center(
        child: Text('Go Contacts Screen Content'),
      ),
    );
  }
}