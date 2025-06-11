import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter_map/flutter_map.dart' as fm;

class GoMapCache {
  static fmtc.FMTCStore? _mapStore;

  static Future<void> initialize() async {
    _mapStore = fmtc.FMTCStore('mapStore');
    await _mapStore!.manage.create(); // Use create() for store creation
  }

  static fm.TileProvider getTileProvider() {
    if (_mapStore == null) {
      throw Exception('GoMapCache not initialized. Call initialize() first.');
    }
    return _mapStore!.getTileProvider();
  }
}