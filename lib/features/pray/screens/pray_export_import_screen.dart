import 'package:flutter/material.dart';

class PrayExportImportScreen extends StatelessWidget {
  const PrayExportImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export/Import Pray Data'),
      ),
      body: const Center(
        child: Text('Export/Import Screen Content'),
      ),
    );
  }
}