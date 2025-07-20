import 'package:flutter/material.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';

class StudyTopicsVerseProvider extends ChangeNotifier {
  final Store store;

  StudyTopicsVerseProvider(this.store);

  static const Map<String, String> bookNameMap = {
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

  String? getVerseText(String verseReference) {
    try {
      final singleVerse = verseReference.split('-')[0].trim();
      final parts = singleVerse.split('.');
      if (parts.length != 3) {
        print('Invalid verse reference format: $verseReference');
        return null;
      }

      final bookName = bookNameMap[parts[0]] ?? parts[0];
      final chapterNumber = int.tryParse(parts[1]);
      final verseNumber = int.tryParse(parts[2]);

      if (chapterNumber == null || verseNumber == null) {
        print('Invalid chapter or verse number: $chapterNumber, $verseNumber');
        return null;
      }

      final bookBox = store.box<Book>();
      final chapterBox = store.box<Chapter>();
      final verseBox = store.box<Verse>();

      final book = bookBox.query(Book_.name.equals(bookName)).build().findFirst();
      if (book == null) {
        print('Book not found: $bookName');
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