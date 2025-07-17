import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/features/study/models/study_references_model.dart'; // Add this import
import 'package:by_faith/features/home/models/home_model.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' show FMTCObjectBoxBackend;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Global ObjectBox store instance.
Store? _store;

Box<GoContact>? _goContactsBox;
Box<GoChurch>? _goChurchesBox;
Box<GoMinistry>? _goMinistriesBox;
Box<GoMapInfo>? _goMapInfoBox;
Box<UserPreferences>? _userPreferencesBox;
Box<GoContactNote>? _goContactNotesBox;
Box<GoChurchNote>? _goChurchNotesBox;
Box<GoMinistryNote>? _goMinistryNotesBox;
Box<BibleVersion>? _bibleVersionBox;
Box<Book>? _bookBox;
Box<Chapter>? _chapterBox;
Box<Verse>? _verseBox;
Box<Footnote>? _footnoteBox;
Box<StrongsEntry>? _strongsEntryBox;
Box<BiblesDownload>? _biblesdownloadBox;
Box<CreatedTopicsEn>? _studyCreatedTopicsEnBox;
Box<GeneratedTopicsEn>? _studyGeneratedTopicsEnBox;
Box<CrossReference>? _crossReferenceBox;

Store get store => _store!;
Box<GoContact> get goContactsBox => _goContactsBox!;
Box<GoChurch> get goChurchesBox => _goChurchesBox!;
Box<GoMinistry> get goMinistriesBox => _goMinistriesBox!;
Box<GoMapInfo> get goMapInfoBox => _goMapInfoBox!;
Box<UserPreferences> get userPreferencesBox => _userPreferencesBox!;
Box<GoContactNote> get goContactNotesBox => _goContactNotesBox!;
Box<GoChurchNote> get goChurchNotesBox => _goChurchNotesBox!;
Box<GoMinistryNote> get goMinistryNotesBox => _goMinistryNotesBox!;
Box<BibleVersion> get bibleVersionBox => _bibleVersionBox!;
Box<Book> get bookBox => _bookBox!;
Box<Chapter> get chapterBox => _chapterBox!;
Box<Verse> get verseBox => _verseBox!;
Box<Footnote> get footnoteBox => _footnoteBox!;
Box<StrongsEntry> get strongsEntryBox => _strongsEntryBox!;
Box<BiblesDownload> get biblesdownloadBox => _biblesdownloadBox!;
Box<CreatedTopicsEn> get studyCreatedTopicsEnBox => _studyCreatedTopicsEnBox!;
Box<GeneratedTopicsEn> get studyGeneratedTopicsEnBox => _studyGeneratedTopicsEnBox!;
Box<CrossReference> get crossReferenceBox => _crossReferenceBox!;

/// Initializes the ObjectBox store and FMTC backend.
/// Returns the initialized [Store] if successful, `null` otherwise.
Future<Store?> setupObjectBox() async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    final objectBoxDir = path.join(appDocDir.path, 'objectbox');
    await Directory(objectBoxDir).create(recursive: true);

    _store = await openStore(directory: objectBoxDir);
    _goContactsBox = _store!.box<GoContact>();
    _goChurchesBox = _store!.box<GoChurch>();
    _goMinistriesBox = _store!.box<GoMinistry>();
    _goMapInfoBox = _store!.box<GoMapInfo>();
    _userPreferencesBox = _store!.box<UserPreferences>();
    _goContactNotesBox = _store!.box<GoContactNote>();
    _goChurchNotesBox = _store!.box<GoChurchNote>();
    _goMinistryNotesBox = _store!.box<GoMinistryNote>();
    _bibleVersionBox = _store!.box<BibleVersion>();
    _bookBox = _store!.box<Book>();
    _chapterBox = _store!.box<Chapter>();
    _verseBox = _store!.box<Verse>();
    _footnoteBox = _store!.box<Footnote>();
    _strongsEntryBox = _store!.box<StrongsEntry>();
    _biblesdownloadBox = _store!.box<BiblesDownload>();
    _studyCreatedTopicsEnBox = _store!.box<CreatedTopicsEn>();
    _studyGeneratedTopicsEnBox = _store!.box<GeneratedTopicsEn>();
    _crossReferenceBox = _store!.box<CrossReference>();

    // Initialize FMTC backend with ObjectBox
    await FMTCObjectBoxBackend().initialise();

    // Create FMTC store for tile caching
    await fmtc.FMTCStore('tile_cache').manage.create();

    // Load data from JSON
    await loadBiblesFromJson();
    await loadTopicsFromJson();
    await loadCrossReferencesFromJson(); // Load cross-references

    return _store;
  } catch (e) {
    print('ObjectBox initialization error: $e');
    return null;
  }
}

/// Loads bibles from JSON asset into ObjectBox.
Future<void> loadBiblesFromJson() async {
  try {
    final String response = await rootBundle.loadString('lib/features/home/assets/data/bibles_download.json');
    final List<dynamic> data = jsonDecode(response);
    final List<BiblesDownload> bibles = data.map((json) => BiblesDownload(
      name: json['title'],
      shortTitle: json['shortTitle'] ?? json['title'],
      url: json['url'],
    )).toList();
    biblesdownloadBox.putMany(bibles);
    print('Loaded ${bibles.length} bibles into ObjectBox.');
  } catch (e) {
    print('Error loading bibles from JSON: $e');
  }
}

/// Loads topics from JSON asset into ObjectBox.
Future<void> loadTopicsFromJson() async {
  try {
    final String response = await rootBundle.loadString('lib/features/study/assets/data/topics_en.i18n.json');
    final Map<String, dynamic> data = jsonDecode(response);
    final List<GeneratedTopicsEn> topics = data.entries.map((entry) {
      final title = entry.key.replaceAll(RegExp(r'\{TOP\d*\}'), '').trim();
      final verses = (entry.value as List<dynamic>).map((item) => item['bible'] as String).toList();
      return GeneratedTopicsEn(title: title, verses: verses);
    }).toList();
    studyGeneratedTopicsEnBox.putMany(topics);
    print('Loaded ${topics.length} topics into ObjectBox.');
  } catch (e) {
    print('Error loading topics from JSON: $e');
  }
}

/// Loads cross-references from JSON asset into ObjectBox.
Future<void> loadCrossReferencesFromJson() async {
  try {
    final String response = await rootBundle.loadString('lib/features/study/assets/data/cross_references.json');
    final Map<String, dynamic> data = jsonDecode(response);
    final List<CrossReference> references = [];
    data.forEach((verse, toVerses) {
      for (var toVerse in toVerses) {
        references.add(CrossReference(
          verse: verse,
          toVerse: toVerse['toVerse'],
        ));
      }
    });
    crossReferenceBox.putMany(references);
    print('Loaded ${references.length} cross-references into ObjectBox.');
  } catch (e) {
    print('Error loading cross-references from JSON: $e');
  }
}

/// Cleans up ObjectBox resources when the app closes.
void closeObjectBox() {
  _store?.close();
}