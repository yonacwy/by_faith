import 'package:flutter/material.dart';
import 'package:by_faith/features/go/screens/go_contacts_screen.dart';
import 'package:by_faith/features/go/screens/go_offline_maps_screen.dart';
import 'package:by_faith/features/go/screens/go_select_map_area_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:by_faith/core/data/data_sources/local/go_map_cache.dart';
import 'package:by_faith/features/go/screens/go_add_edit_contact_screen.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart'; // For StreamBuilder
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:objectbox/objectbox.dart'; // For Box
import 'package:by_faith/objectbox.g.dart'; // For GoMapInfo_
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:by_faith/core/models/user_preferences_model.dart'; // Added for UserPreferences
import 'package:objectbox/objectbox.dart'; // Added for Box

class GoTabScreen extends StatefulWidget {
  const GoTabScreen({super.key});

  @override
  State<GoTabScreen> createState() => _GoTabScreenState();
}

class _GoTabScreenState extends State<GoTabScreen> {
  late MapController _mapController;
  late Box<GoMapInfo> _goMapInfoBox; // Changed from _mapBox
  bool _isLoadingMaps = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> _markers = [];
  bool _isAddingMarker = false;
  bool _isDisposed = false;
  String? _currentMapName;
  int _markerUpdateKey = 0;
  String _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  double _currentZoom = 2.0;
  LatLng _currentCenter = const LatLng(39.0, -98.0); // Center on the Americas
  TileProvider? _tileProvider;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initObjectBox().then((_) async { 
      if (_isDisposed) return;
      await _initTileProvider();
      await _restoreLastMap();
      await _setupMarkers();
      if (mounted) {
        setState(() {
          _isLoadingMaps = false;
        });
      }
      goContactsBox.query().watch(triggerImmediately: true).listen((query) {
        _setupMarkers();
      });
    });
  }

  Future<void> _restoreLastMap() async {
    if (_isDisposed || !mounted) return;
    final String? savedMapName = userPreferencesBox.get(1)?.currentMap; // Using ObjectBox for user preferences
    if (savedMapName != null) {
      final mapInfo = _goMapInfoBox.query(GoMapInfo_.name.equals(savedMapName)).build().findFirst(); // Using ObjectBox query
      if (mapInfo != null) {
        await _loadMap(mapInfo);
      } else {
        _currentMapName = 'World';
        _currentCenter = const LatLng(39.0, -98.0); // Center on the Americas
        _currentZoom = 2.0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(_currentCenter, _currentZoom);
        });
      }
    } else {
      _currentMapName = 'World';
      _currentCenter = const LatLng(39.0, -98.0); // Center on the Americas
      _currentZoom = 2.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_currentCenter, _currentZoom);
      });
    }
  }

  Future<void> _initTileProvider({String? storeName}) async {
    try {
      if (storeName != null) {
        final store = fmtc.FMTCStore(storeName);
        await store.manage.create();
        final tileProvider = store.getTileProvider();
        if (mounted) {
          setState(() {
            _tileProvider = tileProvider;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _tileProvider = NetworkTileProvider();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tileProvider = NetworkTileProvider();
        });
      }
    }
  }

  Future<void> _initObjectBox() async { 
    try {
      _goMapInfoBox = store.box<GoMapInfo>(); // Get ObjectBox for GoMapInfo
      GoMapInfo? worldMapInfo = _goMapInfoBox.query(GoMapInfo_.name.equals('World')).build().findFirst(); // Query for World map

      if (worldMapInfo == null) {
        worldMapInfo = GoMapInfo(
          name: 'World',
          filePath: '',
          downloadUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          isTemporary: false,
          latitude: 39.0, // Center on the Americas
          longitude: -98.0,
          zoomLevel: 2,
        );
        _goMapInfoBox.put(worldMapInfo); // Add to ObjectBox
      } else {
        worldMapInfo.latitude = 39.0; // Center on the Americas
        worldMapInfo.longitude = -98.0;
        worldMapInfo.zoomLevel = 2;
        _goMapInfoBox.put(worldMapInfo); // Update in ObjectBox
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMaps = false;
        });
      }
    }
  }

  Future<void> _loadMap(GoMapInfo mapInfo) async {
    if (_isDisposed || !mounted) return;
    try {
      // Handle nullable latitude and longitude
      final newCenter = LatLng(mapInfo.latitude ?? 39.0, mapInfo.longitude ?? -98.0);
      // Handle nullable zoomLevel
      final newZoom = (mapInfo.zoomLevel?.toDouble() ?? 2.0).clamp(2.0, 20.0);

      // Handle nullable filePath
      if (mapInfo.filePath?.isNotEmpty ?? false) {
        final store = fmtc.FMTCStore(mapInfo.name);
        final bool storeReady = await store.manage.ready;
        if (storeReady) {
          await _initTileProvider(storeName: mapInfo.name);
          // Handle nullable downloadUrl
          _tileProviderUrl = mapInfo.downloadUrl ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
        } else {
          await _initTileProvider();
          _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
          _currentMapName = 'World';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Offline map "${mapInfo.name}" not found. Loading online map.')),
          );
        }
      } else {
        await _initTileProvider();
        // Handle nullable downloadUrl
        _tileProviderUrl = mapInfo.downloadUrl?.isNotEmpty ?? false
            ? mapInfo.downloadUrl ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
            : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      }

      if (mounted) {
        setState(() {
          _currentMapName = mapInfo.name;
          _currentCenter = newCenter;
          _currentZoom = newZoom;
          _markerUpdateKey++;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(newCenter, newZoom);
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load map (${mapInfo.name}): $error')),
        );
      }
    }
  }

  Future<bool> _checkNetwork() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (error) {
      return false;
    }
  }

  Future<void> _downloadMap(String mapName, double southWestLat, double southWestLng, double northEastLat, double northEastLng, int zoomLevel) async {
    if (_isDisposed || !mounted) return;

    if (!await _checkNetwork()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection.')),
        );
      }
      return;
    }

    final store = fmtc.FMTCStore(mapName);
    await store.manage.create();

    final completer = Completer<BuildContext>();

    final downloadOperation = store.download.startForeground(
      region: fmtc.RectangleRegion(
        LatLngBounds(
          LatLng(southWestLat, southWestLng),
          LatLng(northEastLat, northEastLng),
        ),
      ).toDownloadable(
        minZoom: zoomLevel,
        maxZoom: zoomLevel,
        options: TileLayer(
          urlTemplate: _tileProviderUrl,
          tileProvider: NetworkTileProvider(),
        ),
      ),
    );

    final broadcastDownloadProgress = downloadOperation.downloadProgress.asBroadcastStream();

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          if (!completer.isCompleted) completer.complete(dialogContext);
          return _DownloadProgressDialog(
            mapName: mapName,
            url: _tileProviderUrl,
            storeName: mapName,
            downloadStream: broadcastDownloadProgress,
          );
        },
      );
    }

    try {
      final dialogContext = await completer.future;
      await for (final progress in broadcastDownloadProgress) {}

      final mapInfo = GoMapInfo(
        name: mapName,
        filePath: mapName,
        downloadUrl: _tileProviderUrl,
        isTemporary: false,
        latitude: (southWestLat + northEastLat) / 2,
        longitude: (southWestLng + northEastLng) / 2,
        zoomLevel: zoomLevel,
      );
      _goMapInfoBox.put(mapInfo); // Changed from _mapBox.add(mapInfo)

      if (mounted && Navigator.of(dialogContext).canPop()) {
        Navigator.of(dialogContext).pop();
      }
      await _loadMap(mapInfo);
    } catch (error) {
      if (completer.isCompleted) {
        final dialogContext = await completer.future;
        if (mounted && Navigator.of(dialogContext).canPop()) {
          Navigator.of(dialogContext).pop();
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download map ($mapName): $error')),
        );
      }
    }
  }

  Future<void> _setupMarkers() async {
    final List<Marker> newMarkers = [];
    for (final contact in goContactsBox.getAll()) {
      if (contact.latitude != null && contact.longitude != null) {
        newMarkers.add(
          Marker(
            point: LatLng(contact.latitude!, contact.longitude!),
            width: 80.0,
            height: 80.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoAddEditContactScreen(contact: contact),
                  ),
                );
              },
              child: Image.asset('lib/features/go/assets/images/marker.png'),
            ),
          ),
        );
      }
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    if (_isAddingMarker) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoAddEditContactScreen(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
          ),
        ),
      ).then((_) {
        setState(() {
          _isAddingMarker = false; // Reset after returning from add contact screen
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_currentMapName ?? 'World'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'Go Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contacts'),
              onTap: _showContacts,
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Offline Maps'),
              onTap: _showOfflineMaps,
            ),
          ],
        ),
      ),
      body: _isLoadingMaps
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: _currentZoom,
                minZoom: 2.0,
                maxZoom: 18.0,
                onTap: _handleMapTap,
                onPositionChanged: (position, hasGesture) {
                  if (mounted && position.center != null && position.zoom != null) {
                    setState(() {
                      _currentCenter = position.center!;
                      _currentZoom = position.zoom!;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileProviderUrl,
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  tileProvider: _tileProvider ?? NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: _markers,
                  key: ValueKey<int>(_markerUpdateKey),
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => {},
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoomInButton',
                        onPressed: zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoomOutButton',
                        onPressed: zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: "add_marker_fab",
                        onPressed: _startAddingMarker,
                        child: Icon(_isAddingMarker ? Icons.cancel : Icons.add_location_alt_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showOfflineMaps() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoOfflineMapsScreen(
          currentMapName: _currentMapName,
          onLoadMap: (mapInfo) {
            _loadMap(mapInfo);
          },
          goMapInfoBox: _goMapInfoBox, // Added required parameter
          onDownloadMap: _downloadMap,
          onUploadMap: (String mapFilePath, String mapName, bool isTemporary) {},
        ),
      ),
    );
  }

  void _showContacts() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoContactsScreen(),
      ),
    );
  }

  void _startAddingMarker() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _isAddingMarker = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tap on map to place a marker')),
    );
  }

  void zoomIn() {
    if (_isDisposed || !mounted) return;
    final newZoom = (_mapController.camera.zoom + 1).clamp(2.0, 20.0);
    _mapController.move(_currentCenter, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  void zoomOut() {
    if (_isDisposed || !mounted) return;
    final newZoom = (_mapController.camera.zoom - 1).clamp(2.0, 20.0);
    _mapController.move(_currentCenter, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    goContactsBox.query().watch(triggerImmediately: true).listen((query) {}).cancel(); // Cancel the listener
    _mapController.dispose();
    super.dispose();
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String mapName;
  final String url;
  final String storeName;
  final Stream<fmtc.DownloadProgress> downloadStream;

  const _DownloadProgressDialog({required this.mapName, required this.url, required this.storeName, required this.downloadStream});

  @override
  _DownloadProgressDialogState createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Downloading ${widget.mapName}'),
      content: StreamBuilder<fmtc.DownloadProgress>(
        stream: widget.downloadStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Initializing download...'),
                SizedBox(height: 16),
                LinearProgressIndicator(),
              ],
            );
          }
          final progress = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: progress.percentageProgress / 100),
              const SizedBox(height: 16),
              Text('Progress: ${progress.percentageProgress.toStringAsFixed(1)}%'),
            ],
          );
        },
      ),
    );
  }
}