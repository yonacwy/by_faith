import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart'; // Required for Box type
import 'package:by_faith/features/study/screens/study_add_edit_topics_screen.dart';

class StudyTopicsScreen extends StatefulWidget {
  const StudyTopicsScreen({super.key});

  @override
  _StudyTopicsScreenState createState() => _StudyTopicsScreenState();
}

class _StudyTopicsScreenState extends State<StudyTopicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CreatedTopicsEn> _createdTopics = [];
  List<CreatedTopicsEn> _filteredGeneratedTopics = [];
  List<CreatedTopicsEn> _allGeneratedTopics = [];
  late Box<GeneratedTopicsEn> _generatedTopicsBox;

  @override
  void initState() {
    super.initState();
    _generatedTopicsBox = store.box<GeneratedTopicsEn>();
    _loadTopics();
    _searchController.addListener(_filterTopics);
  }

  void _loadTopics() {
    setState(() {
      _createdTopics = _generatedTopicsBox.getAll().map((t) => CreatedTopicsEn(title: t.title, verses: t.verses)).toList();
      _allGeneratedTopics = studyTopicsEnBox.getAll();
      _filteredGeneratedTopics = _allGeneratedTopics;
    });
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGeneratedTopics = _allGeneratedTopics
          .where((topic) => topic.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addTopicToCreated(CreatedTopicsEn topic) {
    setState(() {
      _generatedTopicsBox.put(GeneratedTopicsEn(title: topic.title, verses: topic.verses));
      _loadTopics();
    });
  }

  void _removeVerseFromTopic(GeneratedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.remove(verse);
      _generatedTopicsBox.put(topic);
      _loadTopics();
    });
  }

  void _addVerseToTopic(GeneratedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.add(verse);
      _generatedTopicsBox.put(topic);
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
                  builder: (context) => const StudyAddEditTopicsScreen(),
                ),
              ).then((_) => _loadTopics());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar for Generated Topics
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
          ),
          Expanded(
            child: ListView(
              children: [
                // Created Topics Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    t.study_topics_screen.created_topics,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ..._createdTopics.map((topic) => ExpansionTile(
                      title: Text(topic.title),
                      children: topic.verses.isEmpty
                          ? [
                              ListTile(
                                title: Text(t.study_topics_screen.no_verses),
                              ),
                            ]
                          : topic.verses.map((verse) => ListTile(
                                title: Text(verse),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    final genTopic = _generatedTopicsBox.getAll().firstWhere((t) => t.title == topic.title);
                                    _removeVerseFromTopic(genTopic, verse);
                                  },
                                ),
                              )).toList()
                        ..add(ListTile(
                          title: Text(t.study_topics_screen.add_verse),
                          leading: const Icon(Icons.add),
                          onTap: () {
                            final genTopic = _generatedTopicsBox.getAll().firstWhere((t) => t.title == topic.title);
                            // Placeholder for verse selection
                            _addVerseToTopic(genTopic, 'John 3:16'); // Replace with actual verse selection
                          },
                        )),
                    )),

                // Generated Topics Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    t.study_topics_screen.generated_topics,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ..._filteredGeneratedTopics.map((topic) => ExpansionTile(
                      title: Text(topic.title),
                      children: topic.verses.isEmpty
                          ? [
                              ListTile(
                                title: Text(t.study_topics_screen.no_verses),
                              ),
                            ]
                          : topic.verses.map((verse) => ListTile(
                                title: Text(verse),
                              )).toList()
                        ..add(ListTile(
                          title: Text(t.study_topics_screen.add_to_created),
                          leading: const Icon(Icons.add),
                          onTap: () => _addTopicToCreated(topic),
                        )),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}