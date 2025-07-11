import 'package:objectbox/objectbox.dart';

@Entity()
class BibleVersion {
  int id;
  String name;
  String languageCode;

  @Backlink()
  final books = ToMany<Book>();

  BibleVersion({this.id = 0, required this.name, required this.languageCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleVersion &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@Entity()
class Book {
  int id;
  String name;
  String bookId; // e.g., GEN, EXO
  final bibleVersion = ToOne<BibleVersion>();

  @Backlink()
  final chapters = ToMany<Chapter>();

  Book({this.id = 0, required this.name, required this.bookId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@Entity()
class Chapter {
  int id;
  int chapterNumber;
  final book = ToOne<Book>();

  @Backlink()
  final verses = ToMany<Verse>();

  Chapter({this.id = 0, required this.chapterNumber});

  void addVerse(Verse verse) {
    verses.add(verse);
    verse.chapter.target = this;
  }
}

@Entity()
class Verse {
  int id;
  int verseNumber;
  String text;
  final chapter = ToOne<Chapter>();

  @Backlink()
  final strongsEntries = ToMany<StrongsEntry>();

  @Backlink()
  final footnotes = ToMany<Footnote>();

  Verse({this.id = 0, required this.verseNumber, required this.text});
}

@Entity()
class Footnote {
  int id;
  String caller;
  String text;
  final verse = ToOne<Verse>();

  Footnote({this.id = 0, required this.caller, required this.text});
}

@Entity()
class StrongsEntry {
  int id;
  String strongsNumber; // e.g., H123, G123
  String word; // The word associated with the Strong's number
  int position; // Position of the word in the verse text (for rendering)
  final verse = ToOne<Verse>();

  StrongsEntry({
    this.id = 0,
    required this.strongsNumber,
    required this.word,
    required this.position,
  });
}