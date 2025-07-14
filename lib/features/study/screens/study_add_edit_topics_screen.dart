import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';

class StudyAddEditTopicsScreen extends StatefulWidget {
  final CreatedTopicsEn? topic; // Optional topic for editing created topics

  const StudyAddEditTopicsScreen({super.key, this.topic});

  @override
  _StudyAddEditTopicsScreenState createState() => _StudyAddEditTopicsScreenState();
}

class _StudyAddEditTopicsScreenState extends State<StudyAddEditTopicsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<String> _verses = [];

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _titleController.text = widget.topic!.title;
      _verses.addAll(widget.topic!.verses);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTopic() {
    if (_formKey.currentState!.validate()) {
      final topic = CreatedTopicsEn(
        title: _titleController.text.trim(),
        verses: _verses,
      );
      if (widget.topic != null) {
        topic.id = widget.topic!.id; // Preserve ID for editing
      }
      studyCreatedTopicsEnBox.put(topic);
      Navigator.pop(context);
    }
  }

  void _addVerse() {
    // Placeholder for verse selection logic
    // In a real app, this would open a verse picker UI
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.study_add_edit_topics_screen.select_verse),
        content: TextField(
          decoration: InputDecoration(
            labelText: t.study_add_edit_topics_screen.verse_input_hint,
            hintText: 'e.g., John 3:16',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _verses.add(value.trim());
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.study_add_edit_topics_screen.cancel),
          ),
        ],
      ),
    );
  }

  void _removeVerse(String verse) {
    setState(() {
      _verses.remove(verse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic == null
            ? t.study_add_edit_topics_screen.title_add
            : t.study_add_edit_topics_screen.title_edit),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTopic,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: t.study_add_edit_topics_screen.title_label,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.study_add_edit_topics_screen.title_error;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                t.study_add_edit_topics_screen.verses_label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _verses.length,
                  itemBuilder: (context, index) {
                    final verse = _verses[index];
                    return ListTile(
                      title: Text(verse),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeVerse(verse),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addVerse,
                icon: const Icon(Icons.add),
                label: Text(t.study_add_edit_topics_screen.add_verse),
              ),
            ],
          ),
        ),
      ),
    );
  }
}