import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' show FMTCObjectBoxBackend;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

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

    // Initialize FMTC backend with ObjectBox
    await FMTCObjectBoxBackend().initialise();

    // Create FMTC store for tile caching
    await fmtc.FMTCStore('tile_cache').manage.create();

    return true;
  } catch (e) {
    print('ObjectBox initialization error: $e');
    // Optionally notify the user or log to a file
    return false;
  }
}

/// Cleans up ObjectBox resources when the app closes.
/// Call this in the app's dispose method if needed.
void closeObjectBox() {
  store.close();
}