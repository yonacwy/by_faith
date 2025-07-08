import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyTopicsScreen extends StatelessWidget {
  const StudyTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_topics_screen.title),
      ),
      body: Center(
        child: Text(t.study_topics_screen.content),
      ),
    );
  }
}