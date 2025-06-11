import 'package:flutter/material.dart';

class HomeAppSupportScreen extends StatelessWidget {
  const HomeAppSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Support'),
      ),
      body: const Center(
        child: Text('App Support Screen Content'),
      ),
    );
  }
}