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
import 'package:by_faith/features/go/screens/go_add_edit_ministry_screen.dart';
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
import 'package:flutter_map_polywidget/flutter_map_polywidget.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:math' as math;

class GoTabScreen extends StatefulWidget {
  final String? routeType;
  final dynamic existingRoute;
  final bool isEditMode;
  final bool isViewMode;
  final Function(dynamic)? onRouteSave;

  const GoTabScreen({
    super.key,
    this.routeType,
    this.existingRoute,
    this.isEditMode = false,
    this.isViewMode = false,
    this.onRouteSave,
  });

  @override
  State<GoTabScreen> createState() => _GoTabScreenState();
}

class _GoTabScreenState extends State<GoTabScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoMapInfo> _goMapInfoBox;
  late Box<GoArea> _areaBox;
  late Box<GoStreet> _streetBox;
  late Box<GoZone> _zoneBox;
  bool _isLoadingMaps = true;
  bool _showRoutes = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<fm.Marker> _markers = [];
  List<fm.Polyline> _polylines = [];
  List<fm.Polygon> _polygons = [];
  List<PolyWidget> _polyWidgets = [];
  bool _isAddingMarker = false;
  bool _isAddingRoute = false;
  bool _isDisposed = false;
  String? _currentMapName;
  int _layerUpdateKey = 0;
  String _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  double _currentZoom = 2.0;
  LatLng _currentCenter = const LatLng(39.0, -98.0);
  fm.TileProvider? _tileProvider;
  PolyEditor? _polyEditor;
  String? _routeType;
  String _routeName = '';
  Timer? _debounceTimer;
  PolyWidget? _tempZoneWidget;

  double _calculateZoneWidthInMeters(double zoom) {
    const minZoom = 2.0;
    const maxZoom = 18.0;
    const maxWidth = 500000.0; // 500km at world level
    const minWidth = 100.0; // 100m at street level
    final t = (zoom - minZoom) / (maxZoom - minZoom);
    return maxWidth * (1 - t) + minWidth * t;
  }

  double _calculateZoneHeightInMeters(double zoom) {
    return _calculateZoneWidthInMeters(zoom) * 0.5;
  }

  double _calculateProgress(GoZone zone) {
    final contacts = goContactsBox.getAll();
    final zoneBounds = _getZoneBounds(zone);
    int totalContacts = 0;
    int visitedContacts = 0;

    for (final contact in contacts) {
      if (contact.latitude != null && contact.longitude != null) {
        final contactPoint = LatLng(contact.latitude!, contact.longitude!);
        if (zoneBounds.contains(contactPoint)) {
          totalContacts++;
          if (contact.isVisited ?? false) {
            visitedContacts++;
          }
        }
      }
    }

    return totalContacts > 0 ? visitedContacts / totalContacts : 0.0;
  }

  fm.LatLngBounds _getZoneBounds(GoZone zone) {
    const metersPerDegree = 111000;
    final latDelta = zone.heightInMeters / metersPerDegree / 2;
    final lngDelta = zone.widthInMeters / metersPerDegree / 2;
    return fm.LatLngBounds(
      LatLng(zone.latitude - latDelta, zone.longitude - lngDelta),
      LatLng(zone.latitude + latDelta, zone.longitude + lngDelta),
    );
  }

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _initObjectBox().then((_) async {
      if (_isDisposed) return;
      _areaBox = store.box<GoArea>();
      _streetBox = store.box<GoStreet>();
      _zoneBox = store.box<GoZone>();
      await _initTileProvider();
      await _restoreLastMap();
      await _setupLayers();
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
      _areaBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      _streetBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      _zoneBox.query().watch(triggerImmediately: true).listen((_) {
        _debounceSetupLayers();
      });
      if (widget.routeType != null || widget.existingRoute != null) {
        _startRouteMode();
      }
    });
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _debounceSetupLayers() {
    _debounce(() {
      if (mounted) {
        _setupLayers();
      }
    });
  }

  Future<void> _initObjectBox() async {
    try {
      _goMapInfoBox = store.box<GoMapInfo>();
      GoMapInfo? worldMapInfo = _goMapInfoBox.query(GoMapInfo_.name.equals('World')).build().findFirst();
      if (worldMapInfo == null) {
        worldMapInfo = GoMapInfo(
          name: 'World',
          filePath: '',
          downloadUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          isTemporary: false,
          latitude: 39.0,
          longitude: -98.0,
          zoomLevel: 2,
        );
        _goMapInfoBox.put(worldMapInfo);
      } else {
        worldMapInfo.latitude = 39.0;
        worldMapInfo.longitude = -98.0;
        worldMapInfo.zoomLevel = 2;
        _goMapInfoBox.put(worldMapInfo);
      }
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
      print('Tile provider error: $e'); // Log for debugging
      if (mounted) {
        setState(() {
          _tileProvider = fm.NetworkTileProvider(); // Fallback
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

  void _setDefaultMap() {
    _currentMapName = 'World';
    _currentCenter = const LatLng(39.0, -98.0);
    _currentZoom = 2.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.mapController.move(_currentCenter, _currentZoom);
    });
  }

  Future<void> _loadMap(GoMapInfo mapInfo) async {
    if (_isDisposed || !mounted) return;
    try {
      final newCenter = LatLng(mapInfo.latitude ?? 39.0, mapInfo.longitude ?? -98.0);
      final newZoom = (mapInfo.zoomLevel?.toDouble() ?? 2.0).clamp(2.0, 18.0);

      // Ensure tile provider is initialized
      if (mapInfo.filePath?.isNotEmpty ?? false) {
        final store = fmtc.FMTCStore(mapInfo.name);
        final bool storeReady = await store.manage.ready;
        if (storeReady) {
          await _initTileProvider(storeName: mapInfo.name);
          _tileProviderUrl = mapInfo.downloadUrl ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
        } else {
          await _initTileProvider(); // Fallback to online tiles
          _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
          _currentMapName = 'World';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Offline map "${mapInfo.name}" not found. Loading online map.')),
          );
        }
      } else {
        await _initTileProvider(); // Default to online tiles
        _tileProviderUrl = mapInfo.downloadUrl?.isNotEmpty ?? false
            ? mapInfo.downloadUrl!
            : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      }

      if (mounted) {
        setState(() {
          _currentMapName = mapInfo.name;
          _currentCenter = newCenter;
          _currentZoom = newZoom;
          _layerUpdateKey++; // Force map refresh
        });

        // Ensure map controller is updated
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
    final List<fm.Polyline> newPolylines = [];
    final List<fm.Polygon> newPolygons = [];
    final List<PolyWidget> newPolyWidgets = [];

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

    if (_showRoutes) {
      for (final area in _areaBox.getAll()) {
        if (area.points.length >= 3) {
          newPolygons.add(
            fm.Polygon(
              points: area.points,
              color: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2.0,
            ),
          );
        }
      }
      for (final street in _streetBox.getAll()) {
        if (street.points.isNotEmpty) {
          newPolylines.add(
            fm.Polyline(
              points: street.points,
              color: Colors.red,
              strokeWidth: 4.0,
            ),
          );
        }
      }
      for (final zone in _zoneBox.getAll()) {
        final progress = _calculateProgress(zone);
        final widthInMeters = _calculateZoneWidthInMeters(_currentZoom); // Use current zoom
        final heightInMeters = _calculateZoneHeightInMeters(_currentZoom); // Use current zoom
        newPolyWidgets.add(
          PolyWidget(
            center: zone.center,
            widthInMeters: widthInMeters,
            heightInMeters: heightInMeters,
            child: GestureDetector(
              onTap: () {
                if (!_isAddingRoute) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoTabScreen(
                        routeType: 'Zone',
                        existingRoute: zone,
                        isViewMode: true,
                        onRouteSave: (dynamic result) {
                          _zoneBox.put(result);
                        },
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      zone.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: progress < 0.5 ? Colors.red : Colors.green,
                    ),
                    Text('${(progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        _polylines = newPolylines;
        _polygons = newPolygons;
        _polyWidgets = newPolyWidgets;
        _layerUpdateKey++;
      });
    }
  }

  void _startRouteMode() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _isAddingRoute = true;
      _isAddingMarker = false;
      _routeType = widget.routeType;
      _polyWidgets.clear();
      _tempZoneWidget = null;
      if (_routeType == 'Area' || _routeType == 'Street') {
        _polyEditor = PolyEditor(
          addClosePathMarker: _routeType == 'Area',
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
      } else {
        _polyEditor = null;
      }
      if (widget.existingRoute != null) {
        _loadExistingRoute();
      }
    });
    if (_isAddingRoute && !widget.isViewMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tap on the map to add points for $_routeType.'),
          action: SnackBarAction(
            label: 'Cancel',
            onPressed: _cancelRouteMode,
          ),
        ),
      );
    }
  }

  void _loadExistingRoute() {
    if (widget.existingRoute is GoArea) {
      final area = widget.existingRoute as GoArea;
      _routeName = area.name;
      _polyEditor!.points.addAll(area.points);
      _fitBounds(area.points);
    } else if (widget.existingRoute is GoStreet) {
      final street = widget.existingRoute as GoStreet;
      _routeName = street.name;
      _polyEditor!.points.addAll(street.points);
      _fitBounds(street.points);
    } else if (widget.existingRoute is GoZone) {
      final zone = widget.existingRoute as GoZone;
      _routeName = zone.name;
      final widthInMeters = _calculateZoneWidthInMeters(_currentZoom);
      final heightInMeters = _calculateZoneHeightInMeters(_currentZoom);
      _tempZoneWidget = PolyWidget(
        center: zone.center,
        widthInMeters: widthInMeters,
        heightInMeters: heightInMeters,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                zone.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: _calculateProgress(zone),
                backgroundColor: Colors.grey[300],
                color: _calculateProgress(zone) < 0.5 ? Colors.red : Colors.green,
              ),
              Text('${(_calculateProgress(zone) * 100).toStringAsFixed(0)}%'),
            ],
          ),
        ),
      );
      _fitBounds([zone.center]);
    }
    _updateTempRouteLayers();
    setState(() {
      _layerUpdateKey++;
    });
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty) {
      _currentCenter = const LatLng(39.0, -98.0);
      _currentZoom = 2.0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.animateTo(dest: _currentCenter, zoom: _currentZoom);
      });
      return;
    }

    // Calculate bounds manually
    double minLat = points[0].latitude;
    double maxLat = points[0].latitude;
    double minLng = points[0].longitude;
    double maxLng = points[0].longitude;

    for (var point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    // Calculate center
    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);

    // Calculate approximate zoom level based on latitude/longitude span
    final latDiff = (maxLat - minLat).abs();
    final lngDiff = (maxLng - minLng).abs();
    final maxDiff = math.max(latDiff, lngDiff);

    // Adjust zoom to fit the bounds, with a closer view for small shapes
    double zoom = 15.0 - (maxDiff * 50).clamp(0.0, 13.0);
    zoom = zoom.clamp(2.0, 18.0);

    // Add padding (in degrees) to ensure all points are visible
    final padding = maxDiff * 0.2;
    minLat -= padding;
    maxLat += padding;
    minLng -= padding;
    maxLng += padding;

    _currentCenter = center;
    _currentZoom = zoom;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.animateTo(dest: _currentCenter, zoom: _currentZoom);
    });
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
          color: Colors.red,
          strokeWidth: 4.0,
        ),
      );
    }
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (_isAddingMarker) {
      _showAddMarkerOptions(latLng);
    } else if (_isAddingRoute && !widget.isViewMode && _routeType != null) {
      _addRoutePoint(latLng);
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
      _debounce(() {
        if (mounted) {
          setState(() {
            _polyWidgets.clear();
            final widthInMeters = _calculateZoneWidthInMeters(_currentZoom);
            final heightInMeters = _calculateZoneHeightInMeters(_currentZoom);
            _tempZoneWidget = PolyWidget(
              center: point,
              widthInMeters: widthInMeters,
              heightInMeters: heightInMeters,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      _routeName.isEmpty ? 'New Zone' : _routeName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.grey,
                      color: Colors.red,
                    ),
                    const Text('0%'),
                  ],
                ),
              ),
            );
            _fitBounds([point]);
          });
        }
      });
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
                title: const Text('Add Area'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewRoute('Area');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions),
                title: const Text('Add Street'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewRoute('Street');
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Add Zone'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewRoute('Zone');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startNewRoute(String type) {
    setState(() {
      _routeType = type;
      _isAddingRoute = true;
      _isAddingMarker = false;
      _polyWidgets.clear();
      _tempZoneWidget = null;
      if (type == 'Area' || type == 'Street') {
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
      } else {
        _polyEditor = null;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tap on the map to add points for $type.'),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: _cancelRouteMode,
        ),
      ),
    );
  }

  void _cancelRouteMode() async {
    if (_polyEditor?.points.isNotEmpty ?? false || _tempZoneWidget != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Route Creation'),
          content: const Text('Discard changes to this route?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      if (!confirm!) return;
    }
    setState(() {
      _isAddingRoute = false;
      _routeType = null;
      _polyEditor = null;
      _polyWidgets.clear();
      _tempZoneWidget = null;
      _routeName = '';
      _setupLayers();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route creation cancelled.')),
    );
  }

  void _showSaveRouteDialog() async {
    if (widget.isViewMode) {
      Navigator.pop(context);
      return;
    }

    if (_routeType == 'Area' && (_polyEditor?.points.length ?? 0) < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 3 points to create an area.')),
      );
      return;
    }
    if (_routeType == 'Street' && (_polyEditor?.points.length ?? 0) < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 points to create a street.')),
      );
      return;
    }
    if (_routeType == 'Zone' && _tempZoneWidget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a zone to save.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _routeName.isEmpty && _polyEditor != null && _polyEditor!.points.isNotEmpty
          ? '$_routeType ${_polyEditor!.points[0].latitude.toStringAsFixed(2)},${_polyEditor!.points[0].longitude.toStringAsFixed(2)}'
          : _routeName,
    );

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.isEditMode ? 'Edit' : 'Save'} $_routeType'),
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
              Navigator.pop(context, nameController.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        dynamic item;
        if (_routeType == 'Area') {
          item = GoArea(
            name: name,
            latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
            longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
          );
        } else if (_routeType == 'Street') {
          item = GoStreet(
            name: name,
            latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
            longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
          );
        } else if (_routeType == 'Zone') {
          item = GoZone(
            name: name,
            latitude: _tempZoneWidget!.center.latitude,
            longitude: _tempZoneWidget!.center.longitude,
            widthInMeters: _calculateZoneWidthInMeters(_currentZoom),
            heightInMeters: _calculateZoneHeightInMeters(_currentZoom),
          );
        }
        if (widget.existingRoute != null) {
          item.id = (widget.existingRoute as dynamic).id;
        }

        if (item is GoArea) {
          _areaBox.put(item);
        } else if (item is GoStreet) {
          _streetBox.put(item);
        } else if (item is GoZone) {
          _zoneBox.put(item);
        }

        if (mounted) {
          setState(() {
            _isAddingRoute = false;
            _routeType = null;
            _polyEditor = null;
            _polyWidgets.clear();
            _tempZoneWidget = null;
            _routeName = '';
            _setupLayers();
          });
          Navigator.pop(context); // Navigate back to GoRoutePlannerScreen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$_routeType saved successfully.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving $_routeType: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_isAddingRoute ? 'Add/Edit $_routeType' : _currentMapName ?? 'World'),
        actions: [
          if (_isAddingRoute && !widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveRouteDialog,
              tooltip: 'Save Route',
            ),
          IconButton(
            icon: Icon(_showRoutes ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showRoutes = !_showRoutes;
                _setupLayers();
              });
            },
            tooltip: _showRoutes ? 'Hide Routes' : 'Show Routes',
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
                    child: const Text(
                      'Go Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
              title: const Text('Churches'),
              onTap: _showChurches,
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contacts'),
              onTap: _showContacts,
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Ministries'),
              onTap: _showMinistries,
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Offline Maps'),
              onTap: _showOfflineMaps,
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Route Planner'),
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
                    if (_polyWidgets.isNotEmpty && _showRoutes || _tempZoneWidget != null)
                      PolyWidgetLayer(
                        key: ValueKey<String>('polywidget_layer_$_layerUpdateKey'),
                        polyWidgets: [
                          ..._polyWidgets,
                          if (_tempZoneWidget != null) _tempZoneWidget!,
                        ],
                      ),
                    fm.MarkerLayer(
                      key: ValueKey<int>(_layerUpdateKey),
                      markers: _markers,
                    ),
                    if (_isAddingRoute && !widget.isViewMode && _polyEditor != null)
                      DragMarkers(
                        markers: _polyEditor!.edit(),
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
                title: const Text('Add Contact'),
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
                title: const Text('Add Church'),
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
                title: const Text('Add Ministry'),
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

  void _showChurches() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoChurchesScreen(),
      ),
    );
  }

  void _showMinistries() {
    if (_isDisposed || !mounted) return;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GoMinistriesScreen(),
      ),
    );
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

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String mapName;
  final String url;
  final String storeName;
  final Stream<fmtc.DownloadProgress> downloadStream;

  const _DownloadProgressDialog({
    required this.mapName,
    required this.url,
    required this.storeName,
    required this.downloadStream,
  });

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