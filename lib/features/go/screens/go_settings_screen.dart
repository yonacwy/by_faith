// lib/features/go/screens/go_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import '../../../core/models/user_preferences_model.dart';
import '../../../objectbox.dart'; // Assuming you have ObjectBox setup

class GoSettingsScreen extends StatefulWidget {
  const GoSettingsScreen({super.key});

  @override
  _GoSettingsScreenState createState() => _GoSettingsScreenState();
}

class _GoSettingsScreenState extends State<GoSettingsScreen> {
  late String currentFont;
  late double currentFontSize;
  late Box<UserPreferences> userPreferencesBox;
  late UserPreferences userPreferences;

  @override
  void initState() {
    super.initState();
    userPreferencesBox = store.box<UserPreferences>();
    
    // Load existing preferences or create new
    userPreferences = userPreferencesBox.getAll().isNotEmpty
        ? userPreferencesBox.getAll().first
        : UserPreferences();
        
    currentFont = userPreferences.fontFamily ?? 'Roboto';
    currentFontSize = userPreferences.fontSize ?? 16.0;
  }

  void _savePreferences() {
    userPreferences
      ..fontFamily = currentFont
      ..fontSize = currentFontSize;
    userPreferencesBox.put(userPreferences);
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
        "And he said unto them, Go ye into all the world, and preach the gospel to every creature.";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
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
                  'Text Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
                          'Font Family',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: currentFont,
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
                              setState(() => currentFont = value);
                              _savePreferences();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Font Size: ${currentFontSize.toStringAsFixed(1)}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        Slider(
                          value: currentFontSize,
                          min: 10.0,
                          max: 30.0,
                          divisions: 20,
                          label: currentFontSize.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() => currentFontSize = value);
                            _savePreferences();
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Preview:',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
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
                              fontFamily: currentFont,
                              fontSize: currentFontSize,
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