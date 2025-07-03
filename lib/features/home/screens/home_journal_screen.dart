import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class HomeJournalScreen extends StatelessWidget {
  const HomeJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_journal_screen.title),
      ),
      body: Center(
        child: Text(t.home_journal_screen.content),
      ),
    );
  }
}