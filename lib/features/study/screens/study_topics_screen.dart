import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/study/screens/study_add_edit_topics_screen.dart';

class StudyTopicsScreen extends StatefulWidget {
  const StudyTopicsScreen({super.key});

  @override
  _StudyTopicsScreenState createState() => _StudyTopicsScreenState();
}

class _StudyTopicsScreenState extends State<StudyTopicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CreatedTopicsEn> _createdTopics = [];
  List<CreatedTopicsEn> _filteredCreatedTopics = [];
  List<GeneratedTopicsEn> _generatedTopics = [];
  List<GeneratedTopicsEn> _filteredGeneratedTopics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _searchController.addListener(_filterTopics);
  }

  void _loadTopics() {
    setState(() {
      _createdTopics = studyCreatedTopicsEnBox.getAll();
      _filteredCreatedTopics = _createdTopics;
      _generatedTopics = studyGeneratedTopicsEnBox.getAll();
      _filteredGeneratedTopics = _generatedTopics;
    });
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCreatedTopics = _createdTopics
          .where((topic) => topic.title.toLowerCase().contains(query))
          .toList();
      _filteredGeneratedTopics = _generatedTopics
          .where((topic) => (topic as GeneratedTopicsEn).title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _removeVerseFromTopic(CreatedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.remove(verse);
      studyCreatedTopicsEnBox.put(topic);
      _loadTopics();
    });
  }

  void _addVerseToTopic(CreatedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.add(verse);
      studyCreatedTopicsEnBox.put(topic);
      _loadTopics();
    });
  }

  void _deleteTopic(CreatedTopicsEn topic) {
    setState(() {
      studyCreatedTopicsEnBox.remove(topic.id);
      _loadTopics();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_topics_screen.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyAddEditTopicsScreen(topic: null),
                ),
              ).then((_) => _loadTopics());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar for Created Topics
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: t.study_topics_screen.search_placeholder,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
          ), // Closing parenthesis for TextField
          Expanded(
            child: _searchController.text.isEmpty
                ? ListView(
                    children: [
                      // Created Topics Section (when no search query)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          t.study_topics_screen.created_topics,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ..._filteredCreatedTopics.map((topic) => ExpansionTile(
                            title: Text(topic.title),
                            children: [
                              if (topic.verses.isEmpty)
                                ListTile(
                                  title: Text(t.study_topics_screen.no_verses),
                                ),
                              ...topic.verses.map((verse) => ListTile(
                                    title: Text(verse),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        final createdTopic =
                                            studyCreatedTopicsEnBox.getAll().firstWhere(
                                                (t) => t.title == topic.title);
                                        _removeVerseFromTopic(createdTopic, verse);
                                      },
                                    ),
                                  )),
                              ListTile(
                                title: Text(t.study_topics_screen.add_verse),
                                leading: const Icon(Icons.add),
                                onTap: () {
                                  final createdTopic = studyCreatedTopicsEnBox
                                      .getAll()
                                      .firstWhere((t) => t.title == topic.title);
                                  _addVerseToTopic(createdTopic, 'John 3:16');
                                },
                              ),
                              ListTile(
                                title: Text(t.study_topics_screen.edit_topic),
                                leading: const Icon(Icons.edit),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StudyAddEditTopicsScreen(topic: topic),
                                    ),
                                  ).then((_) => _loadTopics());
                                },
                              ),
                              ListTile(
                                title: Text(t.study_topics_screen.delete_topic),
                                leading: const Icon(Icons.delete_forever),
                                onTap: () {
                                  _deleteTopic(topic);
                                },
                              ),
                            ],
                          )),
                    ],
                  )
                : ListView(
                    children: [
                      // Search Results Section
                      if (_filteredCreatedTopics.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            t.study_topics_screen.created_topics,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ..._filteredCreatedTopics.map((topic) => ExpansionTile(
                            title: Text(topic.title),
                            children: [
                              if (topic.verses.isEmpty)
                                ListTile(
                                  title: Text(t.study_topics_screen.no_verses),
                                ),
                              ...topic.verses.map((verse) => ListTile(
                                    title: Text(verse),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        final createdTopic =
                                            studyCreatedTopicsEnBox.getAll().firstWhere(
                                                (t) => t.title == topic.title);
                                        _removeVerseFromTopic(createdTopic, verse);
                                      },
                                    ),
                                  )),
                              ListTile(
                                title: Text(t.study_topics_screen.add_verse),
                                leading: const Icon(Icons.add),
                                onTap: () {
                                  final createdTopic = studyCreatedTopicsEnBox
                                      .getAll()
                                      .firstWhere((t) => t.title == topic.title);
                                  _addVerseToTopic(createdTopic, 'John 3:16');
                                },
                              ),
                              ListTile(
                                title: Text(t.study_topics_screen.edit_topic),
                                leading: const Icon(Icons.edit),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StudyAddEditTopicsScreen(topic: topic),
                                    ),
                                  ).then((_) => _loadTopics());
                                },
                              ),
                              ListTile(
                                title: Text(t.study_topics_screen.delete_topic),
                                leading: const Icon(Icons.delete_forever),
                                onTap: () {
                                  _deleteTopic(topic);
                                },
                              ),
                            ],
                          )),
                      if (_filteredGeneratedTopics.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            t.study_topics_screen.generated_topics,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ..._filteredGeneratedTopics.map((topic) => ExpansionTile(
                            title: Text(topic.title),
                            children: [
                              if (topic.verses.isEmpty)
                                ListTile(
                                  title: Text(t.study_topics_screen.no_verses),
                                ),
                              ...topic.verses.map((verse) => ListTile(
                                    title: Text(verse),
                                  )),
                              ListTile(
                                title: Text(t.study_topics_screen.add_to_created),
                                leading: const Icon(Icons.add),
                                onTap: () {
                                  // Add generated topic to created topics
                                  final newCreatedTopic = CreatedTopicsEn(
                                    title: topic.title,
                                    verses: List.from(topic.verses),
                                  );
                                  studyCreatedTopicsEnBox.put(newCreatedTopic);
                                  _loadTopics();
                                  _searchController.clear(); // Clear search after adding
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ), // Closing parenthesis for Expanded
              ],
            ),
          ); // Closing parenthesis for Scaffold and semicolon
  }
}