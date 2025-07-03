import 'package:flutter/material.dart';

class ReadExportImportScreen extends StatelessWidget {
  const ReadExportImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export/Import'),
      ),
      body: const Center(
        child: Text('Read Export/Import Screen Content'),
      ),
    );
  }
}
