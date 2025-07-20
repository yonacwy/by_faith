import 'package:flutter/material.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';

class StudyTopicsVerseProvider extends ChangeNotifier {
  final Store store;

  StudyTopicsVerseProvider(this.store);

  static const Map<String, String> bookNameMap = {
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

  static String formatVerseReference(String verseReference) {
    final singleVerse = verseReference.split('-')[0].trim();
    final parts = singleVerse.split('.');
    if (parts.length != 3) {
      return verseReference; // Return original if invalid format
    }
    final bookId = parts[0];
    final chapter = parts[1];
    final verse = parts[2];
    final bookName = bookNameMap[bookId] ?? bookId;
    // For books starting with a number (e.g., 1 Timothy), adjust spacing
    final formattedBookName = bookName.startsWith(RegExp(r'\d'))
        ? bookName.replaceFirst(RegExp(r'(\d)\s*'), '\1 ')
        : bookName;
    return '$formattedBookName $chapter:$verse';
  }

  String? getVerseText(String verseReference) {
    try {
      final singleVerse = verseReference.split('-')[0].trim();
      final parts = singleVerse.split('.');
      if (parts.length != 3) {
        print('Invalid verse reference format: $verseReference');
        return null;
      }

      final bookId = parts[0];
      final storageId = _bookIdToStorageIdMap[bookId] ?? bookId.toUpperCase();
      final bookName = bookNameMap[bookId] ?? bookId;
      final chapterNumber = int.tryParse(parts[1]);
      final verseNumber = int.tryParse(parts[2]);

      if (chapterNumber == null || verseNumber == null) {
        print('Invalid chapter or verse number: $chapterNumber, $verseNumber');
        return null;
      }

      final bookBox = store.box<Book>();
      final chapterBox = store.box<Chapter>();
      final verseBox = store.box<Verse>();

      // Debug: Print all book names in the database
      final allBooks = bookBox.getAll();
      print('Available books: ${allBooks.map((b) => b.name).toList()}');

      final book = bookBox.query(Book_.name.equals(bookName)).build().findFirst();
      if (book == null) {
        print('Book not found: $bookName (from $bookId, storage ID: $storageId)');
        return null;
      }

      final chapter = chapterBox
          .query(Chapter_.book.equals(book.id) & Chapter_.chapterNumber.equals(chapterNumber))
          .build()
          .findFirst();
      if (chapter == null) {
        print('Chapter not found: $bookName $chapterNumber');
        return null;
      }

      final verse = verseBox
          .query(Verse_.chapter.equals(chapter.id) & Verse_.verseNumber.equals(verseNumber))
          .build()
          .findFirst();
      if (verse == null) {
        print('Verse not found: $bookName $chapterNumber:$verseNumber');
        return null;
      }

      return verse.text;
    } catch (e) {
      print('Error fetching verse text for $verseReference: $e');
      return null;
    }
  }
}