import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/providers/study_topics_verse_provider.dart';
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class StudyAddEditTopicsScreen extends StatefulWidget {
  final CreatedTopicsEn? topic;
  final String? initialVerse;

  const StudyAddEditTopicsScreen({super.key, this.topic, this.initialVerse});

  @override
  _StudyAddEditTopicsScreenState createState() => _StudyAddEditTopicsScreenState();
}

class _StudyAddEditTopicsScreenState extends State<StudyAddEditTopicsScreen> {
  final TextEditingController _titleController = TextEditingController();
  List<CreatedTopicsEn> _createdTopics = [];
  List<GeneratedTopicsEn> _generatedTopics = [];
  List<String> _suggestedTopics = [];
  CreatedTopicsEn? _selectedTopic;
  List<String> _verses = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
    if (widget.topic != null) {
      _titleController.text = widget.topic!.title;
      _selectedTopic = widget.topic;
      _verses = List.from(widget.topic!.verses);
    }
    if (widget.initialVerse != null) {
      _verses.add(widget.initialVerse!);
    }
  }

  void _loadTopics() {
    setState(() {
      _createdTopics = studyCreatedTopicsEnBox.getAll();
      _generatedTopics = studyGeneratedTopicsEnBox.getAll();
      _suggestedTopics = [
        ..._createdTopics.map((t) => t.title),
        ..._generatedTopics.map((t) => t.title),
      ].toSet().toList();
    });
  }

  void _onTitleChanged(String value) {
    setState(() {
      _suggestedTopics = [
        ..._createdTopics
            .where((t) => t.title.toLowerCase().contains(value.toLowerCase()))
            .map((t) => t.title),
        ..._generatedTopics
            .where((t) => t.title.toLowerCase().contains(value.toLowerCase()))
            .map((t) => t.title),
      ].toSet().toList();
      _selectedTopic =
          _createdTopics.firstWhereOrNull((t) => t.title == value);
    });
  }

  void _saveTopic() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.study_add_edit_topics_screen.empty_title_error,
            style: TextStyle(
                fontSize:
                    Provider.of<StudySettingsFontProvider>(context, listen: false)
                        .fontSize),
          ),
        ),
      );
      return;
    }

    final existingTopic = _createdTopics
        .firstWhereOrNull((t) => t.title.toLowerCase() == title.toLowerCase());

    if (existingTopic != null && existingTopic != widget.topic) {
      existingTopic.verses = _verses;
      studyCreatedTopicsEnBox.put(existingTopic);
      print('Overrode existing topic: ${existingTopic.title}');
    } else if (_selectedTopic != null && _selectedTopic!.title == title) {
      _selectedTopic!.verses = _verses;
      studyCreatedTopicsEnBox.put(_selectedTopic!);
      print('Updated topic: ${_selectedTopic!.title}');
    } else {
      final newTopic = CreatedTopicsEn(
        title: title,
        verses: _verses,
      );
      studyCreatedTopicsEnBox.put(newTopic);
      print('Created new topic: $title');
    }

    Navigator.pop(context);
  }

  void _addVerse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          onVerseSelected: (verseReference) {
            setState(() {
              if (!_verses.contains(verseReference)) {
                _verses.add(verseReference);
              }
            });
          },
        ),
      ),
    );
  }

  void _removeVerse(String verse) {
    setState(() {
      _verses.remove(verse);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verseProvider = Provider.of<StudyTopicsVerseProvider>(context);
    final fontProvider = Provider.of<StudySettingsFontProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic == null
              ? t.study_add_edit_topics_screen.add_title
              : t.study_add_edit_topics_screen.edit_title,
          style: TextStyle(fontSize: fontProvider.fontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: t.study_add_edit_topics_screen.title_label,
                border: const OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: fontProvider.fontSize),
              onChanged: _onTitleChanged,
            ),
            if (_suggestedTopics.isNotEmpty && _titleController.text.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestedTopics.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _suggestedTopics[index],
                        style: TextStyle(fontSize: fontProvider.fontSize),
                      ),
                      onTap: () {
                        _titleController.text = _suggestedTopics[index];
                        _selectedTopic = _createdTopics
                            .firstWhereOrNull((t) => t.title == _suggestedTopics[index]);
                        if (_selectedTopic != null) {
                          setState(() {
                            _verses = List.from(_selectedTopic!.verses);
                          });
                        }
                        setState(() {
                          _suggestedTopics = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                t.study_add_edit_topics_screen.add_verse,
                style: TextStyle(fontSize: fontProvider.fontSize),
              ),
              leading: const Icon(Icons.add),
              onTap: _addVerse,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _verses.length,
                itemBuilder: (context, index) {
                  final verse = _verses[index];
                  final verseText = verseProvider.getVerseText(verse) ??
                      t.study_add_edit_topics_screen.no_verse_text;
                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: StudyTopicsVerseProvider.formatVerseReference(verse),
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: fontProvider.fontSize,
                            ),
                          ),
                          TextSpan(
                            text: ' $verseText',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: fontProvider.fontSize),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeVerse(verse),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTopic,
              child: Text(
                t.study_add_edit_topics_screen.save_button,
                style: TextStyle(fontSize: fontProvider.fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}