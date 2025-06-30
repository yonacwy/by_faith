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
import 'package:by_faith/features/home/providers/home_settings_font_provider.dart'; // Import HomeSettingsFontProvider
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart'; // Import GoSettingsFontProvider
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart'; // Import StudySettingsFontProvider
import 'package:by_faith/core/models/user_preferences_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupObjectBox();
  // Load language preference from ObjectBox
  final prefs = getUserPreferences(userPreferencesBox);
  if (prefs.languageCode != null && prefs.languageCode!.isNotEmpty) {
    // Set the saved locale
    switch (prefs.languageCode) {
      case 'es':
        LocaleSettings.setLocale(AppLocale.es);
        break;
      case 'hi':
        LocaleSettings.setLocale(AppLocale.hi);
        break;
      default:
        LocaleSettings.setLocale(AppLocale.en);
    }
  } else {
    LocaleSettings.useDeviceLocale();
  }
  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeSettingsFontProvider()),
          ChangeNotifierProvider(create: (_) => GoSettingsFontProvider()), // Add StudySettingsFontProvider
          ChangeNotifierProvider(create: (_) => StudySettingsFontProvider()), // Add StudySettingsFontProvider
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
      title: t.main.title,
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: t.main.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Symbols.folded_hands), // Pray icon
            label: t.main.pray,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book), // Read icon
            label: t.main.read,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school), // Study icon
            label: t.main.study,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Symbols.globe), // Go icon
            label: t.main.go,
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
