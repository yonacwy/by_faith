import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class HomeLibraryScreen extends StatelessWidget {
  const HomeLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_library_screen.title),
      ),
      body: Center(
        child: Text(t.home_library_screen.content),
      ),
    );
  }
}