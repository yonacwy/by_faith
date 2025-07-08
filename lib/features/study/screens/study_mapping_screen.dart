import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyMappingScreen extends StatelessWidget {
  const StudyMappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_mapping_screen.title),
      ),
      body: Center(
        child: Text(t.study_mapping_screen.content),
      ),
    );
  }
}