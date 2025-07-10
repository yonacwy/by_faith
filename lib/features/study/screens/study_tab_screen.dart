import 'package:by_faith/features/study/screens/study_references_screen.dart';
import 'package:by_faith/features/study/screens/study_topics_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:by_faith/features/study/screens/study_notes_screen.dart';
import 'package:by_faith/features/study/screens/study_search_screen.dart';
import 'package:by_faith/features/study/screens/study_settings_screen.dart';
import 'package:by_faith/features/study/screens/study_mapping_screen.dart';
import 'package:by_faith/features/study/screens/study_share_screen.dart';
import 'package:by_faith/features/study/screens/study_export_import_screen.dart';
import 'package:by_faith/features/study/screens/study_plans_screen.dart';
import 'package:by_faith/features/study/screens/study_strongs_dictionary_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:collection/collection.dart';

class StudyTabScreen extends StatefulWidget {
  const StudyTabScreen({super.key});

  @override
  State<StudyTabScreen> createState() => _StudyTabScreenState();
}

class _StudyTabScreenState extends State<StudyTabScreen> {
  BibleVersion? _selectedBibleVersion;
  Book? _selectedBook;
  Chapter? _selectedChapter;
  List<Verse> _verses = [];

  @override
  void initState() {
    super.initState();
    _loadInitialBibleData();
  }

  Future<void> _loadInitialBibleData() async {
    final bibleVersionBox = store.box<BibleVersion>();
    final allBibles = bibleVersionBox.getAll();
    print('Loaded ${allBibles.length} Bible versions from ObjectBox.');
    final prefs = getUserPreferences(userPreferencesBox);

    BibleVersion? initialBible;
    if (prefs.currentBibleVersionId != null) {
      initialBible = bibleVersionBox.get(prefs.currentBibleVersionId!);
    }
    initialBible ??= allBibles.firstOrNull;

    if (initialBible != null) {
      setState(() {
        _selectedBibleVersion = allBibles.firstWhere((b) => b.id == initialBible!.id);
      });
      await _loadBooks(initialBible);
    }
  }

  Future<void> _loadBooks(BibleVersion bibleVersion) async {
    print('Loading books for ${bibleVersion.name}. Books count: ${bibleVersion.books.length}');
    if (bibleVersion.books.isNotEmpty) {
      setState(() {
        _selectedBook = bibleVersion.books.first;
      });
      print('Selected book: ${_selectedBook?.name}');
      await _loadChapters(bibleVersion.books.first);
    } else {
      setState(() {
        _selectedBook = null;
        _selectedChapter = null;
        _verses = [];
      });
      print('No books found for ${bibleVersion.name}.');
    }
  }

  Future<void> _loadChapters(Book book) async {
    print('Loading chapters for ${book.name}. Chapters count: ${book.chapters.length}');
    if (book.chapters.isNotEmpty) {
      setState(() {
        _selectedChapter = book.chapters.first;
      });
      print('Selected chapter: ${_selectedChapter?.chapterNumber}');
      await _loadVerses(book.chapters.first);
    } else {
      setState(() {
        _selectedChapter = null;
        _verses = [];
      });
      print('No chapters found for ${book.name}.');
    }
  }

  Future<void> _loadVerses(Chapter chapter) async {
    setState(() {
      _verses = chapter.verses.toList();
    });
    print('Loaded ${_verses.length} verses for chapter ${chapter.chapterNumber}.');
  }

