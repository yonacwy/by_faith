import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyNotesScreen extends StatelessWidget {
  const StudyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_notes_screen.title),
      ),
      body: Center(
        child: Text(t.study_notes_screen.content),
      ),
    );
  }
}