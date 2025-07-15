import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/study/screens/study_add_edit_topics_screen.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/objectbox.g.dart';

class StudyTopicsScreen extends StatefulWidget {
  const StudyTopicsScreen({super.key});

  @override
  _StudyTopicsScreenState createState() => _StudyTopicsScreenState();
}

class _StudyTopicsScreenState extends State<StudyTopicsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CreatedTopicsEn> _createdTopics = [];
  List<CreatedTopicsEn> _filteredCreatedTopics = [];
  List<dynamic> _filteredSearchResults = [];
  int _currentPage = 0;
  final int _pageSize = 50;

  static const Map<String, String> _bookNameMap = {
    'Gen': 'Genesis',
    'Exod': 'Exodus',
    'Lev': 'Leviticus',
    'Num': 'Numbers',
    'Deut': 'Deuteronomy',
    'Josh': 'Joshua',
    'Judg': 'Judges',
    'Ruth': 'Ruth',
    '1Sam': '1 Samuel',
    '2Sam': '2 Samuel',
    '1Kgs': '1 Kings',
    '2Kgs': '2 Kings',
    '1Chr': '1 Chronicles',
    '2Chr': '2 Chronicles',
    'Ezra': 'Ezra',
    'Neh': 'Nehemiah',
    'Esth': 'Esther',
    'Job': 'Job',
    'Ps': 'Psalms',
    'Prov': 'Proverbs',
    'Eccl': 'Ecclesiastes',
    'Song': 'Song of Solomon',
    'Isa': 'Isaiah',
    'Jer': 'Jeremiah',
    'Lam': 'Lamentations',
    'Ezek': 'Ezekiel',
    'Dan': 'Daniel',
    'Hos': 'Hosea',
    'Joel': 'Joel',
    'Amos': 'Amos',
    'Obad': 'Obadiah',
    'Jonah': 'Jonah',
    'Mic': 'Micah',
    'Nah': 'Nahum',
    'Hab': 'Habakkuk',
    'Zeph': 'Zephaniah',
    'Hag': 'Haggai',
    'Zech': 'Zechariah',
    'Mal': 'Malachi',
    'Matt': 'Matthew',
    'Mark': 'Mark',
    'Luke': 'Luke',
    'John': 'John',
    'Acts': 'Acts',
    'Rom': 'Romans',
    '1Cor': '1 Corinthians',
    '2Cor': '2 Corinthians',
    'Gal': 'Galatians',
    'Eph': 'Ephesians',
    'Phil': 'Philippians',
    'Col': 'Colossians',
    '1Thess': '1 Thessalonians',
    '2Thess': '2 Thessalonians',
    '1Tim': '1 Timothy',
    '2Tim': '2 Timothy',
    'Titus': 'Titus',
    'Phlm': 'Philemon',
    'Heb': 'Hebrews',
    'Jas': 'James',
    '1Pet': '1 Peter',
    '2Pet': '2 Peter',
    '1John': '1 John',
    '2John': '2 John',
    '3John': '3 John',
    'Jude': 'Jude',
    'Rev': 'Revelation',
  };

  String _capitalizeTitle(String title) {
    return title
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

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
      _filteredSearchResults = [];
      _currentPage = 0;
      print('Loaded ${_createdTopics.length} created topics.');
    });
  }

  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCreatedTopics = _createdTopics;
        _filteredSearchResults = [];
        _currentPage = 0;
      } else {
        _filteredCreatedTopics = _createdTopics
            .where((topic) => topic.title.toLowerCase().contains(query))
            .toList();
        final generatedQuery = studyGeneratedTopicsEnBox
            .query(GeneratedTopicsEn_.title.contains(query, caseSensitive: false))
            .build();
        _filteredSearchResults = [
          ..._filteredCreatedTopics,
          ...generatedQuery.find(),
        ];
        generatedQuery.close();
        _currentPage = 0;
        print('Filtered ${_filteredCreatedTopics.length} created topics and ${_filteredSearchResults.length} total search results for query: $query');
      }
    });
  }

  void _removeVerseFromTopic(CreatedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.remove(verse);
      studyCreatedTopicsEnBox.put(topic);
      _loadTopics();
      print('Removed verse $verse from topic ${topic.title}');
    });
  }

  void _navigateToVerse(String verseReference) async {
    print('Attempting to navigate to verse: $verseReference');
    
    String singleVerse = verseReference.split('-')[0].trim();
    final parts = singleVerse.split('.');
    if (parts.length != 3) {
      print('Invalid verse reference format: $singleVerse (original: $verseReference)');
      return;
    }

    String bookName = parts[0];
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);

    if (chapterNumber == null || verseNumber == null) {
      print('Invalid chapter or verse number: $chapterNumber, $verseNumber');
      return;
    }

    bookName = _bookNameMap[bookName] ?? bookName;
    print('Mapped book name: ${parts[0]} -> $bookName');

    final bookBox = store.box<Book>();
    final chapterBox = store.box<Chapter>();

    final book = bookBox.query(Book_.name.equals(bookName)).build().findFirst();
    if (book == null) {
      print('Book not found: $bookName');
      return;
    }

    final chapter = chapterBox
        .query(Chapter_.book.equals(book.id) & Chapter_.chapterNumber.equals(chapterNumber))
        .build()
        .findFirst();
    if (chapter == null) {
      print('Chapter not found: $bookName $chapterNumber');
      return;
    }

    print('Navigating to $bookName $chapterNumber:$verseNumber');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          initialBook: book,
          initialChapter: chapter,
          initialVerseNumber: verseNumber, // Pass verse number for scrolling
        ),
      ),
    );
  }

  void _addVerseToTopic(CreatedTopicsEn topic, String verse) {
    setState(() {
      topic.verses.add(verse);
      studyCreatedTopicsEnBox.put(topic);
      _loadTopics();
      print('Added verse $verse to topic ${topic.title}');
    });
  }

  void _deleteTopic(CreatedTopicsEn topic) {
    setState(() {
      studyCreatedTopicsEnBox.remove(topic.id);
      _loadTopics();
      print('Deleted topic ${topic.title}');
    });
  }

  void _addGeneratedTopicToCreated(GeneratedTopicsEn topic) {
    print('Adding generated topic ${topic.title} to created topics with verses: ${topic.verses}');
    final newCreatedTopic = CreatedTopicsEn(
      title: topic.title,
      verses: List.from(topic.verses),
    );
    studyCreatedTopicsEnBox.put(newCreatedTopic);
    _loadTopics();
    _searchController.clear();
    print('Successfully added ${topic.title} to created topics');
  }

  void _goToPreviousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  void _goToNextPage() {
    setState(() {
      final maxPage = (_filteredSearchResults.length / _pageSize).ceil() - 1;
      if (_currentPage < maxPage) {
        _currentPage++;
      }
    });
  }

  List<dynamic> _getPagedSearchResults() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _filteredSearchResults.length);
    return _filteredSearchResults.sublist(startIndex, endIndex);
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard: $text')),
    );
  }

  void _selectAllVerses(BuildContext context, List<String> verses) {
    final controller = TextSelection.fromPosition(
      TextPosition(offset: verses.join('\n').length),
    );
    _copyText(verses.join('\n'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All verses copied to clipboard')),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            child: _searchController.text.isEmpty
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          t.study_topics_screen.created_topics,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ..._filteredCreatedTopics.map((topic) => ExpansionTile(
                            title: SelectableText(
                              _capitalizeTitle(topic.title),
                              contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                anchors: state.contextMenuAnchors,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _copyText(topic.title);
                                      state.hideToolbar();
                                    },
                                    child: const Text('Copy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _copyText(topic.title);
                                      state.hideToolbar();
                                    },
                                    child: const Text('Select All'),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              if (topic.verses.isEmpty)
                                ListTile(
                                  title: Text(t.study_topics_screen.no_verses),
                                ),
                              ...topic.verses.map((verse) => ListTile(
                                    title: SelectionArea(
                                      contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                        anchors: state.contextMenuAnchors,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              _copyText(verse);
                                              state.hideToolbar();
                                            },
                                            child: const Text('Copy'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _selectAllVerses(context, topic.verses);
                                              state.hideToolbar();
                                            },
                                            child: const Text('Select All'),
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () => _navigateToVerse(verse),
                                        child: Text(
                                          verse,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        final createdTopic = studyCreatedTopicsEnBox
                                            .getAll()
                                            .firstWhere((t) => t.title == topic.title);
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudyTabScreen(
                                        onVerseSelected: (verseReference) {
                                          _addVerseToTopic(createdTopic, verseReference);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text(t.study_topics_screen.edit_topic),
                                leading: const Icon(Icons.edit),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudyAddEditTopicsScreen(topic: topic),
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
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            if (_filteredCreatedTopics.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  t.study_topics_screen.created_topics,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ..._filteredCreatedTopics.map((topic) => ExpansionTile(
                                  title: SelectableText(
                                    _capitalizeTitle(topic.title),
                                    contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                      anchors: state.contextMenuAnchors,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Copy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Select All'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    if (topic.verses.isEmpty)
                                      ListTile(
                                        title: Text(t.study_topics_screen.no_verses),
                                      ),
                                    ...topic.verses.map((verse) => ListTile(
                                          title: SelectionArea(
                                            contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                              anchors: state.contextMenuAnchors,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _copyText(verse);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Copy'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _selectAllVerses(context, topic.verses);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Select All'),
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () => _navigateToVerse(verse),
                                              child: Text(
                                                verse,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              final createdTopic = studyCreatedTopicsEnBox
                                                  .getAll()
                                                  .firstWhere((t) => t.title == topic.title);
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudyTabScreen(
                                              onVerseSelected: (verseReference) {
                                                _addVerseToTopic(createdTopic, verseReference);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text(t.study_topics_screen.edit_topic),
                                      leading: const Icon(Icons.edit),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudyAddEditTopicsScreen(topic: topic),
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
                            if (_filteredSearchResults.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  t.study_topics_screen.search_results,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ..._getPagedSearchResults().map((topic) {
                              if (topic is CreatedTopicsEn) {
                                return ExpansionTile(
                                  title: SelectableText(
                                    _capitalizeTitle(topic.title),
                                    contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                      anchors: state.contextMenuAnchors,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Copy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Select All'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    if (topic.verses.isEmpty)
                                      ListTile(
                                        title: Text(t.study_topics_screen.no_verses),
                                      ),
                                    ...topic.verses.map((verse) => ListTile(
                                          title: SelectionArea(
                                            contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                              anchors: state.contextMenuAnchors,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _copyText(verse);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Copy'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _selectAllVerses(context, topic.verses);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Select All'),
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () => _navigateToVerse(verse),
                                              child: Text(
                                                verse,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              final createdTopic = studyCreatedTopicsEnBox
                                                  .getAll()
                                                  .firstWhere((t) => t.title == topic.title);
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudyTabScreen(
                                              onVerseSelected: (verseReference) {
                                                _addVerseToTopic(createdTopic, verseReference);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text(t.study_topics_screen.edit_topic),
                                      leading: const Icon(Icons.edit),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudyAddEditTopicsScreen(topic: topic),
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
                                );
                              } else if (topic is GeneratedTopicsEn) {
                                return ExpansionTile(
                                  title: SelectableText(
                                    _capitalizeTitle(topic.title),
                                    contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                      anchors: state.contextMenuAnchors,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Copy'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _copyText(topic.title);
                                            state.hideToolbar();
                                          },
                                          child: const Text('Select All'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    if (topic.verses.isEmpty)
                                      ListTile(
                                        title: Text(t.study_topics_screen.no_verses),
                                      ),
                                    ...topic.verses.map((verse) => ListTile(
                                          title: SelectionArea(
                                            contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                              anchors: state.contextMenuAnchors,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    _copyText(verse);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Copy'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _selectAllVerses(context, topic.verses);
                                                    state.hideToolbar();
                                                  },
                                                  child: const Text('Select All'),
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () => _navigateToVerse(verse),
                                              child: Text(
                                                verse,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                    ListTile(
                                      title: Text(t.study_topics_screen.add_to_created),
                                      leading: const Icon(Icons.add),
                                      onTap: () {
                                        _addGeneratedTopicToCreated(topic);
                                      },
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ],
                        ),
                      ),
                      if (_filteredSearchResults.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                                tooltip: 'Previous Page',
                              ),
                              Text(
                                'Page ${_currentPage + 1} of ${(_filteredSearchResults.length / _pageSize).ceil()}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _currentPage < (_filteredSearchResults.length / _pageSize).ceil() - 1
                                    ? _goToNextPage
                                    : null,
                                tooltip: 'Next Page',
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}