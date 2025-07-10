import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:provider/provider.dart';
import '../providers/study_settings_font_provider.dart';

class StudyStrongsDictionaryScreen extends StatefulWidget {
  final String strongsNumber;

  const StudyStrongsDictionaryScreen({super.key, required this.strongsNumber});

  @override
  State<StudyStrongsDictionaryScreen> createState() => _StudyStrongsDictionaryScreenState();
}

class _StudyStrongsDictionaryScreenState extends State<StudyStrongsDictionaryScreen> {
  Map<String, dynamic>? _entry;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDictionaryEntry();
  }

  Future<void> _loadDictionaryEntry() async {
    try {
      final isHebrew = widget.strongsNumber.startsWith('H');
      final dictionaryPath = isHebrew
          ? 'lib/features/study/assets/data/strongs-hebrew-dictionary.json'
          : 'lib/features/study/assets/data/strongs-greek-dictionary.json';
      final jsonString = await DefaultAssetBundle.of(context).loadString(dictionaryPath);
      final dictionary = jsonDecode(jsonString) as Map<String, dynamic>;
      final normalizedStrongsNumber = widget.strongsNumber.startsWith('H')
          ? 'H${int.parse(widget.strongsNumber.substring(1))}'
          : widget.strongsNumber;
      setState(() {
        _entry = dictionary[normalizedStrongsNumber] as Map<String, dynamic>?;
        _isLoading = false;
        if (_entry == null) {
          _error = t.study_strongs_dictionary_screen.not_found.replaceAll('{number}', widget.strongsNumber);
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = t.study_strongs_dictionary_screen.error_loading.replaceAll('{error}', e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.study_strongs_dictionary_screen.title.replaceAll('{number}', widget.strongsNumber),
          style: TextStyle(
            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
            fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2, // Slightly larger for title
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text(_error))
                : _entry != null
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.study_strongs_dictionary_screen.word,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2, // Slightly larger for labels
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!['lemma'] ?? t.study_strongs_dictionary_screen.not_available,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.derivation,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!['derivation'] ?? t.study_strongs_dictionary_screen.not_available,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.pronunciation,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!['pron'] ?? t.study_strongs_dictionary_screen.not_available,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.definition,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!['strongs_def'] ?? t.study_strongs_dictionary_screen.not_available,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.details,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize + 2,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _entry!['kjv_def'] ?? t.study_strongs_dictionary_screen.not_available,
                              style: TextStyle(
                                fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                                fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          _error.isNotEmpty ? _error : t.study_strongs_dictionary_screen.not_found.replaceAll('{number}', widget.strongsNumber),
                          style: TextStyle(
                            fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                            fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
      ),
    );
  }
}