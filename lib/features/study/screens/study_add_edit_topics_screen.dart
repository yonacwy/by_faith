import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:collection/collection.dart'; // Added for firstWhereOrNull

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

  @override
  void initState() {
    super.initState();
    _loadTopics();
    if (widget.topic != null) {
      _titleController.text = widget.topic!.title;
      _selectedTopic = widget.topic;
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
        ..._createdTopics.where((t) => t.title.toLowerCase().contains(value.toLowerCase())).map((t) => t.title),
        ..._generatedTopics.where((t) => t.title.toLowerCase().contains(value.toLowerCase())).map((t) => t.title),
      ].toSet().toList();
      _selectedTopic = _createdTopics.firstWhereOrNull((t) => t.title == value);
    });
  }

  void _saveTopic() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.study_add_edit_topics_screen.empty_title_error)),
      );
      return;
    }

    if (_selectedTopic != null && _selectedTopic!.title == title) {
      // Update existing topic
      if (widget.initialVerse != null && !_selectedTopic!.verses.contains(widget.initialVerse)) {
        _selectedTopic!.verses.add(widget.initialVerse!);
        studyCreatedTopicsEnBox.put(_selectedTopic!);
      }
    } else {
      // Check for duplicate title
      if (_createdTopics.any((t) => t.title.toLowerCase() == title.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.study_add_edit_topics_screen.duplicate_title_error)),
        );
        return;
      }

      // Create new topic
      final newTopic = CreatedTopicsEn(
        title: title,
        verses: widget.initialVerse != null ? [widget.initialVerse!] : [],
      );
      studyCreatedTopicsEnBox.put(newTopic);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic == null
            ? t.study_add_edit_topics_screen.add_title
            : t.study_add_edit_topics_screen.edit_title),
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
                      title: Text(_suggestedTopics[index]),
                      onTap: () {
                        _titleController.text = _suggestedTopics[index];
                        _selectedTopic = _createdTopics.firstWhereOrNull((t) => t.title == _suggestedTopics[index]);
                        setState(() {
                          _suggestedTopics = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTopic,
              child: Text(t.study_add_edit_topics_screen.save_button),
            ),
          ],
        ),
      ),
    );
  }
}