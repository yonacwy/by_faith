import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:async';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:vector_math/vector_math.dart' show radians, degrees;
import 'package:by_faith/app/i18n/strings.g.dart';

class GoAddEditZoneScreen extends StatefulWidget {
  final GoZone? zone;
  final bool isViewMode;
  final LatLng? initialCenter;
  final double? initialZoom;

  const GoAddEditZoneScreen({Key? key, this.zone, this.isViewMode = false, this.initialCenter, this.initialZoom}) : super(key: key);

  @override
  _GoAddEditZoneScreenState createState() => _GoAddEditZoneScreenState();
}

class _GoAddEditZoneScreenState extends State<GoAddEditZoneScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoZone> _zoneBox;
  late LatLng _currentZoneCenter;
  late double _currentZoneRadius;
  String _zoneName = '';
  Timer? _debounceTimer;
  int _layerUpdateKey = 0;
  List<fm.Marker> _markers = [];
  List<fm.Polyline> _polylines = [];
  List<fm.Polygon> _polygons = [];
  List<fm.CircleMarker> _circleMarkers = [];

  // ObjectBox Boxes for other map elements
  late Box<GoContact> _contactBox;
  late Box<GoChurch> _churchBox;
  late Box<GoMinistry> _ministryBox;
  late Box<GoArea> _areaBox;
  late Box<GoStreet> _streetBox;

  // Lists to hold fetched data
  List<GoContact> _contacts = [];
  List<GoChurch> _churches = [];
  List<GoMinistry> _ministries = [];
  List<GoArea> _areas = [];
  List<GoStreet> _streets = [];
  List<GoZone> _zones = [];

  static const double _minRadius = 50.0;
  static const double _maxRadius = 100000.0; // Increased to 100 km for larger areas
  static const double _radiusStep = 50.0;

  bool _showContacts = true;
  bool _showChurches = true;
  bool _showMinistries = true;
  bool _showAreas = true;
  bool _showStreets = true;
  bool _showZones = true;

  bool _didLoadMapData = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _zoneBox = store.box<GoZone>();
    _contactBox = store.box<GoContact>();
    _churchBox = store.box<GoChurch>();
    _ministryBox = store.box<GoMinistry>();
    _areaBox = store.box<GoArea>();
    _streetBox = store.box<GoStreet>();
    // Only set initial values, do not update layers here
    if (widget.zone != null) {
      _zoneName = widget.zone!.name;
      _currentZoneCenter = LatLng(
        widget.zone!.latitude.clamp(-90.0, 90.0),
        widget.zone!.longitude.clamp(-180.0, 180.0),
      );
      _currentZoneRadius = widget.zone!.widthInMeters.clamp(_minRadius, _maxRadius);
    } else if (widget.initialCenter != null) {
      _currentZoneCenter = widget.initialCenter!;
      _currentZoneRadius = 500.0;
    } else {
      _currentZoneCenter = const LatLng(39.0, -98.0);
      _currentZoneRadius = 500.0;
    }
    debugPrint('Zone: Initial center: $_currentZoneCenter, radius: $_currentZoneRadius');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadMapData) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadAllMapData();
        if (widget.zone == null) {
          final allPoints = _getAllMapPoints();
          if (allPoints.isNotEmpty) {
            final bounds = fm.LatLngBounds.fromPoints(allPoints);
            setState(() {
              _currentZoneCenter = bounds.center;
            });
          }
        }
        if (mounted) {
          setState(() {
            _mapReady = true;
          });
        }
        _didLoadMapData = true;
        if (widget.zone != null) {
          _fitBounds(_getAllMapPoints());
        }
        if (!widget.isViewMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.go_add_edit_zone_screen.tap_to_set_center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              action: SnackBarAction(
                label: t.go_add_edit_zone_screen.cancel,
                onPressed: _cancelZoneMode,
              ),
            ),
          );
        }
        debugPrint('Zone: didChangeDependencies completed, circleMarkers: [0m${_circleMarkers.length}');
      });
    }
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _updateZoneLayer() {
    if (!_mapReady || !mounted) return;
    _debounce(() {
      if (mounted) {
        setState(() {
          _circleMarkers.clear();
          if (_showZones) {
            _circleMarkers.add(
              fm.CircleMarker(
                point: _currentZoneCenter,
                radius: _currentZoneRadius.clamp(_minRadius, _maxRadius),
                color: Colors.purple.withOpacity(0.2),
                borderColor: Colors.purple,
                borderStrokeWidth: 2.0,
                useRadiusInMeter: true,
              ),
            );
          }
          _layerUpdateKey++;
          debugPrint('Zone: Updated zone layer, circleMarkers: ${_circleMarkers.length}');
        });
      }
    });
  }

  void _fitBounds(List<LatLng> points, {double? radius, EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      debugPrint('Zone: No points, reset to default view');
      return;
    }

    try {
      fm.LatLngBounds bounds;
      if (radius != null && points.length == 1) {
        final center = points.first;
        final offsetDistance = radius * 1.414; // Diagonal for padding
        final northEast = _offsetPoint(center, offsetDistance, 45);
        final southWest = _offsetPoint(center, offsetDistance, 225);
        bounds = fm.LatLngBounds(southWest, northEast);
      } else {
        bounds = fm.LatLngBounds.fromPoints(points);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cameraFit = fm.CameraFit.bounds(
          bounds: bounds,
          padding: padding ?? const EdgeInsets.all(20.0),
        );
        final targetCamera = cameraFit.fit(_mapController.mapController.camera);

        _mapController.animateTo(
          dest: targetCamera.center,
          zoom: targetCamera.zoom.clamp(2.0, 18.0),
        );
        debugPrint('Zone: Fitted bounds, center: ${targetCamera.center}, zoom: ${targetCamera.zoom}');
      });
    } catch (e) {
      debugPrint('Zone: Error in _fitBounds: $e');
      _mapController.animateTo(dest: points.first, zoom: 12.0);
    }
  }

  LatLng _offsetPoint(LatLng center, double distanceMeters, double bearingDegrees) {
    final earthRadius = 6371000.0; // Earth's radius in meters
    final bearingRad = radians(bearingDegrees);
    final lat1 = radians(center.latitude);
    final lon1 = radians(center.longitude);
    final angularDistance = distanceMeters / earthRadius;

    final lat2 = math.asin(
      math.sin(lat1) * math.cos(angularDistance) +
          math.cos(lat1) * math.sin(angularDistance) * math.cos(bearingRad),
    );
    final lon2 = lon1 +
        math.atan2(
          math.sin(bearingRad) * math.sin(angularDistance) * math.cos(lat1),
          math.cos(angularDistance) - math.sin(lat1) * math.sin(lat2),
        );

    return LatLng(
      degrees(lat2).clamp(-90.0, 90.0),
      degrees(lon2).clamp(-180.0, 180.0),
    );
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (!widget.isViewMode) {
      setState(() {
        _currentZoneCenter = LatLng(
          latLng.latitude.clamp(-90.0, 90.0),
          latLng.longitude.clamp(-180.0, 180.0),
        );
        _updateZoneLayer();
        // When setting a new zone center, fit bounds to all visible layers including the new center
        final pointsToFit = _getAllMapPoints();
        _fitBounds(pointsToFit); // Call _fitBounds without the radius parameter
        debugPrint('Zone: Map tapped, new center: $_currentZoneCenter');
      });
    }
  }

  void _cancelZoneMode() async {
    if (_currentZoneCenter != const LatLng(39.0, -98.0) || _currentZoneRadius != 500.0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            t.go_add_edit_zone_screen.cancel_zone_creation,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize + 2,
                ),
          ),
          content: Text(
            t.go_add_edit_zone_screen.discard_changes,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                t.go_add_edit_zone_screen.keep_editing,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                t.go_add_edit_zone_screen.discard,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }
    Navigator.pop(context);
  }

  void _showSaveZoneDialog() async {
    if (widget.isViewMode) {
      Navigator.pop(context);
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _zoneName.isEmpty
          ? 'Zone ${_currentZoneCenter.latitude.toStringAsFixed(2)},${_currentZoneCenter.longitude.toStringAsFixed(2)}'
          : _zoneName,
    );

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          (widget.zone != null ? t.go_add_edit_zone_screen.edit : t.go_add_edit_zone_screen.save) + ' Zone',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize + 2,
              ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: t.go_add_edit_zone_screen.enter_name,
            labelText: t.go_add_edit_zone_screen.name,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_add_edit_zone_screen.cancel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t.go_add_edit_zone_screen.name_cannot_be_empty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                    ),
                  ),
                );
                return;
              }
              Navigator.pop(context, nameController.text.trim());
            },
            child: Text(
              t.go_add_edit_zone_screen.save,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
            ),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final zone = GoZone(
          name: name,
          latitude: _currentZoneCenter.latitude,
          longitude: _currentZoneCenter.longitude,
          widthInMeters: _currentZoneRadius,
          heightInMeters: _currentZoneRadius,
        );
        if (widget.zone != null) {
          zone.id = widget.zone!.id;
        }

        _zoneBox.put(zone);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.go_add_edit_zone_screen.zone_saved_successfully,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
              t.go_add_edit_zone_screen.error_saving_zone.replaceAll('{error}', e.toString()),
            )),
          );
        }
      }
    }
  }

  void _increaseRadius() {
    setState(() {
      _currentZoneRadius = (_currentZoneRadius + _radiusStep).clamp(_minRadius, _maxRadius);
      _updateZoneLayer();
      // Removed _fitBounds(_getAllMapPoints()) to decouple radius from zoom
      debugPrint('Zone: Radius increased to: [0m$_currentZoneRadius');
    });
  }

  void _decreaseRadius() {
    setState(() {
      _currentZoneRadius = (_currentZoneRadius - _radiusStep).clamp(_minRadius, _maxRadius);
      _updateZoneLayer();
      // Removed _fitBounds(_getAllMapPoints()) to decouple radius from zoom
      debugPrint('Zone: Radius decreased to: [0m$_currentZoneRadius');
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadAllMapData() async {
    _contacts = _contactBox.getAll();
    _churches = _churchBox.getAll();
    _ministries = _ministryBox.getAll();
    _areas = _areaBox.getAll();
    _streets = _streetBox.getAll();
    _zones = _zoneBox.getAll();
    debugPrint('Zone: Loaded map data, zones: ${_zones.length}');
  }

  Future<void> _setupLayers() async {
    if (!_mapReady || !mounted) return;
    final allPoints = <LatLng>[];
    allPoints.add(_currentZoneCenter);

    _markers.clear();
    _polylines.clear();
    _polygons.clear();
    _circleMarkers.clear();
    if (_showContacts) {
      _markers.addAll(_contacts.where((c) => c.latitude != null && c.longitude != null).map(
            (contact) => fm.Marker(
              point: LatLng(contact.latitude!, contact.longitude!),
              width: 40.0,
              height: 40.0,
              child: Image.asset('lib/features/go/assets/images/marker_person.png'),
            ),
          ));
    }
    if (_showChurches) {
      _markers.addAll(_churches.where((c) => c.latitude != null && c.longitude != null).map(
            (church) => fm.Marker(
              point: LatLng(church.latitude!, church.longitude!),
              width: 40.0,
              height: 40.0,
              child: Image.asset('lib/features/go/assets/images/marker_church.png'),
            ),
          ));
    }
    if (_showMinistries) {
      _markers.addAll(_ministries.where((m) => m.latitude != null && m.longitude != null).map(
            (ministry) => fm.Marker(
              point: LatLng(ministry.latitude!, ministry.longitude!),
              width: 40.0,
              height: 40.0,
              child: Image.asset('lib/features/go/assets/images/marker_ministry.png'),
            ),
          ));
    }
    if (_showStreets) {
      _polylines.addAll(_streets.map((street) => fm.Polyline(
            points: street.points,
            color: Colors.red,
            strokeWidth: 3.0,
          )));
    }
    if (_showAreas) {
      _polygons.addAll(_areas.map((area) => fm.Polygon(
            points: area.points,
            color: Colors.blue.withOpacity(0.3),
            borderColor: Colors.blue,
            borderStrokeWidth: 2.0,
          )));
    }
    if (_showZones) {
      _circleMarkers.addAll(_zones.map((zone) => fm.CircleMarker(
            point: zone.center,
            radius: zone.widthInMeters,
            color: Colors.purple.withOpacity(0.2),
            borderColor: Colors.purple,
            borderStrokeWidth: 2.0,
            useRadiusInMeter: true,
          )));
    }

    if (mounted) {
      setState(() {
        _layerUpdateKey++;
        debugPrint('Zone: Setup layers, circleMarkers: ${_circleMarkers.length}, markers: ${_markers.length}');
      });
    }
    _fitBounds(_getAllMapPoints());
  }

  List<LatLng> _getAllMapPoints() {
    final allPoints = <LatLng>[];
    allPoints.add(_currentZoneCenter);
    if (_showContacts) {
      allPoints.addAll(_contacts.where((c) => c.latitude != null && c.longitude != null).map((c) => LatLng(c.latitude!, c.longitude!)));
    }
    if (_showChurches) {
      allPoints.addAll(_churches.where((c) => c.latitude != null && c.longitude != null).map((c) => LatLng(c.latitude!, c.longitude!)));
    }
    if (_showMinistries) {
      allPoints.addAll(_ministries.where((m) => m.latitude != null && m.longitude != null).map((m) => LatLng(m.latitude!, m.longitude!)));
    }
    if (_showAreas) {
      allPoints.addAll(_areas.expand((a) => a.points));
    }
    if (_showStreets) {
      allPoints.addAll(_streets.expand((s) => s.points));
    }
    if (_showZones) {
      allPoints.addAll(_zones.map((z) => z.center));
    }
    return allPoints;
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
                      t.go_add_edit_zone_screen.contacts,
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
                      t.go_add_edit_zone_screen.churches,
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
                      t.go_add_edit_zone_screen.ministries,
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
                      t.go_add_edit_zone_screen.areas,
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
                      t.go_add_edit_zone_screen.streets,
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
                      t.go_add_edit_zone_screen.zones,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.zone != null
              ? (widget.isViewMode
                  ? t.go_add_edit_zone_screen.view
                  : t.go_add_edit_zone_screen.edit)
              : t.go_add_edit_zone_screen.add) + ' Zone',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showHideOptions,
            tooltip: t.go_add_edit_zone_screen.hide_options,
          ),
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveZoneDialog,
              tooltip: t.go_add_edit_zone_screen.save,
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: _currentZoneCenter,
              initialZoom: widget.zone != null ? 12.0 : (widget.initialZoom ?? 2.0),
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                errorTileCallback: (tile, error, stackTrace) {
                  debugPrint('Zone: Tile loading error: $error');
                },
              ),
              if (_showZones && _circleMarkers.isNotEmpty)
                fm.CircleLayer(
                  key: ValueKey<String>('circle_layer_$_layerUpdateKey'),
                  circles: _circleMarkers,
                ),
              if (!widget.isViewMode)
                DragMarkers(
                  markers: [
                    DragMarker(
                      point: _currentZoneCenter,
                      size: const Size(40.0, 40.0),
                      offset: const Offset(-20.0, -20.0),
                      builder: (context, point, isDragging) => const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                      onDragEnd: (details, point) {
                        setState(() {
                          _currentZoneCenter = LatLng(
                            point.latitude.clamp(-90.0, 90.0),
                            point.longitude.clamp(-180.0, 180.0),
                          );
                          _updateZoneLayer();
                          _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
                          debugPrint('Zone: Marker dragged to: $_currentZoneCenter');
                        });
                      },
                    ),
                  ],
                ),
              if (_showChurches || _showContacts || _showMinistries)
                fm.MarkerLayer(
                  markers: _markers,
                ),
              if (_showAreas)
                fm.PolygonLayer(
                  polygons: _polygons,
                ),
              if (_showStreets)
                fm.PolylineLayer(
                  polylines: _polylines,
                ),
              fm.RichAttributionWidget(
                attributions: [
                  fm.TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => debugPrint('Zone: Attribution tapped'),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoomInBtn',
                  onPressed: () {
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
                  },
                  child: const Icon(Icons.add),
                  tooltip: t.go_add_edit_zone_screen.zoom_in,
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton.small(
                  heroTag: 'zoomOutBtn',
                  onPressed: () {
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
                  },
                  child: const Icon(Icons.remove),
                  tooltip: t.go_add_edit_zone_screen.zoom_out,
                ),
                const SizedBox(height: 16.0),
                if (!widget.isViewMode)
                  FloatingActionButton.small(
                    heroTag: 'increaseRadiusBtn',
                    onPressed: _increaseRadius,
                    child: const Icon(Icons.add_circle_outline),
                    tooltip: t.go_add_edit_zone_screen.increase_radius,
                  ),
                const SizedBox(height: 8.0),
                if (!widget.isViewMode)
                  FloatingActionButton.small(
                    heroTag: 'decreaseRadiusBtn',
                    onPressed: _decreaseRadius,
                    child: const Icon(Icons.remove_circle_outline),
                    tooltip: t.go_add_edit_zone_screen.decrease_radius,
                  ),
                const SizedBox(height: 16.0),
                if (!widget.isViewMode)
                  FloatingActionButton(
                    heroTag: 'setCenterBtn',
                    onPressed: () {
                      setState(() {
                        _currentZoneCenter = _mapController.mapController.camera.center;
                        _updateZoneLayer();
                        _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
                        debugPrint('Zone: Center set to: $_currentZoneCenter');
                      });
                    },
                    child: const Icon(Icons.center_focus_strong),
                    tooltip: t.go_add_edit_zone_screen.set_center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}