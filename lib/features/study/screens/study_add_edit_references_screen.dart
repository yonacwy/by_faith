import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/screens/study_references_screen.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:collection/collection.dart';

class StudyAddEditReferencesScreen extends StatefulWidget {
  final String verseReference;

  const StudyAddEditReferencesScreen({super.key, required this.verseReference});

  @override
  State<StudyAddEditReferencesScreen> createState() => _StudyAddEditReferencesScreenState();
}

class _StudyAddEditReferencesScreenState extends State<StudyAddEditReferencesScreen> {
  List<Map<String, String>> _jsonReferencesWithText = [];
  List<CrossReference> _userReferences = [];

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
    // Additional mappings for input variations
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
  };

  static const Map<String, String> _storageIdToJsonIdMap = {
    'GEN': 'Gen', 'EXO': 'Exod', 'LEV': 'Lev', 'NUM': 'Num',
    'DEU': 'Deut', 'JOS': 'Josh', 'JDG': 'Judg', 'RUT': 'Ruth',
    '1SA': '1Sam', '2SA': '2Sam', '1KI': '1Kgs', '2KI': '2Kgs',
    '1CH': '1Chr', '2CH': '2Chr', 'EZR': 'Ezra', 'NEH': 'Neh',
    'EST': 'Esth', 'JOB': 'Job', 'PSA': 'Ps', 'PRO': 'Prov',
    'ECC': 'Eccl', 'SNG': 'Song', 'ISA': 'Isa', 'JER': 'Jer',
    'LAM': 'Lam', 'EZK': 'Ezek', 'DAN': 'Dan', 'HOS': 'Hos',
    'JOL': 'Joel', 'AMO': 'Amos', 'OBA': 'Obad', 'JON': 'Jonah',
    'MIC': 'Mic', 'NAM': 'Nah', 'HAB': 'Hab', 'ZEP': 'Zeph',
    'HAG': 'Hag', 'ZEC': 'Zech', 'MAL': 'Mal', 'MAT': 'Matt',
    'MRK': 'Mark', 'LUK': 'Luke', 'JHN': 'John', 'ACT': 'Acts',
    'ROM': 'Rom', '1CO': '1Cor', '2CO': '2Cor', 'GAL': 'Gal',
    'EPH': 'Eph', 'PHP': 'Phil', 'COL': 'Col', '1TH': '1Thess',
    '2TH': '2Thess', '1TI': '1Tim', '2TI': '2Tim', 'TIT': 'Titus',
    'PHM': 'Phlm', 'HEB': 'Heb', 'JAS': 'Jas', '1PE': '1Pet',
    '2PE': '2Pet', '1JN': '1John', '2JN': '2John', '3JN': '3John',
    'JUD': 'Jude', 'REV': 'Rev',
  };

  @override
  void initState() {
    super.initState();
    print('Input verseReference: ${widget.verseReference}');
    _loadReferences();
  }

  String _normalizeVerseReference(String verseReference) {
    // Normalize verse reference to match JSON key format (e.g., 2ti.1.1 to 2Tim.1.1)
    final parts = verseReference.split('.');
    if (parts.length != 3) return verseReference;
    final bookId = parts[0];
    final storageId = _bookIdToStorageIdMap[bookId] ?? _bookIdToStorageIdMap[bookId.toLowerCase()] ?? bookId.toUpperCase();
    final normalizedBookId = _storageIdToJsonIdMap[storageId] ?? bookId;
    final result = '$normalizedBookId.${parts[1]}.${parts[2]}';
    print('Normalized $verseReference to $result');
    return result;
  }

  String _formatVerseReference(String verseReference) {
    // Convert verse reference to human-readable format (e.g., 2ti.1.1 to 2 Timothy 1:1)
    final parts = verseReference.split('.');
    if (parts.length != 3) return verseReference;
    final bookId = parts[0];
    final bookName = _bookNameMap[bookId] ?? _bookNameMap[bookId.toLowerCase()] ?? bookId;
    final result = '$bookName ${parts[1]}:${parts[2]}';
    print('Formatted $verseReference to $result');
    return result;
  }

  Future<void> _loadReferences() async {
    try {
      // Load references from cross_references.json
      final String response = await rootBundle.loadString('lib/features/study/assets/data/cross_references.json');
      final Map<String, dynamic> data = jsonDecode(response);
      final normalizedReference = _normalizeVerseReference(widget.verseReference);
      print('DEBUG: Searching for references with key: $normalizedReference');

      final List<dynamic>? rawReferences = data[normalizedReference];

      if (rawReferences != null) {
        _jsonReferencesWithText = await Future.wait(rawReferences.map((item) async {
          final toVerse = item['toVerse'] as String;
          final verseText = await _getVerseText(toVerse);
          return {'toVerse': toVerse, 'verseText': verseText};
        }).toList());
      } else {
        print('No references found for $normalizedReference in cross_references.json');
        _jsonReferencesWithText = [];
      }

      // Load user-edited references from crossReferenceBox
      _userReferences = crossReferenceBox
          .query(CrossReference_.verse.equals(widget.verseReference))
          .build()
          .find();
    } catch (e) {
      print('Error loading references: $e');
      _jsonReferencesWithText = [];
    }

    setState(() {});
  }

  Future<String> _getVerseText(String verseReference) async {
    if (verseReference.contains('-')) {
      // Handle verse ranges (e.g., John.5:39-John.5:40)
      final parts = verseReference.split('-');
      if (parts.length != 2) return 'Invalid verse range';
      final startRef = parts[0];
      final endRef = parts[1];

      // Ensure both references are valid and in the same book and chapter
      final startParts = startRef.split('.');
      final endParts = endRef.split('.');
      if (startParts.length != 3 || endParts.length != 3 || startParts[0] != endParts[0] || startParts[1] != endParts[1]) {
        return 'Invalid verse range format';
      }

      final bookId = startParts[0];
      final mappedBookId = _bookIdToStorageIdMap[bookId] ?? _bookIdToStorageIdMap[bookId.toLowerCase()] ?? bookId.toUpperCase();
      final chapterNumber = int.tryParse(startParts[1]);
      final startVerse = int.tryParse(startParts[2]);
      final endVerse = int.tryParse(endParts[2]);

      if (chapterNumber == null || startVerse == null || endVerse == null) {
        return 'Invalid verse numbers in range';
      }

      final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
      if (bibleVersion == null) {
        return 'No Bible version found';
      }

      final book = bibleVersion.books.toList().firstWhereOrNull((b) => b.bookId.toUpperCase() == mappedBookId.toUpperCase());
      if (book == null) {
        return 'Book not found';
      }

      final chapter = book.chapters.toList().firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
      if (chapter == null) {
        return 'Chapter not found';
      }

      // Fetch text for all verses in the range
      final verses = chapter.verses.toList().where((v) => v.verseNumber >= startVerse && v.verseNumber <= endVerse).toList();
      if (verses.isEmpty) {
        return 'No verses found in range';
      }

      // Combine verse texts with verse numbers
      return verses.map((v) => '${v.verseNumber}. ${v.text}').join(' ');
    }

    // Handle single verse
    final parts = verseReference.split('.');
    if (parts.length != 3) {
      print('Invalid verse reference format: $verseReference');
      return 'Invalid verse reference';
    }

    final String originalBookId = parts[0];
    final String mappedBookId = _bookIdToStorageIdMap[originalBookId] ?? _bookIdToStorageIdMap[originalBookId.toLowerCase()] ?? originalBookId.toUpperCase();
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);

    if (chapterNumber == null || verseNumber == null) {
      print('Invalid chapter or verse number in: $verseReference');
      return 'Invalid verse numbers';
    }

    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) {
      print('No Bible version found');
      return 'No Bible version found';
    }

    final book = bibleVersion.books.toList().firstWhereOrNull((b) {
      final isMatch = b.bookId.toUpperCase() == mappedBookId.toUpperCase();
      print('DEBUG: Comparing search bookId "${mappedBookId.toUpperCase()}" with stored bookId "${b.bookId.toUpperCase()}" (original: ${b.bookId}) - Match: $isMatch');
      return isMatch;
    });

    if (book == null) {
      print('Book not found for ID: $mappedBookId (original: $originalBookId)');
      return 'Book not found';
    }

    final chapter = book.chapters.toList().firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    if (chapter == null) {
      print('Chapter $chapterNumber not found in book: $mappedBookId');
      return 'Chapter not found';
    }

    final verse = chapter.verses.toList().firstWhereOrNull((v) => v.verseNumber == verseNumber);
    if (verse == null) {
      print('Verse $verseNumber not found in chapter $chapterNumber of book: $mappedBookId');
      return 'Verse not found';
    }

    return verse.text;
  }

  void _addReference() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          onVerseSelected: (selectedVerse) {
            final newReference = CrossReference(verse: widget.verseReference, toVerse: selectedVerse);
            crossReferenceBox.put(newReference);
            _loadReferences();
          },
        ),
      ),
    );
  }

  void _deleteReference(CrossReference reference) {
    crossReferenceBox.remove(reference.id);
    _loadReferences();
  }

  void _navigateToVerse(String verseReference) {
    if (verseReference.contains('-')) {
      // For verse ranges, navigate to the first verse
      verseReference = verseReference.split('-')[0];
    }

    final parts = verseReference.split('.');
    if (parts.length != 3) {
      print('Invalid verse reference for navigation: $verseReference');
      return;
    }

    final String originalBookId = parts[0];
    final String mappedBookId = _bookIdToStorageIdMap[originalBookId] ?? _bookIdToStorageIdMap[originalBookId.toLowerCase()] ?? originalBookId.toUpperCase();
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);

    if (chapterNumber == null || verseNumber == null) {
      print('Invalid chapter or verse number for navigation: $verseReference');
      return;
    }

    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) {
      print('No Bible version found for navigation');
      return;
    }

    final book = bibleVersion.books.toList().firstWhereOrNull((b) => b.bookId.toUpperCase() == mappedBookId.toUpperCase());
    if (book == null) {
      print('Book not found for navigation: $mappedBookId');
      return;
    }

    final chapter = book.chapters.toList().firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    if (chapter == null) {
      print('Chapter not found for navigation: $chapterNumber in $mappedBookId');
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final formattedReference = _formatVerseReference(widget.verseReference);
    print('Rendering title with: $formattedReference');
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_add_edit_references_screen.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              t.study_add_edit_references_screen.current_verse.replaceAll('{verseReference}', formattedReference),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_jsonReferencesWithText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.json_references,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._jsonReferencesWithText.map((refMap) {
                    final ref = refMap['toVerse']!;
                    final verseText = refMap['verseText']!;
                    return ListTile(
                      title: Text(_formatVerseReference(ref)),
                      subtitle: Text(verseText),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(t.study_add_edit_references_screen.add_reference_dialog_title),
                              content: Text(t.study_add_edit_references_screen.add_reference_dialog_content.replaceAll('{toVerse}', _formatVerseReference(ref))),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(t.study_add_edit_references_screen.cancel_button),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(t.study_add_edit_references_screen.add_button),
                                  onPressed: () {
                                    final newReference = CrossReference(verse: widget.verseReference, toVerse: ref);
                                    crossReferenceBox.put(newReference);
                                    _loadReferences();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }),
                ],
                if (_userReferences.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.user_references,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._userReferences.map((ref) => FutureBuilder<String>(
                        future: _getVerseText(ref.toVerse),
                        builder: (context, snapshot) {
                          final verseText = snapshot.data ?? 'Loading...';
                          return ListTile(
                            title: Text(_formatVerseReference(ref.toVerse)),
                            subtitle: Text(verseText),
                            onTap: () => _navigateToVerse(ref.toVerse),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: t.study_add_edit_references_screen.delete_reference,
                              onPressed: () => _deleteReference(ref),
                            ),
                          );
                        },
                      )),
                ],
                if (_jsonReferencesWithText.isEmpty && _userReferences.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No cross-references available for $formattedReference. Try adding your own.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReference,
        tooltip: t.study_add_edit_references_screen.add_reference,
        child: const Icon(Icons.add),
      ),
    );
  }
}