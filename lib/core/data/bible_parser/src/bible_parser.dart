import 'dart:async';
import 'dart:io';

import 'parsers/parsers.dart';
import 'errors.dart';
import 'book.dart';
import 'verse.dart';

/// Main class for parsing Bible files in various formats.
class BibleParser {
  /// The source of the Bible data, can be a File, String, or other data source.
  final dynamic _source;

  /// The format of the Bible data.
  final String format;

  /// Private constructor for internal use.
  BibleParser._(this._source, this.format);

  /// Creates a new Bible parser with the given source.
  ///
  /// If [format] is not provided, it will be detected automatically.
  static Future<BibleParser> create(dynamic source, {String? format}) async {
    final detectedFormat = format ?? await _detectFormat(source);
    return BibleParser._(source, detectedFormat);
  }

  /// Creates a new Bible parser from a string containing XML content.
  ///
  /// If [format] is not provided, it will be detected automatically.
  static Future<BibleParser> fromString(String xmlContent, {String? format}) async {
    return await create(xmlContent, format: format);
  }

  /// Gets a stream of all books in the Bible.
  Stream<Book> get books async* {
    final parser = _getParser();
    yield* parser.parseBooks();
  }

  /// Gets a stream of all verses in the Bible.
  Stream<Verse> get verses async* {
    final parser = _getParser();
    yield* parser.parseVerses();
  }

  /// Gets the appropriate parser for the detected format.
  BaseParser _getParser() {
    try {
      switch (format.toUpperCase()) {
        case 'USFX':
          return UsfxParser(_source);
        case 'OSIS':
          return OsisParser(_source);
        case 'ZEFANIA':
          return ZefaniaParser(_source);
        default:
          throw ParserUnavailableError('Parser for $format could not be loaded.');
      }
    } catch (e, stackTrace) {
      throw BibleParserException('Failed to get parser for format $format: $e, $stackTrace');
    }
  }

  /// Detects the format of the Bible data asynchronously.
  static Future<String> _detectFormat(dynamic source) async {
    String sampleContent = '';

    try {
      if (source is File) {
        // Read only a small portion of the file for format detection
        final file = source;
        final raf = await file.open(mode: FileMode.read);
        final bytes = await raf.read(1024 * 10); // Read first 10KB
        await raf.close();
        sampleContent = String.fromCharCodes(bytes);
      } else if (source is String) {
        // For web compatibility, assume String is always content
        sampleContent = source;
      } else {
        throw FormatDetectionError('Unsupported source type: ${source.runtimeType}');
      }

      // Check a small sample of the content for format detection
      final sample = sampleContent.length > 1000 ? sampleContent.substring(0, 1000) : sampleContent;

      if (sample.contains('<usfx') || sample.contains('<USFX')) return 'USFX';
      if (sample.contains('<osis') || sample.contains('<osisText')) return 'OSIS';
      if (sample.contains('<xmlbible') || sample.contains('<XMLBIBLE')) return 'ZEFANIA';

      throw FormatDetectionError('Could not detect Bible format');
    } catch (e) {
      // Default to OSIS format if detection fails
      return 'OSIS';
    }
  }
}