  List<InlineSpan> _buildVerseText(Verse verse, BuildContext context) {
    final fontProvider = context.watch<StudySettingsFontProvider>();
    final textStyle = TextStyle(
      fontFamily: fontProvider.fontFamily,
      fontSize: fontProvider.fontSize,
      color: Colors.black,
    );
    final strongsStyle = TextStyle(
      fontFamily: fontProvider.fontFamily,
      fontSize: fontProvider.fontSize,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    final words = verse.text.split(' ').where((w) => w.isNotEmpty).toList();
    final spans = <InlineSpan>[];
    int wordIndex = 0;

    // Sort strongsEntries by position to ensure correct order
    final sortedEntries = verse.strongsEntries.toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    for (final entry in sortedEntries) {
      // Add non-Strong's words before the current Strong's entry
      while (wordIndex < entry.position && wordIndex < words.length) {
        spans.add(TextSpan(text: '${words[wordIndex]} ', style: textStyle));
        wordIndex++;
      }
      // Add the Strong's-linked word
      if (wordIndex < words.length) {
        spans.add(WidgetSpan(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyStrongsDictionaryScreen(
                    strongsNumber: entry.strongsNumber,
                  ),
                ),
              );
            },
            child: Text(
              '${entry.word} ',
              style: strongsStyle,
            ),
          ),
        ));
        wordIndex++;
      }
    }

    // Add remaining words
    while (wordIndex < words.length) {
      spans.add(TextSpan(text: '${words[wordIndex]} ', style: textStyle));
      wordIndex++;
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final bibleVersions = store.box<BibleVersion>().getAll();
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    String bibleAbbr(BibleVersion v) => v.name.length > 6 ? v.name.split(' ').map((w) => w[0]).join().toUpperCase() : v.name;
    String bookAbbr(Book b) {
      if (b.bookId.length <= 4) {
        return b.bookId[0].toUpperCase() + b.bookId.substring(1).toLowerCase();
      } else {
        return b.bookId.substring(0, 1).toUpperCase() + b.bookId.substring(1, 3).toLowerCase();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_tab_screen.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudySearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[900],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      t.study_tab_screen.study_menu,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudyShareScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.import_export, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudyExportImportScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StudySettingsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: Text(t.study_tab_screen.mapping),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyMappingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notes),
              title: Text(t.study_tab_screen.notes),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyNotesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_note),
              title: Text(t.study_tab_screen.plans),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyPlansScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(t.study_tab_screen.references),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyReferencesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.topic),
              title: Text(t.study_tab_screen.topics),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyTopicsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: isSmallScreen ? 2 : 3,
                  child: DropdownButton<BibleVersion>(
                    isExpanded: true,
                    value: _selectedBibleVersion == null
                        ? null
                        : bibleVersions.firstWhereOrNull((b) => b.id == _selectedBibleVersion!.id),
                    hint: Text(isSmallScreen ? t.study_tab_screen.bibles : t.study_tab_screen.select_bible_version),
                    onChanged: (BibleVersion? newValue) async {
                      if (newValue != null) {
                        final selected = bibleVersions.firstWhere((b) => b.id == newValue.id);
                        setState(() {
                          _selectedBibleVersion = selected;
                          _selectedBook = null;
                          _selectedChapter = null;
                          _verses = [];
                        });
                        await _loadBooks(selected);
                        final prefs = getUserPreferences(userPreferencesBox);
                        prefs.currentBibleVersionId = selected.id;
                        userPreferencesBox.put(prefs);
                      }
                    },
                    items: bibleVersions.map<DropdownMenuItem<BibleVersion>>((BibleVersion value) {
                      return DropdownMenuItem<BibleVersion>(
                        value: value,
                        child: Text(isSmallScreen ? bibleAbbr(value) : value.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  flex: isSmallScreen ? 2 : 3,
                  child: DropdownButton<Book>(
                    isExpanded: true,
                    value: _selectedBook,
                    hint: Text(isSmallScreen ? t.study_tab_screen.bibles : t.study_tab_screen.select_book),
                    onChanged: (Book? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _selectedBook = newValue;
                          _selectedChapter = null;
                          _verses = [];
                        });
                        await _loadChapters(newValue);
                      }
                    },
                    items: _selectedBibleVersion?.books.map<DropdownMenuItem<Book>>((Book value) {
                      return DropdownMenuItem<Book>(
                        value: value,
                        child: Text(isSmallScreen ? bookAbbr(value) : value.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList() ?? [],
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  flex: 1,
                  child: DropdownButton<Chapter>(
                    isExpanded: true,
                    value: _selectedChapter,
                    hint: Text(t.study_tab_screen.select_chapter),
                    onChanged: (Chapter? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _selectedChapter = newValue;
                        });
                        await _loadVerses(newValue);
                      }
                    },
                    items: _selectedBook?.chapters.map<DropdownMenuItem<Chapter>>((Chapter value) {
                      return DropdownMenuItem<Chapter>(
                        value: value,
                        child: Text(value.chapterNumber.toString()),
                      );
                    }).toList() ?? [],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: _verses.length,
                itemBuilder: (context, index) {
                  final verse = _verses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${verse.verseNumber}. ',
                            style: TextStyle(
                              fontFamily: context.watch<StudySettingsFontProvider>().fontFamily,
                              fontSize: context.watch<StudySettingsFontProvider>().fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ..._buildVerseText(verse, context),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}