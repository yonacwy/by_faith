// lib/features/go/screens/go_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import '../../../core/models/user_preferences_model.dart';
import '../../../objectbox.dart'; // Assuming you have ObjectBox setup
import '../providers/go_settings_font_provider.dart';

class GoSettingsScreen extends StatefulWidget {
  const GoSettingsScreen({super.key});

  @override
  _GoSettingsScreenState createState() => _GoSettingsScreenState();
}

class _GoSettingsScreenState extends State<GoSettingsScreen> {
  @override
  void initState() {
    super.initState();
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
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_settings_screen.title,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize + 2,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: t.go_settings_screen.back,
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
                  t.go_settings_screen.text_settings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize + 2,
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
                          t.go_settings_screen.font_family,
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: context.watch<FontProvider>().fontFamily,
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
                              context.read<FontProvider>().setFontFamily(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.go_settings_screen.font_size,
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Slider(
                          value: context.watch<FontProvider>().fontSize,
                          min: 10.0,
                          max: 30.0,
                          divisions: 20,
                          label: context.watch<FontProvider>().fontSize.toStringAsFixed(1),
                          onChanged: (value) {
                            context.read<FontProvider>().setFontSize(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.go_settings_screen.preview,
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
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
                            t.go_settings_screen.sample_text,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}