import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:async';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';

enum LineType { street, river, path }

class GoAddEditStreetScreen extends StatefulWidget {
  final GoStreet? street;
  final bool isViewMode;
  final LatLng? initialCenter;
  final double? initialZoom;

  const GoAddEditStreetScreen({
    super.key,
    this.street,
    this.isViewMode = false,
    this.initialCenter,
    this.initialZoom,
  });

  @override
  State<GoAddEditStreetScreen> createState() => _GoAddEditStreetScreenState();
}

class _GoAddEditStreetScreenState extends State<GoAddEditStreetScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoStreet> _streetBox;
  PolyEditor? _polyEditor;
  List<fm.Polyline> _tempPolylines = [];
  List<fm.Polyline> _polylines = [];
  String _routeName = '';
  Timer? _debounceTimer;
  int _layerUpdateKey = 0;
  List<fm.Marker> _markers = [];
  List<fm.Polygon> _polygons = [];
  List<fm.CircleMarker> _circleMarkers = [];

  late Box<GoContact> _contactBox;
  late Box<GoChurch> _churchBox;
  late Box<GoMinistry> _ministryBox;
  late Box<GoArea> _areaBox;
  late Box<GoZone> _zoneBox;

  List<GoContact> _contacts = [];
  List<GoChurch> _churches = [];
  List<GoMinistry> _ministries = [];
  List<GoArea> _areas = [];
  List<GoZone> _zones = [];
  List<GoStreet> _streets = [];

  bool _showContacts = true;
  bool _showChurches = true;
  bool _showMinistries = true;
  bool _showAreas = true;
  bool _showStreets = true;
  bool _showZones = true;

  LineType _selectedLineType = LineType.street;
  bool _mapReady = false; // Add map ready flag

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _streetBox = store.box<GoStreet>();
    _contactBox = store.box<GoContact>();
    _churchBox = store.box<GoChurch>();
    _ministryBox = store.box<GoMinistry>();
    _areaBox = store.box<GoArea>();
    _zoneBox = store.box<GoZone>();
  }

  // Method to call when the map is ready
  void _onMapReady() async {
    debugPrint('Street: Map ready');
    await _loadAllMapData();
    _startRouteMode();
    await _setupLayers();
    setState(() {
      _mapReady = true;
    });
    // Fit bounds initially after map is ready and layers are set up
    _fitBounds(_getAllMapPoints());

    if (!widget.isViewMode && mounted) { // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.go_add_edit_street_screen.tap_to_add_points,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
              fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
            ),
          ),
          action: SnackBarAction(
            label: t.go_add_edit_street_screen.cancel,
            onPressed: _cancelRouteMode,
          ),
        ),
      );
    }
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _startRouteMode() {
    _polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: [],
      pointIcon: const Icon(Icons.circle, size: 12, color: Colors.red),
      intermediateIcon: const Icon(Icons.circle, size: 8, color: Colors.blue),
      callbackRefresh: (LatLng? latLng) {
        _debounce(() {
          if (mounted) {
            setState(() {
              debugPrint('Street: Updated layers, polylines: ${_polylines.length}, points: ${_polyEditor?.points.length ?? 0}'); // Add null check
            });
          }
        });
      },
    );

    if (widget.street != null) {
      _loadExistingRoute();
    }
    debugPrint('Street: Started route mode, polyEditor initialized');
  }

  void _loadExistingRoute() {
    if (widget.street != null && _polyEditor != null) { // Add null check for _polyEditor
      _routeName = widget.street!.name;
      _polyEditor!.points.addAll(widget.street!.points);
      _selectedLineType = LineType.values.firstWhere(
        (e) => e.toString().split('.').last == (widget.street!.type ?? 'street'),
        orElse: () => LineType.street,
      );
      _updateTempRouteLayers();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return; // Add mounted check
        _fitBounds(_getAllMapPoints());
      });
      setState(() {
        _layerUpdateKey++;
        debugPrint('Street: Loaded existing route, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
      });
    }
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (!_mapReady || !mounted) return; // Only fit bounds if map is ready and widget is mounted

    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      debugPrint('Street: No points, reset to initial or default view (center: ${const LatLng(39.0, -98.0)}, zoom: 2.0)');
      return;
    }

    final bounds = fm.LatLngBounds.fromPoints(points);
    final cameraFit = fm.CameraFit.bounds(
      bounds: bounds,
      padding: padding ?? const EdgeInsets.all(20.0),
    );
    final targetCamera = cameraFit.fit(_mapController.mapController.camera);

    debugPrint('Street: Fitting bounds, points: ${points.length}, center: ${targetCamera.center}, zoom: ${targetCamera.zoom}');

    _mapController.animateTo(
      dest: targetCamera.center,
      zoom: targetCamera.zoom,
    );
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

  void _updateTempRouteLayers() {
    _tempPolylines.clear();
    if (_polyEditor != null && _polyEditor!.points.length >= 2) { // Add null check for _polyEditor
      if (_selectedLineType == LineType.path) {
        _tempPolylines.addAll(_createDashedPolylines(
          _polyEditor!.points,
          Colors.green[700]!, // Use green for path
          Colors.white,
        ));
      } else {
        _tempPolylines.add(fm.Polyline(
          points: List<LatLng>.from(_polyEditor!.points),
          color: _getLineColor(),
          strokeWidth: 4.0,
          borderColor: _getBorderColor(),
          borderStrokeWidth: 2.0,
        ));
      }
    }
    _polylines = List.from(_tempPolylines);
    debugPrint('Street: Updated temp layers, polylines: ${_polylines.length}, points: ${_polyEditor?.points.length ?? 0}'); // Add null check
  }

  Color _getLineColor() {
    switch (_selectedLineType) {
      case LineType.street:
        return Colors.black;
      case LineType.river:
        return Colors.blue[900]!;
      case LineType.path:
        return Colors.green[700]!;
    }
  }

  Color _getBorderColor() {
    switch (_selectedLineType) {
      case LineType.street:
        return Colors.white;
      case LineType.river:
        return Colors.green;
      case LineType.path:
        return Colors.white;
    }
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (!widget.isViewMode && _mapReady && mounted) { // Only handle tap if map is ready and widget is mounted
      _addRoutePoint(latLng);
    }
  }

  void _addRoutePoint(LatLng point) {
    if (_polyEditor != null) { // Add null check for _polyEditor
      _polyEditor!.add(_polyEditor!.points, point);
      _debounce(() {
        if (mounted) {
          setState(() {
            _updateTempRouteLayers();
            _layerUpdateKey++;
            debugPrint('Street: Added point, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
            // Removed _fitBounds(_getAllMapPoints()) to prevent auto-zoom after each point
          });
        }
      });
    }
  }

  void _cancelRouteMode() async {
    if ((_polyEditor?.points.isNotEmpty ?? false) && mounted) { // Add mounted check
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            t.go_add_edit_street_screen.cancel_creation,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                  fontSize: context.watch<GoSettingsFontProvider>().fontSize + 2,
                ),
          ),
          content: Text(
            t.go_add_edit_street_screen.discard_changes,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                  fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                t.go_add_edit_street_screen.keep_editing,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                      fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                t.go_add_edit_street_screen.discard,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                      fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                    ),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }
    if (mounted) { // Add mounted check
      Navigator.pop(context);
    }
  }

  void _showSaveRouteDialog() async {
    if (widget.isViewMode || !mounted) { // Add mounted check
      if (mounted) Navigator.pop(context);
      return;
    }

    if (_polyEditor == null || _polyEditor!.points.length < 2) { // Add null check for _polyEditor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.go_add_edit_street_screen.add_at_least_2_points,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                  fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                ),
          ),
        ),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _routeName.isEmpty && _polyEditor!.points.isNotEmpty
          ? '${_selectedLineType.toString().split('.').last[0].toUpperCase()}${_selectedLineType.toString().split('.').last.substring(1)} ${_polyEditor!.points[0].latitude.toStringAsFixed(2)},${_polyEditor!.points[0].longitude.toStringAsFixed(2)}'
          : _routeName,
    );

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          (widget.street != null ? t.go_add_edit_street_screen.edit : t.go_add_edit_street_screen.save) +
            ' ' + _getLineTypeLabel(_selectedLineType, t),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize + 2,
              ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: t.go_add_edit_street_screen.enter_name,
            labelText: t.go_add_edit_street_screen.name,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                  fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                ),
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                  fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                ),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_add_edit_street_screen.cancel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                    fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t.go_add_edit_street_screen.name_cannot_be_empty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                            fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                          ),
                    ),
                  ),
                );
                return;
              }
              Navigator.pop(context, nameController.text.trim());
            },
            child: Text(
              t.go_add_edit_street_screen.save,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                    fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                  ),
            ),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final street = GoStreet(
          name: name,
          latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
          longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
          type: _selectedLineType.toString().split('.').last,
        );
        if (widget.street != null) {
          street.id = widget.street!.id;
        }

        _streetBox.put(street);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.go_add_edit_street_screen.route_saved_successfully,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                      fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                    ),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.go_add_edit_street_screen.error_saving_route.replaceAll('{error}', e.toString()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                      fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                    ),
              ),
            ),
          );
        }
      }
    }
  }

  void _removeLastRoutePoint() {
    if (_polyEditor != null && _polyEditor!.points.isNotEmpty && mounted) { // Add mounted check
      _polyEditor!.points.removeLast();
      _debounce(() {
        if (mounted) {
          setState(() {
            _updateTempRouteLayers();
            _layerUpdateKey++;
            debugPrint('Street: Removed point, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
            if (_polyEditor!.points.isNotEmpty) {
              _fitBounds(_getAllMapPoints());
            } else {
              _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
            }
          });
        }
      });
    }
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
    _zones = _zoneBox.getAll();
    _streets = _streetBox.getAll();
    debugPrint('Street: Loaded map data, streets: ${_streets.length}');
  }

  Future<void> _setupLayers() async {
    if (!_mapReady || !mounted) return; // Add map ready and mounted checks

    final allPoints = <LatLng>[];
    if (_polyEditor != null) { // Add null check for _polyEditor
      allPoints.addAll(_polyEditor!.points);
    }

    _markers.clear();
    _polygons.clear();
    _circleMarkers.clear();
    _polylines.clear();

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
    if (_showStreets) {
      _polylines.addAll(_streets.expand((street) {
        final lineType = LineType.values.firstWhere(
          (e) => e.toString().split('.').last == (street.type ?? 'street'),
          orElse: () => LineType.street,
        );
        if (lineType == LineType.path) {
          return _createDashedPolylines(
            street.points,
            Colors.green[700]!, // Use green for path
            Colors.white,
          );
        } else {
          return [
            fm.Polyline(
              points: street.points,
              color: lineType == LineType.street ? Colors.black : Colors.blue[900]!,
              strokeWidth: 4.0,
              borderColor: lineType == LineType.street ? Colors.white : Colors.green,
              borderStrokeWidth: 2.0,
            )
          ];
        }
      }));
    }
    _polylines.addAll(_tempPolylines);

    if (mounted) {
      setState(() {
        _layerUpdateKey++;
        debugPrint('Street: Setup layers, polylines: ${_polylines.length}, markers: ${_markers.length}');
      });
    }
    _fitBounds(_getAllMapPoints());
  }

  List<LatLng> _getAllMapPoints() {
    final allPoints = <LatLng>[];
    if (_polyEditor != null) { // Add null check for _polyEditor
      allPoints.addAll(_polyEditor!.points);
    }
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
                      t.go_add_edit_street_screen.contacts,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showContacts,
                      onChanged: (value) {
                        modalSetState(() {
                          _showContacts = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      t.go_add_edit_street_screen.churches,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showChurches,
                      onChanged: (value) {
                        modalSetState(() {
                          _showChurches = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      t.go_add_edit_street_screen.ministries,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showMinistries,
                      onChanged: (value) {
                        modalSetState(() {
                          _showMinistries = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      t.go_add_edit_street_screen.areas,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showAreas,
                      onChanged: (value) {
                        modalSetState(() {
                          _showAreas = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      t.go_add_edit_street_screen.streets,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showStreets,
                      onChanged: (value) {
                        modalSetState(() {
                          _showStreets = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      t.go_add_edit_street_screen.zones,
                      style: TextStyle(
                        fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                        fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                      ),
                    ),
                    trailing: Switch(
                      value: _showZones,
                      onChanged: (value) {
                        modalSetState(() {
                          _showZones = value;
                          if (_mapReady) _setupLayers(); // Add map ready check
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
          widget.street != null
              ? (widget.isViewMode
                  ? t.go_add_edit_street_screen.view_street_title
                  : t.go_add_edit_street_screen.edit_street_title)
              : t.go_add_edit_street_screen.add_street_title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showHideOptions,
            tooltip: t.go_add_edit_street_screen.hide_options,
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _mapReady ? () => _fitBounds(_getAllMapPoints()) : null, // Add map ready check
            tooltip: 'Fit to points',
          ),
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _mapReady ? _showSaveRouteDialog : null, // Add map ready check
              tooltip: t.go_add_edit_street_screen.save_street,
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: widget.initialCenter ?? (widget.street != null && widget.street!.points.isNotEmpty ? widget.street!.points.first : const LatLng(39.0, -98.0)),
              initialZoom: widget.initialZoom ?? (widget.street != null && widget.street!.points.isNotEmpty ? 12.0 : 2.0),
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
              onMapReady: _onMapReady, // Add onMapReady callback
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_showStreets && _polylines.isNotEmpty)
                fm.PolylineLayer(
                  key: ValueKey<String>('polyline_layer_$_layerUpdateKey'),
                  polylines: _polylines,
                ),
              if (!widget.isViewMode && _polyEditor != null && _mapReady) // Add map ready check
                DragMarkers(
                  markers: _polyEditor!.edit(),
                ),
              if (_showChurches || _showContacts || _showMinistries)
                fm.MarkerLayer(
                  markers: _markers,
                ),
              if (_showAreas && _polygons.isNotEmpty)
                fm.PolygonLayer(
                  polygons: _polygons,
                ),
              if (_showZones && _circleMarkers.isNotEmpty)
                fm.CircleLayer(
                  circles: _circleMarkers,
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
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoomInBtn',
                  onPressed: _mapReady ? () { // Add map ready check
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
                  } : null,
                  child: const Icon(Icons.add),
                  tooltip: t.go_add_edit_street_screen.zoom_in,
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton.small(
                  heroTag: 'zoomOutBtn',
                  onPressed: _mapReady ? () { // Add map ready check
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
                  } : null,
                  child: const Icon(Icons.remove),
                  tooltip: t.go_add_edit_street_screen.zoom_out,
                ),
                const SizedBox(height: 16.0),
                if (!widget.isViewMode)
                  FloatingActionButton(
                    heroTag: 'addPointBtn',
                    onPressed: _mapReady ? () { // Add map ready check
                      _addRoutePoint(_mapController.mapController.camera.center);
                    } : null,
                    child: const Icon(Icons.add_location_alt),
                    tooltip: t.go_add_edit_street_screen.add_point,
                  ),
                const SizedBox(height: 8.0),
                if (!widget.isViewMode && (_polyEditor?.points.isNotEmpty ?? false))
                  FloatingActionButton(
                    heroTag: 'removePointBtn',
                    onPressed: _mapReady ? _removeLastRoutePoint : null, // Add map ready check
                    child: const Icon(Icons.remove_circle_outline),
                    tooltip: t.go_add_edit_street_screen.remove_point,
                  ),
              ],
            ),
          ),
          if (!widget.isViewMode)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'streetBtn',
                    backgroundColor: _selectedLineType == LineType.street ? Colors.grey[300] : null,
                    onPressed: _mapReady ? () { // Add map ready check
                      setState(() {
                        _selectedLineType = LineType.street;
                        _updateTempRouteLayers();
                        _layerUpdateKey++;
                      });
                    } : null,
                    child: const Icon(Icons.directions),
                    tooltip: t.go_add_edit_street_screen.street,
                  ),
                  const SizedBox(height: 8.0),
                  FloatingActionButton.small(
                    heroTag: 'riverBtn',
                    backgroundColor: _selectedLineType == LineType.river ? Colors.grey[300] : null,
                    onPressed: _mapReady ? () { // Add map ready check
                      setState(() {
                        _selectedLineType = LineType.river;
                        _updateTempRouteLayers();
                        _layerUpdateKey++;
                      });
                    } : null,
                    child: const Icon(Icons.water),
                    tooltip: t.go_add_edit_street_screen.river,
                  ),
                  const SizedBox(height: 8.0),
                  FloatingActionButton.small(
                    heroTag: 'pathBtn',
                    backgroundColor: _selectedLineType == LineType.path ? Colors.grey[300] : null,
                    onPressed: _mapReady ? () { // Add map ready check
                      setState(() {
                        _selectedLineType = LineType.path;
                        _updateTempRouteLayers();
                        _layerUpdateKey++;
                      });
                    } : null,
                    child: const Icon(Icons.hiking),
                    tooltip: t.go_add_edit_street_screen.path,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Add this helper function near the top-level of the file (outside the widget class):
String _getLineTypeLabel(LineType type, dynamic t) {
  switch (type) {
    case LineType.street:
      return t.go_add_edit_street_screen.street;
    case LineType.river:
      return t.go_add_edit_street_screen.river;
    case LineType.path:
      return t.go_add_edit_street_screen.path;
  }
}