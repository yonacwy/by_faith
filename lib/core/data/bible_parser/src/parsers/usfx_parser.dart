import 'dart:async';
import 'package:xml/xml_events.dart';
import 'package:flutter/foundation.dart';
import 'base_parser.dart';
import '../errors.dart';
import '../book.dart';
import '../chapter.dart';
import '../verse.dart';

/// Parser for the USFX Bible format.
class UsfxParser extends BaseParser {
  /// USFX book ID to canonical book name mapping.
  static const Map<String, String> _bookNames = {
    'GEN': 'Genesis',
    'EXO': 'Exodus',
    'LEV': 'Leviticus',
    'NUM': 'Numbers',
    'DEU': 'Deuteronomy',
    'JOS': 'Joshua',
    'JDG': 'Judges',
    'RUT': 'Ruth',
    '1SA': '1 Samuel',
    '2SA': '2 Samuel',
    '1KI': '1 Kings',
    '2KI': '2 Kings',
    '1CH': '1 Chronicles',
    '2CH': '2 Chronicles',
    'EZR': 'Ezra',
    'NEH': 'Nehemiah',
    'EST': 'Esther',
    'JOB': 'Job',
    'PSA': 'Psalms',
    'PRO': 'Proverbs',
    'ECC': 'Ecclesiastes',
    'SNG': 'Song of Solomon',
    'ISA': 'Isaiah',
    'JER': 'Jeremiah',
    'LAM': 'Lamentations',
    'EZK': 'Ezekiel',
    'DAN': 'Daniel',
    'HOS': 'Hosea',
    'JOL': 'Joel',
    'AMO': 'Amos',
    'OBA': 'Obadiah',
    'JON': 'Jonah',
    'MIC': 'Micah',
    'NAM': 'Nahum',
    'HAB': 'Habakkuk',
    'ZEP': 'Zephaniah',
    'HAG': 'Haggai',
    'ZEC': 'Zechariah',
    'MAL': 'Malachi',
    'MAT': 'Matthew',
    'MRK': 'Mark',
    'LUK': 'Luke',
    'JHN': 'John',
    'ACT': 'Acts',
    'ROM': 'Romans',
    '1CO': '1 Corinthians',
    '2CO': '2 Corinthians',
    'GAL': 'Galatians',
    'EPH': 'Ephesians',
    'PHP': 'Philippians',
    'COL': 'Colossians',
    '1TH': '1 Thessalonians',
    '2TH': '2 Thessalonians',
    '1TI': '1 Timothy',
    '2TI': '2 Timothy',
    'TIT': 'Titus',
    'PHM': 'Philemon',
    'HEB': 'Hebrews',
    'JAS': 'James',
    '1PE': '1 Peter',
    '2PE': '2 Peter',
    '1JN': '1 John',
    '2JN': '2 John',
    '3JN': '3 John',
    'JUD': 'Jude',
    'REV': 'Revelation',
  };

  /// Creates a new USFX parser.
  UsfxParser(super.source);

  @override
  bool checkFormat(String content) {
    return content.contains('<usfx') || content.contains('<USFX');
  }

