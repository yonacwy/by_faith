import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyExportImportScreen extends StatelessWidget {
  const StudyExportImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_export_import_screen.title),
      ),
      body: Center(
        child: Text(t.study_export_import_screen.content),
      ),
    );
  }
}