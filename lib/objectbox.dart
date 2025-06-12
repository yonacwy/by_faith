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

late Store store;
late Box<GoContact> goContactsBox;
late Box<GoChurch> goChurchesBox;
late Box<GoMinistry> goMinistriesBox;
late Box<GoMapInfo> goMapInfoBox;
late Box<UserPreferences> userPreferencesBox;

Future<void> setupObjectBox() async {
  try {
    // Get the app's cache directory
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

    // Initialize FMTC backend
    await FMTCObjectBoxBackend().initialise();

    // Initialize FMTCStore
    await fmtc.FMTCStore('tile_cache').manage.create();
  } catch (e) {
    print('ObjectBox initialization error: $e');
    rethrow;
  }
}