  @override
  Stream<Book> parseBooks() async* {
    final content = await getContent();

    // Current parsing state
    Book? currentBook;
    Chapter? currentChapter;
    Verse? currentVerse;
    List<Map<String, dynamic>> currentStrongsEntries = [];
    StringBuffer verseTextBuffer = StringBuffer();

    try {
      await for (final event in parseEvents(content)) {
        if (event is XmlStartElementEvent) {
          if (event.name == 'book') {
            String bookId = '';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                bookId = attr.value.toUpperCase();
                break;
              }
            }
            if (bookId.isEmpty) continue;

            final bookNum = _getBookNum(bookId);
            final bookName = _getBookName(bookId);

            currentBook = Book(
              id: bookId,
              num: bookNum,
              title: bookName,
            );
          } else if (event.name == 'c' && currentBook != null) {
            String chapterNumStr = '1';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                chapterNumStr = attr.value;
                break;
              }
            }
            final chapterNum = int.tryParse(chapterNumStr) ?? 1;

            // Finalize previous verse if exists before starting a new chapter
            if (currentVerse != null && currentChapter != null) {
              currentVerse = Verse(
                num: currentVerse.num,
                chapterNum: currentVerse.chapterNum,
                text: verseTextBuffer.toString().trim(),
                bookId: currentVerse.bookId,
                strongsEntries: List.from(currentStrongsEntries),
              );
              currentChapter.addVerse(currentVerse);
              currentVerse = null;
              currentStrongsEntries = [];
              verseTextBuffer.clear();
            }

            // If currentChapter exists and is different from the new chapter, add it to the book
            if (currentChapter != null && currentChapter.num != chapterNum) {
              currentBook.addChapter(currentChapter);
            }
            
            // Start new chapter
            currentChapter = Chapter(
              num: chapterNum,
              bookId: currentBook.id,
            );
          } else if (event.name == 'v' && currentBook != null && currentChapter != null) {
            String verseNumStr = '1';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                verseNumStr = attr.value;
                break;
              }
            }
            final verseNum = int.tryParse(verseNumStr) ?? 1;

            // Finalize previous verse if exists
            if (currentVerse != null) {
              currentVerse = Verse(
                num: currentVerse.num,
                chapterNum: currentVerse.chapterNum,
                text: verseTextBuffer.toString().trim(),
                bookId: currentVerse.bookId,
                strongsEntries: List.from(currentStrongsEntries),
              );
              currentChapter.addVerse(currentVerse);
            }

            // Start new verse
            currentVerse = Verse(
              num: verseNum,
              chapterNum: currentChapter.num,
              text: '',
              bookId: currentBook.id,
              strongsEntries: [],
            );
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 'w' &&
              currentBook != null &&
              currentChapter != null &&
              currentVerse != null) {
            String? strongsNumber;
            for (var attr in event.attributes) {
              if (attr.name == 's' && (attr.value.startsWith('H') || attr.value.startsWith('G'))) {
                strongsNumber = attr.value;
                break;
              }
            }
            if (strongsNumber != null) {
              currentStrongsEntries.add({
                'strongsNumber': strongsNumber,
                'word': '',
                'position': verseTextBuffer.toString().split(' ').where((w) => w.isNotEmpty).length,
              });
            }
          } else if (event.name == 'add' && currentVerse != null) {
            // Handle <add> elements by including them in the verse text
          }
        } else if (event is XmlEndElementEvent) {
          if (event.name == 'book' && currentBook != null) {
            if (currentChapter != null) {
              // Finalize last verse in chapter
              if (currentVerse != null) {
                currentVerse = Verse(
                  num: currentVerse.num,
                  chapterNum: currentVerse.chapterNum,
                  text: verseTextBuffer.toString().trim(),
                  bookId: currentVerse.bookId,
                  strongsEntries: List.from(currentStrongsEntries),
                );
                currentChapter.addVerse(currentVerse);
                currentVerse = null;
                currentStrongsEntries = [];
                verseTextBuffer.clear();
              }
              currentBook.addChapter(currentChapter);
            }
            yield currentBook;
            currentBook = null;
            currentChapter = null;
          } else if (event.name == 'c' && currentBook != null && currentChapter != null) {
            if (currentVerse != null) {
              currentVerse = Verse(
                num: currentVerse.num,
                chapterNum: currentVerse.chapterNum,
                text: verseTextBuffer.toString().trim(),
                bookId: currentVerse.bookId,
                strongsEntries: List.from(currentStrongsEntries),
              );
              currentChapter.addVerse(currentVerse);
              currentVerse = null;
              currentStrongsEntries = [];
              verseTextBuffer.clear();
            }
            currentChapter = null;
          } else if (event.name == 'v' && currentVerse != null) {
            currentVerse = Verse(
              num: currentVerse.num,
              chapterNum: currentVerse.chapterNum,
              text: verseTextBuffer.toString().trim(),
              bookId: currentVerse.bookId,
              strongsEntries: List.from(currentStrongsEntries),
            );
            currentChapter!.addVerse(currentVerse);
            currentVerse = null;
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 've' && currentVerse != null) {
            currentVerse = Verse(
              num: currentVerse.num,
              chapterNum: currentVerse.chapterNum,
              text: verseTextBuffer.toString().trim(),
              bookId: currentVerse.bookId,
              strongsEntries: List.from(currentStrongsEntries),
            );
            currentChapter!.addVerse(currentVerse);
            currentVerse = null;
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 'w' && currentVerse != null) {
            // No additional action needed at the end of <w> element
          } else if (event.name == 'add' && currentVerse != null) {
            // No additional action needed at the end of <add> element
          }
        } else if (event is XmlTextEvent && currentVerse != null) {
          final text = event.value.trim();
          if (text.isNotEmpty) {
            if (currentStrongsEntries.isNotEmpty && currentStrongsEntries.last['word']!.isEmpty) {
              currentStrongsEntries.last['word'] = text;
            }
            verseTextBuffer.write(' $text');
          }
        }
      }

      // Finalize any remaining verse and chapter
      if (currentVerse != null && currentChapter != null) {
        currentVerse = Verse(
          num: currentVerse.num,
          chapterNum: currentVerse.chapterNum,
          text: verseTextBuffer.toString().trim(),
          bookId: currentVerse.bookId,
          strongsEntries: List.from(currentStrongsEntries),
        );
        currentChapter.addVerse(currentVerse);
      }
      if (currentChapter != null && currentBook != null) {
        // Only add chapter if it's not already added
        if (currentBook.chapters.isEmpty || currentBook.chapters.last.num != currentChapter.num) {
          currentBook.addChapter(currentChapter);
        }
      }
      if (currentBook != null) {
        yield currentBook;
      }
    } catch (e, stackTrace) {
      throw BibleParserException('Error parsing books: $e\n$stackTrace');
    }
  }

  @override
  Stream<Verse> parseVerses() async* {
    final content = await getContent();

    // Current parsing state
    String? currentBookId;
    int? currentChapterNum;
    Verse? currentVerse;
    List<Map<String, dynamic>> currentStrongsEntries = [];
    StringBuffer verseTextBuffer = StringBuffer();

    try {
      await for (final event in parseEvents(content)) {
        if (event is XmlStartElementEvent) {
          if (event.name == 'book') {
            String bookId = '';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                bookId = attr.value.toUpperCase();
                break;
              }
            }
            if (bookId.isEmpty) continue;
            currentBookId = bookId;
          } else if (event.name == 'c' && currentBookId != null) {
            String chapterNumStr = '1';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                chapterNumStr = attr.value;
                break;
              }
            }
            currentChapterNum = int.tryParse(chapterNumStr) ?? 1;
          } else if (event.name == 'v' && currentBookId != null && currentChapterNum != null) {
            String verseNumStr = '1';
            for (var attr in event.attributes) {
              if (attr.name == 'id') {
                verseNumStr = attr.value;
                break;
              }
            }
            final verseNum = int.tryParse(verseNumStr) ?? 1;

            // Finalize previous verse if exists
            if (currentVerse != null) {
              currentVerse = Verse(
                num: currentVerse.num,
                chapterNum: currentVerse.chapterNum,
                text: verseTextBuffer.toString().trim(),
                bookId: currentVerse.bookId,
                strongsEntries: List.from(currentStrongsEntries),
              );
              yield currentVerse;
            }

            // Start new verse
            currentVerse = Verse(
              num: verseNum,
              chapterNum: currentChapterNum,
              text: '',
              bookId: currentBookId,
              strongsEntries: [],
            );
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 'w' &&
              currentBookId != null &&
              currentChapterNum != null &&
              currentVerse != null) {
            String? strongsNumber;
            for (var attr in event.attributes) {
              if (attr.name == 's' && (attr.value.startsWith('H') || attr.value.startsWith('G'))) {
                strongsNumber = attr.value;
                break;
              }
            }
            if (strongsNumber != null) {
              currentStrongsEntries.add({
                'strongsNumber': strongsNumber,
                'word': '',
                'position': verseTextBuffer.toString().split(' ').where((w) => w.isNotEmpty).length,
              });
            }
          } else if (event.name == 'add' && currentVerse != null) {
            // Handle <add> elements
          }
        } else if (event is XmlEndElementEvent) {
          if (event.name == 'v' && currentVerse != null) {
            currentVerse = Verse(
              num: currentVerse.num,
              chapterNum: currentVerse.chapterNum,
              text: verseTextBuffer.toString().trim(),
              bookId: currentVerse.bookId,
              strongsEntries: List.from(currentStrongsEntries),
            );
            yield currentVerse;
            currentVerse = null;
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 've' && currentVerse != null) {
            currentVerse = Verse(
              num: currentVerse.num,
              chapterNum: currentVerse.chapterNum,
              text: verseTextBuffer.toString().trim(),
              bookId: currentVerse.bookId,
              strongsEntries: List.from(currentStrongsEntries),
            );
            yield currentVerse;
            currentVerse = null;
            currentStrongsEntries = [];
            verseTextBuffer.clear();
          } else if (event.name == 'w' && currentVerse != null) {
            // No additional action needed at the end of <w> element
          } else if (event.name == 'add' && currentVerse != null) {
            // No additional action needed at the end of <add> element
          }
        } else if (event is XmlTextEvent && currentVerse != null) {
          final text = event.value.trim();
          if (text.isNotEmpty) {
            if (currentStrongsEntries.isNotEmpty && currentStrongsEntries.last['word']!.isEmpty) {
              currentStrongsEntries.last['word'] = text;
            }
            verseTextBuffer.write(' $text');
          }
        }
      }

      // Finalize any remaining verse
      if (currentVerse != null) {
        currentVerse = Verse(
          num: currentVerse.num,
          chapterNum: currentVerse.chapterNum,
          text: verseTextBuffer.toString().trim(),
          bookId: currentVerse.bookId,
          strongsEntries: List.from(currentStrongsEntries),
        );
        yield currentVerse;
      }
    } catch (e, stackTrace) {
      throw BibleParserException('Error parsing verses: $e\n$stackTrace');
    }
  }

  /// Gets the book number based on its ID.
  int _getBookNum(String bookId) {
    final upperBookId = bookId.toUpperCase();
    final keys = _bookNames.keys.toList();
    final index = keys.indexOf(upperBookId);
    return index >= 0 ? index + 1 : 0;
  }

  /// Gets the book name based on its ID.
  String _getBookName(String bookId) {
    return _bookNames[bookId.toUpperCase()] ?? 'Unknown';
  }

  /// Parses XML events from the content string.
  Stream<XmlEvent> parseEvents(String content) {
    try {
      final events = XmlEventDecoder().convert(content);
      return Stream.fromIterable(events);
    } catch (e) {
      throw ParseError('Failed to parse XML content: $e');
    }
  }
}