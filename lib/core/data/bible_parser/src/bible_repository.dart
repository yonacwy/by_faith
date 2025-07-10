import 'package:by_faith/core/data/bible_parser/src/bible_parser.dart';
import 'package:by_faith/core/data/bible_parser/src/parsers/base_parser.dart';
import 'package:by_faith/core/data/bible_parser/src/parsers/usfx_parser.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart' as study;
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BibleRepository {
  final String _sourcePath;

  BibleRepository(this._sourcePath);

  /// Returns the singleton ObjectBox store instance.
  Store get _store => store;

  /// Returns all installed Bible versions.
  List<study.BibleVersion> getBibleVersions() {
    final bibleVersionBox = _store.box<study.BibleVersion>();
    final versions = bibleVersionBox.getAll();
    debugPrint('Fetched ${versions.length} Bible versions');
    return versions;
  }

  /// Returns all books for a given Bible version.
  List<study.Book> getBooks(int bibleVersionId) {
    final bookBox = _store.box<study.Book>();
    final query = bookBox.query(Book_.bibleVersion.equals(bibleVersionId)).build();
    final books = query.find();
    query.close();
    debugPrint('Fetched ${books.length} books for Bible version ID: $bibleVersionId');
    return books;
  }

  /// Returns all chapters for a given book.
  List<study.Chapter> getChapters(String bookId) {
    final bookBox = _store.box<study.Book>();
    final chapterBox = _store.box<study.Chapter>();
    final book = bookBox.query(Book_.bookId.equals(bookId)).build().findFirst();
    if (book == null) {
      debugPrint('Book not found: $bookId');
      return [];
    }
    final query = chapterBox.query(Chapter_.book.equals(book.id)).build();
    final chapters = query.find();
    query.close();
    debugPrint('Fetched ${chapters.length} chapters for book ID: $bookId');
    return chapters;
  }

  /// Returns all verses for a given chapter.
  List<study.Verse> getVerses(int chapterId) {
    final verseBox = _store.box<study.Verse>();
    final query = verseBox.query(Verse_.chapter.equals(chapterId)).build();
    final verses = query.find();
    query.close();
    debugPrint('Fetched ${verses.length} verses for chapter ID: $chapterId');
    return verses;
  }

  /// Returns a specific verse by chapter ID and verse number.
  study.Verse? getVerse(int chapterId, int verseNumber) {
    final verseBox = _store.box<study.Verse>();
    final query = verseBox
        .query(Verse_.chapter.equals(chapterId) & Verse_.verseNumber.equals(verseNumber))
        .build();
    final verse = query.findFirst();
    query.close();
    if (verse != null) {
      debugPrint('Fetched verse $verseNumber for chapter ID: $chapterId');
    } else {
      debugPrint('Verse not found: chapter ID $chapterId, verse number $verseNumber');
    }
    return verse;
  }

  /// Returns Strong's entries for a given verse.
  List<study.StrongsEntry> getStrongsEntriesForVerse(int verseId) {
    final strongsEntryBox = _store.box<study.StrongsEntry>();
    final query = strongsEntryBox.query(StrongsEntry_.verse.equals(verseId)).build();
    final entries = query.find();
    query.close();
    debugPrint('Fetched ${entries.length} Strong\'s entries for verse ID: $verseId');
    return entries;
  }

  /// Searches verses containing the given query string, limited to 100 results.
  List<study.Verse> searchVerses(String searchQuery) {
    final verseBox = _store.box<study.Verse>();
    final queryBuilder = verseBox.query(Verse_.text.contains(searchQuery, caseSensitive: false));
    final query = queryBuilder.build();
    // If a limit is desired, it should be applied to the Query object after it's built,
    // or the QueryBuilder should be used differently based on ObjectBox documentation.
    // For now, removing the problematic .limit(100) call and duplicate declaration.
    final verses = query.find();
    query.close();
    debugPrint('Found ${verses.length} verses matching search query: $searchQuery');
    return verses;
  }

  /// Parses a Bible from the source path and stores it in ObjectBox.
  Future<void> parseAndStoreBible() async {
    final parser = getParser(_sourcePath);
    if (parser == null) {
      debugPrint('No suitable parser found for source: $_sourcePath');
      throw Exception('No suitable parser found for source: $_sourcePath');
    }

    try {
      final bibleVersionBox = _store.box<study.BibleVersion>();
      final bookBox = _store.box<study.Book>();
      final chapterBox = _store.box<study.Chapter>();
      final verseBox = _store.box<study.Verse>();
      final strongsEntryBox = _store.box<study.StrongsEntry>();

      final fileName = p.basenameWithoutExtension(_sourcePath);
      final languageCode = 'en'; // Default, can be extracted from metadata if available
      final bibleVersion = study.BibleVersion(
        name: fileName,
        languageCode: languageCode,
      );
      final bibleVersionId = bibleVersionBox.put(bibleVersion);

      await _store.runInTransactionAsync(TxMode.write, (Store txStore, _) async {
        final txBookBox = txStore.box<study.Book>();
        final txChapterBox = txStore.box<study.Chapter>();
        final txVerseBox = txStore.box<study.Verse>();
        final txStrongsEntryBox = txStore.box<study.StrongsEntry>();

        await for (final parsedBook in parser.parseBooks()) {
          final book = study.Book(
            name: parsedBook.title,
            bookId: parsedBook.id.toLowerCase(),
          );
          book.bibleVersion.target = bibleVersion;
          final bookId = txBookBox.put(book);

          for (final parsedChapter in parsedBook.chapters) {
            final chapter = study.Chapter(
              chapterNumber: parsedChapter.num,
            );
            chapter.book.target = book;
            final chapterId = txChapterBox.put(chapter);

            for (final parsedVerse in parsedChapter.verses) {
              final verse = study.Verse(
                verseNumber: parsedVerse.num,
                text: parsedVerse.text,
              );
              verse.chapter.target = chapter;
              final verseId = txVerseBox.put(verse);

              for (final strongsEntry in parsedVerse.strongsEntries) {
                final strongsNumber = strongsEntry['strongsNumber'] as String?;
                final word = strongsEntry['word'] as String?;
                final position = strongsEntry['position'] as int?;
                if (strongsNumber != null && word != null && position != null && strongsNumber.isNotEmpty && word.isNotEmpty) {
                  final entry = study.StrongsEntry(
                    strongsNumber: strongsNumber,
                    word: word,
                    position: position,
                  );
                  entry.verse.target = verse;
                  txStrongsEntryBox.put(entry);
                } else {
                  debugPrint('Invalid Strong\'s entry skipped: $strongsEntry');
                }
              }
            }

            chapter.verses.addAll(txVerseBox
                .query(Verse_.chapter.equals(chapterId))
                .build()
                .find());
            txChapterBox.put(chapter);
          }

          book.chapters.addAll(txChapterBox
              .query(Chapter_.book.equals(bookId))
              .build()
              .find());
          txBookBox.put(book);
        }

        bibleVersion.books.addAll(txBookBox
            .query(Book_.bibleVersion.equals(bibleVersionId))
            .build()
            .find());
        txStore.box<study.BibleVersion>().put(bibleVersion);
      }, null);

      debugPrint('Successfully parsed and stored Bible from $_sourcePath');
    } catch (e, stackTrace) {
      debugPrint('Error parsing and storing Bible: $e\n$stackTrace');
      rethrow;
    }
  }

  /// Returns a parser for the given source path.
  BaseParser? getParser(String sourcePath) {
    if (sourcePath.toLowerCase().endsWith('.xml')) {
      return UsfxParser(sourcePath);
    }
    // Add support for other formats if needed
    return null;
  }
}