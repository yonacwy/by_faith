import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import '../providers/home_settings_font_provider.dart';

class HomeSettingsScreen extends StatefulWidget {
  const HomeSettingsScreen({super.key});

  @override
  _HomeSettingsScreenState createState() => _HomeSettingsScreenState();
}

class _HomeSettingsScreenState extends State<HomeSettingsScreen> {
  late Locale _selectedLanguage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = TranslationProvider.of(context).locale.flutterLocale;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> fontOptions = [
      'Arial',
      'Roboto',
      'Times New Roman',
      'Open Sans',
      'Lora',
    ];
    const String sampleText =
        "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.home_settings_screen.title,
          style: TextStyle(
            fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
            fontSize: context.watch<HomeSettingsFontProvider>().fontSize + 2,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: t.home_settings_screen.back,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.home_settings_screen.text_settings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                    fontSize: context.watch<HomeSettingsFontProvider>().fontSize + 2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.home_settings_screen.font_family,
                          style: TextStyle(
                            fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                            fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: context.watch<HomeSettingsFontProvider>().fontFamily,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: fontOptions.map((font) {
                            return DropdownMenuItem<String>(
                              value: font,
                              child: Text(
                                font,
                                style: TextStyle(
                                  fontFamily: font,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<HomeSettingsFontProvider>().setFontFamily(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.home_settings_screen.font_size,
                          style: TextStyle(
                            fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                            fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Slider(
                          value: context.watch<HomeSettingsFontProvider>().fontSize,
                          min: 10.0,
                          max: 30.0,
                          divisions: 20,
                          label: context.watch<HomeSettingsFontProvider>().fontSize.toStringAsFixed(1),
                          onChanged: (value) {
                            context.read<HomeSettingsFontProvider>().setFontSize(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.home_settings_screen.preview,
                          style: TextStyle(
                            fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                            fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sampleText,
                            style: TextStyle(
                              fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                              fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Add spacing between sections
                Text(
                  t.home_settings_screen.global_settings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                    fontSize: context.watch<HomeSettingsFontProvider>().fontSize + 2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.home_settings_screen.language_settings,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                            fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.home_settings_screen.app_language,
                              style: TextStyle(
                                fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                                fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.home_settings_screen.english,
                                  style: TextStyle(
                                    fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                                    fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguage = AppLocale.en.flutterLocale;
                                    });
                                    LocaleSettings.setLocale(AppLocale.en);
                                    Navigator.pop(context); // Pop back to HomeTabScreen to force rebuild
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedLanguage == AppLocale.en.flutterLocale
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                                    foregroundColor: _selectedLanguage == AppLocale.en.flutterLocale
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                  child: Text(t.home_settings_screen.load),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.home_settings_screen.spanish,
                                  style: TextStyle(
                                    fontFamily: context.watch<HomeSettingsFontProvider>().fontFamily,
                                    fontSize: context.watch<HomeSettingsFontProvider>().fontSize,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedLanguage = AppLocale.es.flutterLocale;
                                    });
                                    LocaleSettings.setLocale(AppLocale.es);
                                    Navigator.pop(context); // Pop back to HomeTabScreen to force rebuild
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedLanguage == AppLocale.es.flutterLocale
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                                    foregroundColor: _selectedLanguage == AppLocale.es.flutterLocale
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface,
                                  ),
                                  child: Text(t.home_settings_screen.load),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}