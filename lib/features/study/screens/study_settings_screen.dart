import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import '../../../core/models/user_preferences_model.dart';
import '../../../objectbox.dart'; // Assuming you have ObjectBox setup
import '../providers/study_settings_font_provider.dart';

class StudySettingsScreen extends StatefulWidget {
  const StudySettingsScreen({super.key});

  @override
  _StudySettingsScreenState createState() => _StudySettingsScreenState();
}

class _StudySettingsScreenState extends State<StudySettingsScreen> {
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
          t.study_settings_screen.title,
          style: TextStyle(
            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
            fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: t.study_settings_screen.back,
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
                  t.study_settings_screen.text_settings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                    fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
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
                          t.study_settings_screen.font_family,
                          style: TextStyle(
                            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                            fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: context.watch<StudySettingsFontProvider>().fontFamily,
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
                              context.read<StudySettingsFontProvider>().setFontFamily(value);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.study_settings_screen.font_size,
                          style: TextStyle(
                            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                            fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Slider(
                          value: context.watch<StudySettingsFontProvider>().fontSize,
                          min: 10.0,
                          max: 30.0,
                          divisions: 20,
                          label: context.watch<StudySettingsFontProvider>().fontSize.toStringAsFixed(1),
                          onChanged: (value) {
                            context.read<StudySettingsFontProvider>().setFontSize(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.study_settings_screen.preview,
                          style: TextStyle(
                            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                            fontSize: context.watch<StudySettingsFontProvider>().fontSize,
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
                            t.study_settings_screen.sample_text,
                            style: TextStyle(
                              fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                              fontSize: context.watch<StudySettingsFontProvider>().fontSize,
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