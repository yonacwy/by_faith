import 'package:flutter/material.dart';
import 'package:by_faith/features/go/screens/go_contacts_screen.dart';
import 'package:by_faith/features/go/screens/go_offline_maps_screen.dart';
import 'package:by_faith/features/go/screens/go_churches_screen.dart';
import 'package:by_faith/features/go/screens/go_ministries_screen.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:by_faith/features/go/screens/go_add_edit_contact_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_church_screen.dart';
import 'package:by_faith/features/go/screens/go_search_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:by_faith/features/go/screens/go_add_edit_ministry_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_zone_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_area_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_street_screen.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/go/models/go_map_info_model.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:by_faith/features/go/screens/go_settings_screen.dart';
import 'package:by_faith/features/go/screens/go_route_planner_screen.dart';
import 'package:by_faith/features/go/screens/go_export_import_screen.dart';
import 'package:by_faith/features/go/screens/go_share_screen.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/font_provider.dart';

enum LineType { street, river, path }

class GoTabScreen extends StatefulWidget {
  final GoZone? zoneToEdit;

  const GoTabScreen({super.key, this.zoneToEdit});

  @override
  State<GoTabScreen> createState() => _GoTabScreenState();
}

class _GoTabScreenState extends State<GoTabScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoMapInfo> _goMapInfoBox;
  late Box<GoZone> _zoneBox;
  late Box<GoArea> _areaBox;
  late Box<GoStreet> _streetBox;
  bool _isLoadingMaps = true;
  bool _showRoutes = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<fm.Marker> _markers = [];
  List<fm.CircleMarker> _circleMarkers = [];
  List<DragMarker> _dragMarkers = [];
  List<GoZone> _zones = [];
  List<fm.Polygon> _polygons = [];
  List<fm.Polyline> _polylines = [];
  bool _isAddingMarker = false;
  bool _isAddingRoute = false;
  String? _routeType;
  bool _showContacts = true;
  bool _showChurches = true;
  bool _showMinistries = true;
  bool _showAreas = true;
  bool _showStreets = true;
  bool _showZones = true;
  PolyEditor? _polyEditor;
  String _routeName = '';
  bool _isDisposed = false;
  String? _currentMapName;
  int _layerUpdateKey = 0;
  String _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  double _currentZoom = 2.0;
  LatLng _currentCenter = const LatLng(39.0, -98.0);
  fm.TileProvider? _tileProvider;
  Timer? _debounceTimer;
  GoZone? _selectedZone;
  List<dynamic> _markersInZone = [];
  double _zoneRadius = 0.0;
  LatLng? _zoneCenter;
  bool _isEditingZone = false;
  LineType _lineType = LineType.street;

  double _calculateZoneRadiusInMeters(double zoom) {
    const minZoom = 2.0;
    const maxZoom = 18.0;
    const maxRadius = 250000.0; // 250km at world level
    const minRadius = 50.0; // 50m at street level
    final t = (zoom - minZoom) / (maxZoom - minZoom);
    return maxRadius * (1 - t) + minRadius * t;
  }

  double _calculateProgress(GoZone zone) {
    final contacts = goContactsBox.getAll();
    int totalContacts = 0;
    int visitedContacts = 0;

    for (final contact in contacts) {
      if (contact.latitude != null && contact.longitude != null) {
        final contactPoint = LatLng(contact.latitude!, contact.longitude!);
        if (_isPointInZone(contactPoint, zone)) {
          totalContacts++;
          if (contact.isVisited ?? false) {
            visitedContacts++;
          }
        }
      }
    }

    return totalContacts > 0 ? visitedContacts / totalContacts : 0.0;
  }

  bool _isPointInZone(LatLng point, GoZone zone) {
    const Distance distance = Distance();
    final center = LatLng(zone.latitude, zone.longitude);
    final radius = (zone.widthInMeters / 2); // Use width/2 as radius
    return distance(center, point) <= radius;
  }

  void _updateMarkersInZone(GoZone zone) {
    _markersInZone.clear();
    final contacts = goContactsBox.getAll();
    final churches = goChurchesBox.getAll();
    final ministries = goMinistriesBox.getAll();

    for (final contact in contacts) {
      if (contact.latitude != null && contact.longitude != null) {
        final point = LatLng(contact.latitude!, contact.longitude!);
        if (_isPointInZone(point, zone)) {
          _markersInZone.add(contact);
        }
      }
    }
    for (final church in churches) {
      if (church.latitude != null && church.longitude != null) {
        final point = LatLng(church.latitude!, church.longitude!);
        if (_isPointInZone(point, zone)) {
          _markersInZone.add(church);
        }
      }
    }
    for (final ministry in ministries) {
      if (ministry.latitude != null && ministry.longitude != null) {
        final point = LatLng(ministry.latitude!, ministry.longitude!);
        if (_isPointInZone(point, zone)) {
          _markersInZone.add(ministry);
        }
      }
    }

    if (_markersInZone.isNotEmpty) {
      _showMarkersInZoneDialog();
    }
  }

  void _showMarkersInZoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Markers in Zone',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _markersInZone.map((item) {
              String type = item is GoContact ? 'Contact' : item is GoChurch ? 'Church' : 'Ministry';
              return ListTile(
                title: Text(
                  item is GoContact ? item.fullName : item is GoChurch ? item.churchName : item.ministryName,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                subtitle: Text(
                  type,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize * 0.8,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (item is GoContact) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoAddEditContactScreen(contact: item),
                      ),
                    );
                  } else if (item is GoChurch) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoAddEditChurchScreen(church: item),
                      ),
                    );
                  } else if (item is GoMinistry) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoAddEditMinistryScreen(ministry: item),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _initObjectBox().then((_) async {
      if (_isDisposed) return;
      await _initTileProvider();
      await _restoreLastMap();
      if (widget.zoneToEdit != null) {
        _selectedZone = widget.zoneToEdit;
        _isEditingZone = true;
        _zoneCenter = LatLng(_selectedZone!.latitude, _selectedZone!.longitude);
        _zoneRadius = _selectedZone!.widthInMeters / 2;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.mapController.move(_zoneCenter!, _currentZoom);
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _setupLayers();
      });
      if (mounted) {
        setState(() {
          _isLoadingMaps = false;
        });
      }
      goContactsBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      goChurchesBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      goMinistriesBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      _zoneBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
    });
  }

  void _navigateToMapScreen(String type, {dynamic item, bool isEdit = false, bool isView = false}) {
    Widget screen;
    LatLng? currentCenter;
    double? currentZoom;
    if (_mapController.mapController.camera.center != null) {
      currentCenter = _mapController.mapController.camera.center;
      currentZoom = _mapController.mapController.camera.zoom;
    }
    switch (type) {
      case 'Area':
        screen = GoAddEditAreaScreen(
          area: isEdit || isView ? item as GoArea : null,
          isViewMode: isView,
          initialCenter: !isEdit && !isView ? currentCenter : null,
          initialZoom: !isEdit && !isView ? currentZoom : null,
        );
        break;
      case 'Street':
        screen = GoAddEditStreetScreen(
          street: isEdit || isView ? item as GoStreet : null,
          isViewMode: isView,
          initialCenter: !isEdit && !isView ? currentCenter : null,
          initialZoom: !isEdit && !isView ? currentZoom : null,
        );
        break;
      case 'Zone':
        screen = GoAddEditZoneScreen(
          zone: isEdit || isView ? item as GoZone : null,
          initialCenter: !isEdit && !isView ? currentCenter : null,
          initialZoom: !isEdit && !isView ? currentZoom : null,
        );
        break;
      default:
        return; // Should not happen
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _debounceSetupLayers() {
    _debounce(() {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            _setupLayers();
          }
        });
      }
    });
  }

  Future<void> _initObjectBox() async {
    try {
      _goMapInfoBox = store.box<GoMapInfo>();
      _zoneBox = store.box<GoZone>();
      _areaBox = store.box<GoArea>();
      _streetBox = store.box<GoStreet>();
      GoMapInfo? worldMapInfo = _goMapInfoBox.query(GoMapInfo_.name.equals('World')).build().findFirst();
      if (worldMapInfo == null) {
        worldMapInfo = GoMapInfo(
          name: 'World',
          filePath: 'cached', // Set a non-empty filePath for offline map logic
          downloadUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          isTemporary: false,
          latitude: 39.0,
          longitude: -98.0,
          zoomLevel: 2,
        );
        _goMapInfoBox.put(worldMapInfo);
      } else {
        // Ensure filePath is set to 'cached' if it was previously empty
        if (worldMapInfo.filePath == null || worldMapInfo.filePath!.isEmpty) {
          worldMapInfo.filePath = 'cached';
        }
        worldMapInfo.latitude = 39.0;
        worldMapInfo.longitude = -98.0;
        worldMapInfo.zoomLevel = 2;
        _goMapInfoBox.put(worldMapInfo);
      }

      // Ensure the FMTC store for 'World' exists and is created
      final worldStore = fmtc.FMTCStore('World');
      await worldStore.manage.create(); // Create the store if it doesn't exist

    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMaps = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing map: $error')),
        );
      }
    }
  }

  Future<void> _initTileProvider({String? storeName}) async {
    try {
      if (storeName != null) {
        final store = fmtc.FMTCStore(storeName);
        final tileProvider = store.getTileProvider();
        if (mounted) {
          setState(() {
            _tileProvider = tileProvider;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _tileProvider = fm.NetworkTileProvider();
          });
        }
      }
    } catch (e) {
      print('Tile provider error: $e');
      if (mounted) {
        setState(() {
          _tileProvider = fm.NetworkTileProvider();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing tile provider: $e')),
        );
      }
    }
  }

  Future<void> _restoreLastMap() async {
    if (_isDisposed || !mounted) return;
    final String? savedMapName = userPreferencesBox.get(1)?.currentMap;
    if (savedMapName != null) {
      final mapInfo = _goMapInfoBox.query(GoMapInfo_.name.equals(savedMapName)).build().findFirst();
      if (mapInfo != null) {
        await _loadMap(mapInfo);
      } else {
        _setDefaultMap();
      }
    } else {
      _setDefaultMap();
    }
  }

  Future<void> _setDefaultMap() async { // Made async to await _initTileProvider
    _currentMapName = 'World';
    _currentCenter = const LatLng(39.0, -98.0);
    _currentZoom = 2.0;
    await _initTileProvider(); // Explicitly initialize network tile provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.mapController.move(_currentCenter, _currentZoom);
    });
  }

  Future<void> _loadMap(GoMapInfo mapInfo) async {
    if (_isDisposed || !mounted) return;
    try {
      final newCenter = LatLng(mapInfo.latitude ?? 39.0, mapInfo.longitude ?? -98.0);
      final newZoom = (mapInfo.zoomLevel?.toDouble() ?? 2.0).clamp(2.0, 18.0);

      if (mapInfo.filePath?.isNotEmpty ?? false) {
        // Always attempt to use the cached store's tile provider if filePath is not empty
        await _initTileProvider(storeName: mapInfo.name);
        _tileProviderUrl = mapInfo.downloadUrl ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'; // Keep the original URL for the tile layer
      } else {
        // No filePath, load online map using the provided downloadUrl or default
        _tileProvider = fm.NetworkTileProvider(); // Explicitly set NetworkTileProvider
        _tileProviderUrl = mapInfo.downloadUrl?.isNotEmpty ?? false
            ? mapInfo.downloadUrl!
            : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      }

      if (mounted) {
        setState(() {
          _currentMapName = mapInfo.name;
          _currentCenter = newCenter;
          _currentZoom = newZoom;
          _layerUpdateKey++;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.mapController.move(newCenter, newZoom);
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

  Future<void> _setupLayers() async {
    final List<fm.Marker> newMarkers = [];
    final List<fm.CircleMarker> newCircleMarkers = [];
    final List<DragMarker> newDragMarkers = [];
    final List<GoZone> newZones = [];

    if (_showContacts) {
      for (final contact in goContactsBox.getAll()) {
        if (contact.latitude != null && contact.longitude != null) {
          newMarkers.add(
            fm.Marker(
              point: LatLng(contact.latitude!, contact.longitude!),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoAddEditContactScreen(contact: contact),
                    ),
                  );
                },
                child: Image.asset('lib/features/go/assets/images/marker_person.png'),
              ),
            ),
          );
        }
      }
    }
    if (_showChurches) {
      for (final church in goChurchesBox.getAll()) {
        if (church.latitude != null && church.longitude != null) {
          newMarkers.add(
            fm.Marker(
              point: LatLng(church.latitude!, church.longitude!),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoAddEditChurchScreen(church: church),
                    ),
                  );
                },
                child: Image.asset('lib/features/go/assets/images/marker_church.png'),
              ),
            ),
          );
        }
      }
    }
    if (_showMinistries) {
      for (final ministry in goMinistriesBox.getAll()) {
        if (ministry.latitude != null && ministry.longitude != null) {
          newMarkers.add(
            fm.Marker(
              point: LatLng(ministry.latitude!, ministry.longitude!),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoAddEditMinistryScreen(ministry: ministry),
                    ),
                  );
                },
                child: Image.asset('lib/features/go/assets/images/marker_ministry.png'),
              ),
            ),
          );
        }
      }
    }

    _polygons.clear();
    _polylines.clear();

    if (_showAreas || _showStreets || _showZones) { // Only process if any route/zone type is visible
      if (_selectedZone != null) {
        // Show only areas and streets within the selected zone if they are visible
        if (_showAreas) {
          for (final area in _areaBox.getAll()) {
            if (area.points.length >= 3) {
              // Check if any point of the area is within the selected zone
              bool isInZone = area.points.any((point) => _isPointInZone(point, _selectedZone!));
              if (isInZone) {
                _polygons.add(
                  fm.Polygon(
                    points: area.points,
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2.0,
                  ),
                );
              }
            }
          }
        }
        if (_showStreets) {
          for (final street in _streetBox.getAll()) {
            if (street.points.isNotEmpty) {
              if ((street.type ?? 'street') == 'path') {
                _polylines.addAll(_createDashedPolylines(
                  street.points,
                  Colors.green[700]!,
                  Colors.white,
                ));
              } else {
                _polylines.add(
                  fm.Polyline(
                    points: street.points,
                    color: _getLineColorForType(street.type),
                    borderColor: _getBorderColorForType(street.type),
                    borderStrokeWidth: 2.0,
                    strokeWidth: 4.0,
                  ),
                );
              }
            }
          }
        }
      } else {
        // Show all areas and streets if no zone is selected and they are visible
        if (_showAreas) {
          for (final area in _areaBox.getAll()) {
            if (area.points.length >= 3) {
              _polygons.add(
                fm.Polygon(
                  points: area.points,
                  color: Colors.blue.withOpacity(0.3),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2.0,
                ),
              );
            }
          }
        }
        if (_showStreets) {
          for (final street in _streetBox.getAll()) {
            if (street.points.isNotEmpty) {
              _polylines.add(
                fm.Polyline(
                  points: street.points,
                  color: _getLineColorForType(street.type),
                  borderColor: _getBorderColorForType(street.type),
                  borderStrokeWidth: 2.0,
                  strokeWidth: 4.0,
                ),
              );
            }
          }
        }
      }

      if (_showZones) {
        for (final zone in _zoneBox.getAll()) {
          newZones.add(zone);
          final center = LatLng(zone.latitude, zone.longitude);
          final radius = zone.widthInMeters / 2;
          newCircleMarkers.add(
            fm.CircleMarker(
              point: center,
              radius: radius,
              color: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2.0,
              useRadiusInMeter: true,
            ),
          );
          final currentZone = zone; // Capture the zone for the closure
          newDragMarkers.add(
            DragMarker(
                  point: center,
                  size: const Size(24.0, 24.0),
                  builder: (context, point, isDragging) => const Icon(Icons.circle, color: Colors.red, size: 24.0),
                  onDragEnd: (details, newPoint) {
                    setState(() {
                      currentZone.latitude = newPoint.latitude;
                      currentZone.longitude = newPoint.longitude;
                      _zoneBox.put(currentZone);
                      _selectedZone = currentZone;
                      _updateMarkersInZone(currentZone);
                      _setupLayers();
                    });
                  },
                ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        _circleMarkers = newCircleMarkers;
        _dragMarkers = newDragMarkers;
        _zones = newZones;
        _layerUpdateKey++;
      });
    }
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (_isAddingMarker) {
      _showAddMarkerOptions(latLng);
    } else if (_isAddingRoute && _routeType != null) {
      _addRoutePoint(latLng);
    } else {
      for (final zone in _zones) {
        if (_isPointInZone(latLng, zone)) {
          setState(() {
            _selectedZone = zone;
            _updateMarkersInZone(zone);
          });
          break;
        }
      }
    }
  }

  void _addRoutePoint(LatLng point) {
    if (_routeType == 'Area' || _routeType == 'Street') {
      _polyEditor!.add(_polyEditor!.points, point);
      _debounce(() {
        if (mounted) {
          setState(() {
            _updateTempRouteLayers();
            if (_routeType == 'Area' && _polyEditor!.points.length >= 3) {
              _fitBounds(_polyEditor!.points);
            } else if (_routeType == 'Street' && _polyEditor!.points.length >= 2) {
              _fitBounds(_polyEditor!.points);
            }
          });
        }
      });
    } else if (_routeType == 'Zone') {
      final zone = GoZone(
        name: 'New Zone',
        latitude: point.latitude,
        longitude: point.longitude,
        widthInMeters: _calculateZoneRadiusInMeters(_currentZoom) * 2,
        heightInMeters: _calculateZoneRadiusInMeters(_currentZoom),
      );
      _zoneBox.put(zone);
      setState(() {
        _isAddingRoute = false;
        _routeType = null;
        _setupLayers();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoAddEditZoneScreen(zone: zone),
        ),
      );
    }
  }

  void _showAddRouteOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: Text(
                  'Add Area',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  _navigateToMapScreen('Area');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions),
                title: Text(
                  'Add Street',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  _navigateToMapScreen('Street');
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: Text(
                  'Add Zone',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  _navigateToMapScreen('Zone');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getLineColor(LineType type) {
    switch (type) {
      case LineType.street:
        return Colors.red;
      case LineType.river:
        return Colors.blue;
      case LineType.path:
        return Colors.green;
    }
  }

  Color _getLineColorForType(String? type) {
    switch (type) {
      case 'river':
        return Colors.blue[900]!;
      case 'path':
        return Colors.brown[800]!;
      case 'street':
      default:
        return Colors.black;
    }
  }

  Color _getBorderColorForType(String? type) {
    switch (type) {
      case 'river':
        return Colors.green;
      case 'path':
        return Colors.white;
      case 'street':
      default:
        return Colors.white;
    }
  }

  void _startNewRoute(String type) {
    setState(() {
      _routeType = type;
      _isAddingRoute = true;
      _isAddingMarker = false;
      _polyEditor = PolyEditor(
        addClosePathMarker: type == 'Area',
        points: [],
        pointIcon: const Icon(Icons.circle, size: 12, color: Colors.red),
        intermediateIcon: const Icon(Icons.circle, size: 8, color: Colors.blue),
        callbackRefresh: (LatLng? latLng) {
          _debounce(() {
            if (mounted) {
              setState(() {
                _updateTempRouteLayers();
              });
            }
          });
        },
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(type == 'Zone'
            ? 'Tap to place the zone.'
            : 'Select Area or Street from the Route Planner.'),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: _cancelRouteMode,
        ),
      ),
    );
  }

  void _cancelRouteMode() {
    setState(() {
      _isAddingRoute = false;
      _routeType = null;
      _polyEditor = null;
      _polygons.clear();
      _polylines.clear();
      _setupLayers();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route creation cancelled.')),
    );
  }

  void _showHideOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      'Contacts',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showContacts,
                      onChanged: (value) {
                        modalSetState(() {
                          _showContacts = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Churches',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showChurches,
                      onChanged: (value) {
                        modalSetState(() {
                          _showChurches = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Ministries',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showMinistries,
                      onChanged: (value) {
                        modalSetState(() {
                          _showMinistries = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Areas',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showAreas,
                      onChanged: (value) {
                        modalSetState(() {
                          _showAreas = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Streets',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showStreets,
                      onChanged: (value) {
                        modalSetState(() {
                          _showStreets = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Zones',
                      style: TextStyle(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showZones,
                      onChanged: (value) {
                        modalSetState(() {
                          _showZones = value;
                          _setupLayers();
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateTempRouteLayers() {
    _polygons.clear();
    _polylines.clear();
    if (_routeType == 'Area' && _polyEditor!.points.length >= 3) {
      _polygons.add(
        fm.Polygon(
          points: _polyEditor!.points,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          borderStrokeWidth: 2.0,
        ),
      );
    } else if (_routeType == 'Street' && _polyEditor!.points.isNotEmpty) {
      _polylines.add(
        fm.Polyline(
          points: _polyEditor!.points,
          color: _getLineColorForType(_lineType.toString().split('.').last),
          borderColor: _getBorderColorForType(_lineType.toString().split('.').last),
          borderStrokeWidth: 2.0,
          strokeWidth: 4.0,
        ),
      );
    }
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      _currentCenter = const LatLng(39.0, -98.0);
      _currentZoom = 2.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.animateTo(dest: _currentCenter, zoom: _currentZoom);
      });
      return;
    }

    final bounds = fm.LatLngBounds.fromPoints(points);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraFit = fm.CameraFit.bounds(
        bounds: bounds,
        padding: padding ?? EdgeInsets.all(20.0),
      );
      final targetCamera = cameraFit.fit(_mapController.mapController.camera);
      _mapController.animateTo(
        dest: targetCamera.center,
        zoom: targetCamera.zoom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_isAddingRoute ? 'Add/Edit \\$_routeType' : _currentMapName ?? 'World'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Address',
            onPressed: () async {
              final LatLng? resultLocation = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoSearchScreen()),
              );
              if (resultLocation != null) {
                _mapController.animateTo(dest: resultLocation, zoom: 16.0); // Zoom to a reasonable level
              }
            },
          ),
          if (_isAddingRoute)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveRouteDialog,
              tooltip: 'Save Route',
            ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showHideOptions,
            tooltip: 'Hide Options',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            tooltip: 'Open Menu',
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[900],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Go Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize + 6,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoShareScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.import_export, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoExportImportScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoSettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.church),
              title: Text(
                'Churches',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              onTap: _navigateToChurches,
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: Text(
                'Contacts',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              onTap: _navigateToContacts,
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Ministries',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              onTap: _navigateToMinistries,
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: Text(
                'Offline Maps',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              onTap: _showOfflineMaps,
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: Text(
                'Route Planner',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoRoutePlannerScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _isLoadingMaps
              ? const Center(child: CircularProgressIndicator())
              : fm.FlutterMap(
                  mapController: _mapController.mapController,
                  options: fm.MapOptions(
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
                          _debounceSetupLayers();
                        });
                      }
                    },
                  ),
                  children: [
                    fm.TileLayer(
                      urlTemplate: _tileProviderUrl,
                      tileProvider: _tileProvider ?? fm.NetworkTileProvider(),
                    ),
                    if (_polygons.isNotEmpty && _showRoutes)
                      fm.PolygonLayer(
                        key: ValueKey<String>('polygon_layer_$_layerUpdateKey'),
                        polygons: _polygons,
                      ),
                    if (_polylines.isNotEmpty && _showRoutes)
                      fm.PolylineLayer(
                        key: ValueKey<String>('polyline_layer_$_layerUpdateKey'),
                        polylines: _polylines,
                      ),
                    if (_circleMarkers.isNotEmpty && _showRoutes)
                      fm.CircleLayer(
                        key: ValueKey<String>('circle_layer_$_layerUpdateKey'),
                        circles: _circleMarkers,
                      ),
                    fm.MarkerLayer(
                      key: ValueKey<int>(_layerUpdateKey),
                      markers: [
                        ..._markers,
                        ..._dragMarkers.map(
                          (m) => fm.Marker(
                            point: m.point,
                            width: m.size.width,
                            height: m.size.height,
                            key: m.key,
                            child: m.builder(context, m.point, false),
                            alignment: m.alignment,
                          ),
                        ),
                      ],
                    ),
                    fm.RichAttributionWidget(
                      attributions: [
                        fm.TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () {},
                        ),
                      ],
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
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'add_route_fab',
                  onPressed: _isAddingRoute ? _cancelRouteMode : _showAddRouteOptions,
                  child: Icon(_isAddingRoute ? Icons.cancel : Icons.route),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startAddingMarker() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _isAddingMarker = !_isAddingMarker;
      if (_isAddingMarker) _isAddingRoute = false;
    });
    if (_isAddingMarker) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tap on the map to add a marker.')),
      );
    }
  }

  void _showAddMarkerOptions(LatLng latLng) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  'Add Contact',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
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
                      _isAddingMarker = false;
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.church),
                title: Text(
                  'Add Church',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoAddEditChurchScreen(
                        latitude: latLng.latitude,
                        longitude: latLng.longitude,
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      _isAddingMarker = false;
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: Text(
                  'Add Ministry',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoAddEditMinistryScreen(
                        latitude: latLng.latitude,
                        longitude: latLng.longitude,
                      ),
                    ),
                  ).then((_) {
                    setState(() {
                      _isAddingMarker = false;
                    });
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void zoomIn() {
    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
  }

  void zoomOut() {
    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
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
          goMapInfoBox: _goMapInfoBox,
          onDownloadMap: _downloadMap,
          onUploadMap: (String mapFilePath, String mapName, bool isTemporary) {},
        ),
      ),
    );
  }

  void _navigateToContacts() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoContactsScreen(),
      ),
    );
  }

  void _navigateToChurches() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoChurchesScreen(),
      ),
    );
  }

  void _navigateToMinistries() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoMinistriesScreen(),
      ),
    );
  }

  Future<void> _downloadMap(String mapName, double southWestLat, double southWestLng, double northEastLat, double northEastLng, int zoomLevel, ScaffoldMessengerState scaffoldMessenger) async {
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
    final completer = Completer<BuildContext>();
    final downloadOperation = store.download.startForeground(
      region: fmtc.RectangleRegion(
        fm.LatLngBounds(
          LatLng(southWestLat, southWestLng),
          LatLng(northEastLat, northEastLng),
        ),
      ).toDownloadable(
        minZoom: zoomLevel,
        maxZoom: zoomLevel,
        options: fm.TileLayer(
          urlTemplate: _tileProviderUrl,
          tileProvider: fm.NetworkTileProvider(),
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
            onCancel: () {
              // TODO: Implement correct cancellation logic for foreground download.
              // The object returned by startForeground does not have a cancel method according to the compiler.
            },
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
      _goMapInfoBox.put(mapInfo);
      if (mounted && Navigator.of(dialogContext).canPop()) {
        Navigator.of(dialogContext).pop();
      }
      await _loadMap(mapInfo);
    } catch (error) {
      if (completer.isCompleted) {
        final dialogContext = await completer.future;
        if (dialogContext.mounted && Navigator.of(dialogContext).canPop()) {
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

  void _showSaveRouteDialog() {
    if (_routeType == 'Area' && _polyEditor!.points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 3 points to create an area.')),
      );
      return;
    }
    if (_routeType == 'Street' && _polyEditor!.points.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 points to create a street.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _routeName.isEmpty && _polyEditor!.points.isNotEmpty
          ? '$_routeType ${_polyEditor!.points[0].latitude.toStringAsFixed(2)},${_polyEditor!.points[0].longitude.toStringAsFixed(2)}'
          : _routeName,
    );

    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save $_routeType'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Enter name',
            labelText: 'Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty.')),
                );
                return;
              }
              Navigator.of(context).pop(nameController.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((name) {
      if (name != null && name.isNotEmpty) {
        try {
          if (_routeType == 'Area') {
            final area = GoArea(
              name: name,
              latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
              longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
            );
            _areaBox.put(area);
          } else if (_routeType == 'Street') {
            final street = GoStreet(
              name: name,
              latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
              longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
            );
            _streetBox.put(street);
          }
          setState(() {
            _isAddingRoute = false;
            _routeType = null;
            _polyEditor = null;
            _polygons.clear();
            _polylines.clear();
            _setupLayers();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$_routeType saved successfully.')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving $_routeType: $e')),
          );
        }
      }
    });
  }

  void _showSearchAddressDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter address'),
          autofocus: true,
          onSubmitted: (_) => _searchAddress(controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _searchAddress(controller.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _searchAddress(String address) async {
    if (address.trim().isEmpty) return;
    Navigator.of(context).pop();
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=\\${Uri.encodeComponent(address)}');
    try {
      final response = await http.get(url, headers: {'User-Agent': 'by_faith_app'});
      if (response.statusCode == 200) {
        final List results = json.decode(response.body);
        if (results.isNotEmpty) {
          final lat = double.tryParse(results[0]['lat'] ?? '');
          final lon = double.tryParse(results[0]['lon'] ?? '');
          if (lat != null && lon != null) {
            setState(() {
              _currentCenter = LatLng(lat, lon);
              _currentZoom = 16.0;
            });
            _mapController.animateTo(dest: _currentCenter, zoom: _currentZoom);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Moved to: \\${results[0]['display_name']}')),
            );
            return;
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address not found.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching address: \\$e')),
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  List<fm.Polyline> _createDashedPolylines(List<LatLng> points, Color color, Color borderColor) {
    const double dashLength = 0.001; // Approx 100m at zoom level ~12
    const double gapLength = 0.001; // Approx 100m at zoom level ~12
    List<fm.Polyline> dashedPolylines = [];

    for (int i = 0; i < points.length - 1; i++) {
      LatLng start = points[i];
      LatLng end = points[i + 1];
      double distance = const Distance().as(LengthUnit.Meter, start, end);
      int segments = (distance / (dashLength * 111000)).ceil(); // Rough conversion to degrees
      double latStep = (end.latitude - start.latitude) / segments;
      double lonStep = (end.longitude - start.longitude) / segments;

      for (int j = 0; j < segments; j += 2) {
        LatLng dashStart = LatLng(
          start.latitude + j * latStep,
          start.longitude + j * lonStep,
        );
        LatLng dashEnd = LatLng(
          start.latitude + (j + 1) * latStep,
          start.longitude + (j + 1) * lonStep,
        );
        if (j + 1 < segments) {
          dashedPolylines.add(fm.Polyline(
            points: [dashStart, dashEnd],
            color: color,
            strokeWidth: 4.0,
            borderColor: borderColor,
            borderStrokeWidth: 2.0,
          ));
        }
      }
    }
    return dashedPolylines;
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String mapName;
  final String url;
  final String storeName;
  final Stream<fmtc.DownloadProgress> downloadStream;
  final VoidCallback? onCancel; // Changed to VoidCallback

  const _DownloadProgressDialog({
    required this.mapName,
    required this.url,
    required this.storeName,
    required this.downloadStream,
    this.onCancel, // Changed to VoidCallback
  });

  @override
  State<_DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  double _progress = 0.0;
  String _message = 'Starting download...';
  StreamSubscription<fmtc.DownloadProgress>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.downloadStream.listen((progress) {
      setState(() {
        _progress = progress.percentageProgress / 100;
        _message = 'Downloaded ${progress.attemptedTilesCount} of ${progress.maxTilesCount} tiles (${(progress.percentageProgress).toStringAsFixed(1)}%)';
      });
    }, onError: (error) {
      setState(() {
        _message = 'Download failed: $error';
        _progress = 0.0;
      });
    }, onDone: () {
      setState(() {
        _message = 'Download complete!';
        _progress = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Downloading ${widget.mapName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 16),
          Text(_message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onCancel?.call(); // Call the provided cancel callback
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}