/// Represents a verse in the Bible.
class Verse {
  /// The verse number.
  final int num;
  
  /// The chapter number this verse belongs to.
  final int chapterNum;
  
  /// The text content of the verse.
  final String text;
  
  /// The book ID this verse belongs to.
  final String bookId;

  /// The list of Strong's entries associated with the verse.
  final List<Map<String, dynamic>> strongsEntries;

  /// The list of footnotes associated with the verse.
  final List<Map<String, dynamic>> footnotes;

  /// Creates a new verse.
  Verse({
    required this.num,
    required this.chapterNum,
    required this.text,
    required this.bookId,
    this.strongsEntries = const [],
    this.footnotes = const [],
  });

  /// Creates a verse from a map, typically from database results.
  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      num: map['verse_num'] as int,
      chapterNum: map['chapter_num'] as int,
      text: map['text'] as String,
      bookId: map['book_id'] as String,
      strongsEntries: (map['strongs_entries'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      footnotes: (map['footnotes'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );
  }
  
  /// Converts this verse to a map representation, typically for database storage.
  Map<String, dynamic> toMap() {
    return {
      'verse_num': num,
      'chapter_num': chapterNum,
      'text': text,
      'book_id': bookId,
      'strongs_entries': strongsEntries,
      'footnotes': footnotes,
    };
  }
  
  @override
  String toString() => '$bookId $chapterNum:$num - $text';
}
