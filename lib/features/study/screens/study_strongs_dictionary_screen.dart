import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyStrongsDictionaryScreen extends StatelessWidget {
  const StudyStrongsDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_strongs_dictionary_screen.title),
      ),
      body: Center(
        child: Text(t.study_strongs_dictionary_screen.content),
      ),
    );
  }
}