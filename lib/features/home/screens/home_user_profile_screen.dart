import 'package:flutter/material.dart';

class HomeUserProfileScreen extends StatelessWidget {
  const HomeUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Screen Content'),
      ),
    );
  }
}