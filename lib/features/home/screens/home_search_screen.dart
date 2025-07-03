import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class HomeSearchScreen extends StatelessWidget {
  const HomeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_search_screen.title), // Assuming a translation key for the title
      ),
      body: Center(
        child: Text(t.home_search_screen.content), // Assuming a translation key for content
      ),
    );
  }
}