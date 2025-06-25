import 'package:flutter/material.dart';
import 'package:by_faith/features/go/screens/go_select_map_area_screen.dart';
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/objectbox.g.dart'; // For GoMapInfo_
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class GoOfflineMapsScreen extends StatefulWidget {
  final String? currentMapName;
  final Function(GoMapInfo) onLoadMap;
  final Box<GoMapInfo> goMapInfoBox; // Changed from mapBox
  final Function(String, double, double, double, double, int, ScaffoldMessengerState) onDownloadMap;
  final Function(String, String, bool) onUploadMap;

  const GoOfflineMapsScreen({
    super.key,
    required this.currentMapName,
    required this.onLoadMap,
    required this.goMapInfoBox, // Changed from mapBox
    required this.onDownloadMap,
    required this.onUploadMap,
  });

  @override
  State<GoOfflineMapsScreen> createState() => _GoOfflineMapsScreenState();
}

class _GoOfflineMapsScreenState extends State<GoOfflineMapsScreen> {
  late Box<UserPreferences> userPreferencesBox; // Changed to ObjectBox Box

  @override
  void initState() {
    super.initState();
    userPreferencesBox = store.box<UserPreferences>(); // Initialize ObjectBox user preferences box

    // Check if 'World' map exists, if not, add it
    final worldMap = widget.goMapInfoBox.query(GoMapInfo_.name.equals('World')).build().findFirst();
    if (worldMap == null) {
      final defaultWorldMap = GoMapInfo(
        id: 0, // Set ID to 0 for ObjectBox to assign a new unique ID
        name: 'World',
        filePath: 'cached', // Set a non-empty filePath for offline map logic
        downloadUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Set a default download URL
        isTemporary: false,
        latitude: 0.0, // Default center of the world
        longitude: 0.0,
        zoomLevel: 2, // A reasonable default zoom level for the world
      );
      widget.goMapInfoBox.put(defaultWorldMap);
    }

    if (mounted) setState(() {});
  }

