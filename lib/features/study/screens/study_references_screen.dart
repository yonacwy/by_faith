import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart'; 
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class StudyReferencesScreen extends StatefulWidget {
  final String? initialVerseReference;

  const StudyReferencesScreen({super.key, this.initialVerseReference});

  @override
  State<StudyReferencesScreen> createState() => _StudyReferencesScreenState();
}

class _StudyReferencesScreenState extends State<StudyReferencesScreen> {
  final Map<String, bool> _expandedCategories = {'Old Testament': false, 'New Testament': false};
  final Map<String, bool> _expandedBooks = {};
  final Map<String, bool> _expandedChapters = {};
  final Map<String, bool> _expandedVerses = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialVerseReference != null) {
      final parts = widget.initialVerseReference!.split('.');
      if (parts.length == 3) {
        final bookName = parts[0];
        final chapterNumber = parts[1];
        final verseNumber = parts[2];
        final verseRef = '$bookName.$chapterNumber.$verseNumber';
        _expandedVerses[verseRef] = true;
        _expandedChapters['$bookName.$chapterNumber'] = true;
        _expandedBooks[bookName] = true;
        _expandedCategories[bookName.contains(RegExp(r'^(Gen|Exod|Lev|Num|Deut|Josh|Judg|Ruth|1Sam|2Sam|1Kgs|2Kgs|1Chr|2Chr|Ezra|Neh|Esth|Job|Ps|Prov|Eccl|Song|Isa|Jer|Lam|Ezek|Dan|Hos|Joel|Amos|Obad|Jonah|Mic|Nah|Hab|Zeph|Hag|Zech|Mal)')) ? 'Old Testament' : 'New Testament'] = true;
      }
    }
  }

  List<String> _getBooksForTestament(String testament, List<Book> allBooks) {
    final otBooks = [
      'Gen', 'Exod', 'Lev', 'Num', 'Deut', 'Josh', 'Judg', 'Ruth', '1Sam', '2Sam', '1Kgs', '2Kgs',
      '1Chr', '2Chr', 'Ezra', 'Neh', 'Esth', 'Job', 'Ps', 'Prov', 'Eccl', 'Song', 'Isa', 'Jer',
      'Lam', 'Ezek', 'Dan', 'Hos', 'Joel', 'Amos', 'Obad', 'Jonah', 'Mic', 'Nah', 'Hab', 'Zeph',
      'Hag', 'Zech', 'Mal'
    ];
    return allBooks
        .where((book) => testament == 'Old Testament' ? otBooks.contains(book.bookId) : !otBooks.contains(book.bookId))
        .map((book) => book.name)
        .toList();
  }

  List<int> _getChaptersForBook(String bookName) {
    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) return [];
    final book = bibleVersion.books.firstWhereOrNull((b) => b.name == bookName);
    if (book == null) return [];
    return book.chapters.map((c) => c.chapterNumber).toList();
  }

  List<int> _getVersesForChapter(String bookName, int chapterNumber) {
    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) return [];
    final book = bibleVersion.books.firstWhereOrNull((b) => b.name == bookName);
    if (book == null) return [];
    final chapter = book.chapters.firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    if (chapter == null) return [];
    return chapter.verses.map((v) => v.verseNumber).toList();
  }

  List<CrossReference> _getReferencesForVerse(String verseReference) {
    return crossReferenceBox.query(CrossReference_.verse.equals(verseReference)).build().find();
  }

  void _deleteReference(CrossReference reference) {
    crossReferenceBox.remove(reference.id);
    setState(() {});
  }

  void _navigateToVerse(String verseReference) {
    final parts = verseReference.split('.');
    if (parts.length != 3) return;
    final bookName = parts[0];
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);
    if (chapterNumber == null || verseNumber == null) return;

    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) return;
    final book = bibleVersion.books.firstWhereOrNull((b) => b.name == bookName);
    if (book == null) return;
    final chapter = book.chapters.firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    if (chapter == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          initialBook: book,
          initialChapter: chapter,
          initialVerseNumber: verseNumber,
        ),
      ),
    );
  }

  void _addReference(String fromVerse) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          onVerseSelected: (selectedVerse) {
            final newReference = CrossReference(verse: fromVerse, toVerse: selectedVerse);
            crossReferenceBox.put(newReference);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.study_references_screen.title)),
        body: const Center(child: Text('No Bible version available')),
      );
    }
    final allBooks = bibleVersion.books.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_references_screen.title),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text(t.study_references_screen.old_testament),
            initiallyExpanded: _expandedCategories['Old Testament'] ?? false,
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedCategories['Old Testament'] = expanded;
              });
            },
            children: _getBooksForTestament('Old Testament', allBooks).map((bookName) {
              return ExpansionTile(
                title: Text(bookName),
                initiallyExpanded: _expandedBooks[bookName] ?? false,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedBooks[bookName] = expanded;
                  });
                },
                children: _getChaptersForBook(bookName).map((chapterNumber) {
                  return ExpansionTile(
                    title: Text('Chapter $chapterNumber'),
                    initiallyExpanded: _expandedChapters['$bookName.$chapterNumber'] ?? false,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedChapters['$bookName.$chapterNumber'] = expanded;
                      });
                    },
                    children: _getVersesForChapter(bookName, chapterNumber).map((verseNumber) {
                      final verseRef = '$bookName.$chapterNumber.$verseNumber';
                      final references = _getReferencesForVerse(verseRef);
                      return ExpansionTile(
                        title: Text('Verse $verseNumber'),
                        initiallyExpanded: _expandedVerses[verseRef] ?? false,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedVerses[verseRef] = expanded;
                          });
                        },
                        children: [
                          if (references.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(t.study_references_screen.no_references),
                            ),
                          ...references.map((ref) {
                            return ListTile(
                              title: Text(ref.toVerse),
                              onTap: () => _navigateToVerse(ref.toVerse),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteReference(ref),
                                tooltip: t.study_references_screen.delete_reference,
                              ),
                            );
                          }),
                          ListTile(
                            title: Text(t.study_references_screen.add_verse),
                            leading: const Icon(Icons.add),
                            onTap: () => _addReference(verseRef),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text(t.study_references_screen.new_testament),
            initiallyExpanded: _expandedCategories['New Testament'] ?? false,
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedCategories['New Testament'] = expanded;
              });
            },
            children: _getBooksForTestament('New Testament', allBooks).map((bookName) {
              return ExpansionTile(
                title: Text(bookName),
                initiallyExpanded: _expandedBooks[bookName] ?? false,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedBooks[bookName] = expanded;
                  });
                },
                children: _getChaptersForBook(bookName).map((chapterNumber) {
                  return ExpansionTile(
                    title: Text('Chapter $chapterNumber'),
                    initiallyExpanded: _expandedChapters['$bookName.$chapterNumber'] ?? false,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedChapters['$bookName.$chapterNumber'] = expanded;
                      });
                    },
                    children: _getVersesForChapter(bookName, chapterNumber).map((verseNumber) {
                      final verseRef = '$bookName.$chapterNumber.$verseNumber';
                      final references = _getReferencesForVerse(verseRef);
                      return ExpansionTile(
                        title: Text('Verse $verseNumber'),
                        initiallyExpanded: _expandedVerses[verseRef] ?? false,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedVerses[verseRef] = expanded;
                          });
                        },
                        children: [
                          if (references.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(t.study_references_screen.no_references),
                            ),
                          ...references.map((ref) {
                            return ListTile(
                              title: Text(ref.toVerse),
                              onTap: () => _navigateToVerse(ref.toVerse),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteReference(ref),
                                tooltip: t.study_references_screen.delete_reference,
                              ),
                            );
                          }),
                          ListTile(
                            title: Text(t.study_references_screen.add_verse),
                            leading: const Icon(Icons.add),
                            onTap: () => _addReference(verseRef),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}