import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudySearchScreen extends StatelessWidget {
  const StudySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_search_screen.title),
      ),
      body: Center(
        child: Text(t.study_search_screen.content),
      ),
    );
  }
}