  void _showMapSelection() {
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final mapCount = widget.goMapInfoBox.getAll().length;
    if (mapCount >= 5) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            t.go_offline_maps_screen.max_maps_warning,
            style: TextStyle(
              fontFamily: fontProvider.fontFamily,
              fontSize: fontProvider.fontSize,
            ),
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoSelectMapAreaScreen(
          onDownloadMap: (name, southWestLat, southWestLng, northEastLat, northEastLng, zoomLevel, scaffoldMessenger) async { // Made async
            try {
              final newStore = fmtc.FMTCStore(name);
              await newStore.manage.create(); // Explicitly create the store
              widget.onDownloadMap(name, southWestLat, southWestLng, northEastLat, northEastLng, zoomLevel, scaffoldMessenger);
            } catch (e) {
              print('Error creating map store: $e');
              // Optionally show an error message to the user
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteMap(String mapName) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
    try {
      final mapInfo = widget.goMapInfoBox.query(GoMapInfo_.name.equals(mapName)).build().findFirst();
      if (mapInfo != null) {
        await fmtc.FMTCStore(mapInfo.name).manage.delete();
        widget.goMapInfoBox.remove(mapInfo.id); // Use remove for deletion by ID
      }
      if (mounted) setState(() {});
    } catch (error) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              t.go_offline_maps_screen.failed_to_delete_map.replaceAll('{mapName}', mapName).replaceAll('{error}', error.toString()),
              style: TextStyle(
                fontFamily: fontProvider.fontFamily,
                fontSize: fontProvider.fontSize,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _renameMap(GoMapInfo mapInfo) async {
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
    TextEditingController controller = TextEditingController(text: mapInfo.name);
    String? newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_offline_maps_screen.rename_map,
          style: TextStyle(
            fontFamily: fontProvider.fontFamily,
            fontSize: fontProvider.fontSize,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: t.go_offline_maps_screen.enter_new_map_name,
            hintStyle: TextStyle(
              fontFamily: fontProvider.fontFamily,
              fontSize: fontProvider.fontSize,
            ),
          ),
          style: TextStyle(
            fontFamily: fontProvider.fontFamily,
            fontSize: fontProvider.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_offline_maps_screen.cancel,
              style: TextStyle(
                fontFamily: fontProvider.fontFamily,
                fontSize: fontProvider.fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(
              t.go_offline_maps_screen.save,
              style: TextStyle(
                fontFamily: fontProvider.fontFamily,
                fontSize: fontProvider.fontSize,
              ),
            ),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != mapInfo.name) {
      try {
        final oldName = mapInfo.name;
        mapInfo.name = newName; // Update the name directly on the object
        widget.goMapInfoBox.put(mapInfo); // Put the updated object back
        // Update store name in FMTC
        final store = fmtc.FMTCStore(oldName); // Use old name to reference the store
        await store.manage.rename(newName);
        if (mounted) setState(() {});
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.go_offline_maps_screen.failed_to_rename_map.replaceAll('{error}', error.toString()),
                style: TextStyle(
                  fontFamily: fontProvider.fontFamily,
                  fontSize: fontProvider.fontSize,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _updateMap(GoMapInfo mapInfo) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
    // Re-download the map with the same parameters
    try {
      await widget.onDownloadMap(
        mapInfo.name,
        // Handle nullable latitude and longitude
        (mapInfo.latitude ?? 0.0) - 0.05, // Assuming square overlay size
        (mapInfo.longitude ?? 0.0) - 0.05,
        (mapInfo.latitude ?? 0.0) + 0.05,
        (mapInfo.longitude ?? 0.0) + 0.05,
        // Handle nullable zoomLevel
        mapInfo.zoomLevel ?? 2, // Provide a default zoom level if null
        scaffoldMessenger,
      );
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              t.go_offline_maps_screen.map_updated_successfully.replaceAll('{mapName}', mapInfo.name),
              style: TextStyle(
                fontFamily: fontProvider.fontFamily,
                fontSize: fontProvider.fontSize,
              ),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              t.go_offline_maps_screen.failed_to_update_map.replaceAll('{error}', error.toString()),
              style: TextStyle(
                fontFamily: fontProvider.fontFamily,
                fontSize: fontProvider.fontSize,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_offline_maps_screen.title,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: Text(
                t.go_offline_maps_screen.select_your_own_map,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              onTap: _showMapSelection,
            ),
            ExpansionTile(
              title: Text(
                t.go_offline_maps_screen.downloaded_maps,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              initiallyExpanded: true,
              children: [
                StreamBuilder<List<GoMapInfo>>(
                  stream: widget.goMapInfoBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          t.go_offline_maps_screen.no_maps_downloaded,
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                      );
                    }
                    final maps = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: maps.length,
                      itemBuilder: (context, index) {
                        final mapInfo = maps[index];
                        return ListTile(
                          title: Text(
                            mapInfo.name,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'view') {
                                UserPreferences userPreferences = userPreferencesBox.get(1) ?? UserPreferences();
                                userPreferences.currentMap = mapInfo.name;
                                userPreferencesBox.put(userPreferences);
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                widget.onLoadMap(mapInfo);
                              } else if (value == 'update') {
                                await _updateMap(mapInfo);
                              } else if (value == 'rename') {
                                await _renameMap(mapInfo);
                              } else if (value == 'delete') {
                                await _deleteMap(mapInfo.name);
                              }
                            },
                            itemBuilder: (context) {
                              final fontProvider = Provider.of<FontProvider>(context, listen: false);
                              return [
                                PopupMenuItem(
                                  value: 'view',
                                  child: Text(
                                    t.go_offline_maps_screen.view,
                                    style: TextStyle(
                                      fontFamily: fontProvider.fontFamily,
                                      fontSize: fontProvider.fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'update',
                                  child: Text(
                                    t.go_offline_maps_screen.update,
                                    style: TextStyle(
                                      fontFamily: fontProvider.fontFamily,
                                      fontSize: fontProvider.fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'rename',
                                  child: Text(
                                    t.go_offline_maps_screen.rename,
                                    style: TextStyle(
                                      fontFamily: fontProvider.fontFamily,
                                      fontSize: fontProvider.fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    t.go_offline_maps_screen.delete,
                                    style: TextStyle(
                                      fontFamily: fontProvider.fontFamily,
                                      fontSize: fontProvider.fontSize,
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                          onTap: () {
                            UserPreferences userPreferences = userPreferencesBox.get(1) ?? UserPreferences();
                            userPreferences.currentMap = mapInfo.name;
                            userPreferencesBox.put(userPreferences);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                            widget.onLoadMap(mapInfo);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}