import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyAddEditNotesScreen extends StatelessWidget {
  const StudyAddEditNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_add_edit_notes_screen.title),
      ),
      body: Center(
        child: Text(t.study_add_edit_notes_screen.content),
      ),
    );
  }
}