import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:by_faith/features/home/screens/home_tab_screen.dart';
import 'package:by_faith/features/pray/screens/pray_tab_screen.dart';
import 'package:by_faith/features/read/screens/read_tab_screen.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/go/screens/go_tab_screen.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:by_faith/app/i18n/strings.g.dart'; // Import translations
import 'package:flutter_localizations/flutter_localizations.dart'; // Import for localization delegates

import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart'; // Import GoSettingsFontProvider
import 'package:by_faith/features/home/providers/home_settings_font_provider.dart'; // Import HomeSettingsFontProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupObjectBox();
  LocaleSettings.useDeviceLocale(); // Initialize translations
  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FontProvider()),
          ChangeNotifierProvider(create: (_) => HomeSettingsFontProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'By Faith',
      supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTabScreen(),
    const PrayTabScreen(),
    const ReadTabScreen(),
    const StudyTabScreen(),
    const GoTabScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.folded_hands), // Pray icon
            label: 'Pray',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book), // Read icon
            label: 'Read',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // Study icon
            label: 'Study',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.globe), // Go icon
            label: 'Go',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
      ),
    );
  }
}
