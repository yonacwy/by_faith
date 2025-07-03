import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyPlansScreen extends StatelessWidget {
  const StudyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_plans_screen.title),
      ),
      body: Center(
        child: Text(t.study_plans_screen.content),
      ),
    );
  }
}