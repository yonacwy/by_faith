import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/screens/study_add_edit_references_screen.dart';
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
  Map<String, List<CrossReference>> _groupedReferences = {};

  static const Map<String, String> _bookNameMap = {
    'gen': 'Genesis', 'exo': 'Exodus', 'lev': 'Leviticus', 'num': 'Numbers',
    'deu': 'Deuteronomy', 'jos': 'Joshua', 'jdg': 'Judges', 'rut': 'Ruth',
    '1sa': '1 Samuel', '2sa': '2 Samuel', '1ki': '1 Kings', '2ki': '2 Kings',
    '1ch': '1 Chronicles', '2ch': '2 Chronicles', 'ezr': 'Ezra', 'neh': 'Nehemiah',
    'est': 'Esther', 'job': 'Job', 'psa': 'Psalms', 'pro': 'Proverbs',
    'ecc': 'Ecclesiastes', 'sng': 'Song of Solomon', 'isa': 'Isaiah', 'jer': 'Jeremiah',
    'lam': 'Lamentations', 'ezk': 'Ezekiel', 'dan': 'Daniel', 'hos': 'Hosea',
    'jol': 'Joel', 'amo': 'Amos', 'oba': 'Obadiah', 'jon': 'Jonah',
    'mic': 'Micah', 'nam': 'Nahum', 'hab': 'Habakkuk', 'zep': 'Zephaniah',
    'hag': 'Haggai', 'zec': 'Zechariah', 'mal': 'Malachi', 'mat': 'Matthew',
    'mrk': 'Mark', 'luk': 'Luke', 'jhn': 'John', 'act': 'Acts',
    'rom': 'Romans', '1co': '1 Corinthians', '2co': '2 Corinthians', 'gal': 'Galatians',
    'eph': 'Ephesians', 'php': 'Philippians', 'col': 'Colossians', '1th': '1 Thessalonians',
    '2th': '2 Thessalonians', '1ti': '1 Timothy', '2ti': '2 Timothy', 'tit': 'Titus',
    'phm': 'Philemon', 'heb': 'Hebrews', 'jas': 'James', '1pe': '1 Peter',
    '2pe': '2 Peter', '1jn': '1 John', '2jn': '2 John', '3jn': '3 John',
    'jud': 'Jude', 'rev': 'Revelation',
    // Additional mappings for JSON-style book IDs
    'Gen': 'Genesis', 'Exod': 'Exodus', 'Lev': 'Leviticus', 'Num': 'Numbers',
    'Deut': 'Deuteronomy', 'Josh': 'Joshua', 'Judg': 'Judges', 'Ruth': 'Ruth',
    '1Sam': '1 Samuel', '2Sam': '2 Samuel', '1Kgs': '1 Kings', '2Kgs': '2 Kings',
    '1Chr': '1 Chronicles', '2Chr': '2 Chronicles', 'Ezra': 'Ezra', 'Neh': 'Nehemiah',
    'Esth': 'Esther', 'Job': 'Job', 'Ps': 'Psalms', 'Prov': 'Proverbs',
    'Eccl': 'Ecclesiastes', 'Song': 'Song of Solomon', 'Isa': 'Isaiah', 'Jer': 'Jeremiah',
    'Lam': 'Lamentations', 'Ezek': 'Ezekiel', 'Dan': 'Daniel', 'Hos': 'Hosea',
    'Joel': 'Joel', 'Amos': 'Amos', 'Obad': 'Obadiah', 'Jonah': 'Jonah',
    'Mic': 'Micah', 'Nah': 'Nahum', 'Hab': 'Habakkuk', 'Zeph': 'Zephaniah',
    'Hag': 'Haggai', 'Zech': 'Zechariah', 'Mal': 'Malachi', 'Matt': 'Matthew',
    'Mark': 'Mark', 'Luke': 'Luke', 'John': 'John', 'Acts': 'Acts',
    'Rom': 'Romans', '1Cor': '1 Corinthians', '2Cor': '2 Corinthians', 'Gal': 'Galatians',
    'Eph': 'Ephesians', 'Phil': 'Philippians', 'Col': 'Colossians', '1Thess': '1 Thessalonians',
    '2Thess': '2 Thessalonians', '1Tim': '1 Timothy', '2Tim': '2 Timothy', 'Titus': 'Titus',
    'Phlm': 'Philemon', 'Heb': 'Hebrews', 'Jas': 'James', '1Pet': '1 Peter',
    '2Pet': '2 Peter', '1John': '1 John', '2John': '2 John', '3John': '3 John',
    'Jude': 'Jude', 'Rev': 'Revelation',
  };

  static const Map<String, String> _bookIdToStorageIdMap = {
    'gen': 'GEN', 'exo': 'EXO', 'lev': 'LEV', 'num': 'NUM',
    'deu': 'DEU', 'jos': 'JOS', 'jdg': 'JDG', 'rut': 'RUT',
    '1sa': '1SA', '2sa': '2SA', '1ki': '1KI', '2ki': '2KI',
    '1ch': '1CH', '2ch': '2CH', 'ezr': 'EZR', 'neh': 'NEH',
    'est': 'EST', 'job': 'JOB', 'psa': 'PSA', 'pro': 'PRO',
    'ecc': 'ECC', 'sng': 'SNG', 'isa': 'ISA', 'jer': 'JER',
    'lam': 'LAM', 'ezk': 'EZK', 'dan': 'DAN', 'hos': 'HOS',
    'jol': 'JOL', 'amo': 'AMO', 'oba': 'OBA', 'jon': 'JON',
    'mic': 'MIC', 'nam': 'NAM', 'hab': 'HAB', 'zep': 'ZEP',
    'hag': 'HAG', 'zec': 'ZEC', 'mal': 'MAL', 'mat': 'MAT',
    'mrk': 'MRK', 'luk': 'LUK', 'jhn': 'JHN', 'act': 'ACT',
    'rom': 'ROM', '1co': '1CO', '2co': '2CO', 'gal': 'GAL',
    'eph': 'EPH', 'php': 'PHP', 'col': 'COL', '1th': '1TH',
    '2th': '2TH', '1ti': '1TI', '2ti': '2TI', 'tit': 'TIT',
    'phm': 'PHM', 'heb': 'HEB', 'jas': 'JAS', '1pe': '1PE',
    '2pe': '2PE', '1jn': '1JN', '2jn': '2JN', '3jn': '3JN',
    'jud': 'JUD', 'rev': 'REV',
    'Gen': 'GEN', 'Exod': 'EXO', 'Lev': 'LEV', 'Num': 'NUM',
    'Deut': 'DEU', 'Josh': 'JOS', 'Judg': 'JDG', 'Ruth': 'RUT',
    '1Sam': '1SA', '2Sam': '2SA', '1Kgs': '1KI', '2Kgs': '2KI',
    '1Chr': '1CH', '2Chr': '2CH', 'Ezra': 'EZR', 'Neh': 'NEH',
    'Esth': 'EST', 'Job': 'JOB', 'Ps': 'PSA', 'Prov': 'PRO',
    'Eccl': 'ECC', 'Song': 'SNG', 'Isa': 'ISA', 'Jer': 'JER',
    'Lam': 'LAM', 'Ezek': 'EZK', 'Dan': 'DAN', 'Hos': 'HOS',
    'Joel': 'JOL', 'Amos': 'AMO', 'Obad': 'OBA', 'Jonah': 'JON',
    'Mic': 'MIC', 'Nah': 'NAM', 'Hab': 'HAB', 'Zeph': 'ZEP',
    'Hag': 'HAG', 'Zech': 'ZEC', 'Mal': 'MAL', 'Matt': 'MAT',
    'Mark': 'MRK', 'Luke': 'LUK', 'John': 'JHN', 'Acts': 'ACT',
    'Rom': 'ROM', '1Cor': '1CO', '2Cor': '2CO', 'Gal': 'GAL',
    'Eph': 'EPH', 'Phil': 'PHP', 'Col': 'COL', '1Thess': '1TH',
    '2Thess': '2TH', '1Tim': '1TI', '2Tim': '2TI', 'Titus': 'TIT',
    'Phlm': 'PHM', 'Heb': 'HEB', 'Jas': 'JAS', '1Pet': '1PE',
    '2Pet': '2PE', '1John': '1JN', '2John': '2JN', '3John': '3JN',
    'Jude': 'JUD', 'Rev': 'REV',
  };

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  String _formatVerseReference(String verseReference) {
    final parts = verseReference.split('.');
    if (parts.length != 3) return verseReference;
    final bookId = parts[0];
    final bookName = _bookNameMap[bookId] ?? _bookNameMap[bookId.toLowerCase()] ?? bookId;
    return '$bookName ${parts[1]}:${parts[2]}';
  }

  void _loadReferences() {
    final allReferences = crossReferenceBox.getAll();
    _groupedReferences = groupBy(allReferences, (reference) => reference.verse);
    setState(() {});
  }

  void _deleteReference(CrossReference reference) {
    crossReferenceBox.remove(reference.id);
    _loadReferences();
  }

  void _navigateToVerse(String verseReference) {
    final parts = verseReference.split('.');
    if (parts.length != 3) return;
    final bookId = parts[0];
    final mappedBookId = _bookIdToStorageIdMap[bookId] ?? _bookIdToStorageIdMap[bookId.toLowerCase()] ?? bookId.toUpperCase();
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);
    if (chapterNumber == null || verseNumber == null) return;

    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) return;
    final book = bibleVersion.books.firstWhereOrNull((b) => b.bookId.toUpperCase() == mappedBookId.toUpperCase());
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

  void _editReferences(String verseReference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyAddEditReferencesScreen(
          verseReference: verseReference,
        ),
      ),
    ).then((_) => _loadReferences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_references_screen.title),
      ),
      body: _groupedReferences.isEmpty
          ? Center(child: Text(t.study_references_screen.no_references))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _groupedReferences.keys.length,
              itemBuilder: (context, index) {
                final verse = _groupedReferences.keys.elementAt(index);
                final references = _groupedReferences[verse]!;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ExpansionTile(
                    title: Text(_formatVerseReference(verse)),
                    children: references.map((reference) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 32.0),
                        title: Text(_formatVerseReference(reference.toVerse)),
                        onTap: () => _navigateToVerse(reference.toVerse),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: t.study_references_screen.edit_reference,
                              onPressed: () => _editReferences(reference.verse),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: t.study_references_screen.delete_reference,
                              onPressed: () => _deleteReference(reference),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudyTabScreen(
                onVerseSelected: (selectedVerse) {
                  _editReferences(selectedVerse);
                },
              ),
            ),
          );
        },
        tooltip: t.study_references_screen.add_reference,
        child: const Icon(Icons.add),
      ),
    );
  }
}