import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_topics_model.dart';
import 'package:by_faith/features/home/models/home_model.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' show FMTCObjectBoxBackend;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Global ObjectBox store instance.
late Store store;

/// Boxes for various entity types.
late Box<GoContact> goContactsBox;
late Box<GoChurch> goChurchesBox;
late Box<GoMinistry> goMinistriesBox;
late Box<GoMapInfo> goMapInfoBox;
late Box<UserPreferences> userPreferencesBox;
late Box<GoContactNote> goContactNotesBox;
late Box<GoChurchNote> goChurchNotesBox;
late Box<GoMinistryNote> goMinistryNotesBox;
late Box<BibleVersion> bibleVersionBox;
late Box<Book> bookBox;
late Box<Chapter> chapterBox;
late Box<Verse> verseBox;
late Box<Footnote> footnoteBox;
late Box<StrongsEntry> strongsEntryBox;
late Box<BiblesDownload> biblesdownloadBox;
late Box<CreatedTopicsEn> studyCreatedTopicsEnBox; // Box for created topics
late Box<GeneratedTopicsEn> studyGeneratedTopicsEnBox; // Box for generated topics

/// Initializes the ObjectBox store and FMTC backend.
/// Returns `true` if successful, `false` otherwise.
Future<bool> setupObjectBox() async {
  try {
    // Get the app's documents directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final objectBoxDir = path.join(appDocDir.path, 'objectbox');
    await Directory(objectBoxDir).create(recursive: true);

    // Initialize ObjectBox store
    store = await openStore(directory: objectBoxDir);
    goContactsBox = store.box<GoContact>();
    goChurchesBox = store.box<GoChurch>();
    goMinistriesBox = store.box<GoMinistry>();
    goMapInfoBox = store.box<GoMapInfo>();
    userPreferencesBox = store.box<UserPreferences>();
    goContactNotesBox = store.box<GoContactNote>();
    goChurchNotesBox = store.box<GoChurchNote>();
    goMinistryNotesBox = store.box<GoMinistryNote>();
    bibleVersionBox = store.box<BibleVersion>();
    bookBox = store.box<Book>();
    chapterBox = store.box<Chapter>();
    verseBox = store.box<Verse>();
    footnoteBox = store.box<Footnote>();
    strongsEntryBox = store.box<StrongsEntry>();
    biblesdownloadBox = store.box<BiblesDownload>();
    studyCreatedTopicsEnBox = store.box<CreatedTopicsEn>();
    studyGeneratedTopicsEnBox = store.box<GeneratedTopicsEn>();

    // Initialize FMTC backend with ObjectBox
    await FMTCObjectBoxBackend().initialise();

    // Create FMTC store for tile caching
    await fmtc.FMTCStore('tile_cache').manage.create();

    // Load bibles and topics from JSON
    await loadBiblesFromJson();
    await loadTopicsFromJson();

    return true;
  } catch (e) {
    print('ObjectBox initialization error: $e');
    return false;
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

/// Cleans up ObjectBox resources when the app closes.
void closeObjectBox() {
  store.close();
}