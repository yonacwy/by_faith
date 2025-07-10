import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

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
      setState(() {
        _entry = dictionary[widget.strongsNumber] as Map<String, dynamic>?;
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
        title: Text(t.study_strongs_dictionary_screen.title.replaceAll('{number}', widget.strongsNumber)),
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
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_entry!['word'] ?? t.study_strongs_dictionary_screen.not_available),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.pronunciation,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_entry!['pronunciation'] ?? t.study_strongs_dictionary_screen.not_available),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.definition,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_entry!['definition'] ?? t.study_strongs_dictionary_screen.not_available),
                            const SizedBox(height: 16),
                            Text(
                              t.study_strongs_dictionary_screen.details,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_entry!['details'] ?? t.study_strongs_dictionary_screen.not_available),
                          ],
                        ),
                      )
                    : Center(child: Text(t.study_strongs_dictionary_screen.not_found.replaceAll('{number}', widget.strongsNumber))),
      ),
    );
  }
}