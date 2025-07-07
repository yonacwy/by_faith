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
}

@Entity()
class Verse {
  int id;
  int verseNumber;
  String text;
  final chapter = ToOne<Chapter>();

  Verse({this.id = 0, required this.verseNumber, required this.text});
}