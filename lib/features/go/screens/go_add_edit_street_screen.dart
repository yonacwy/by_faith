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

class GoAddEditStreetScreen extends StatefulWidget {
  final GoStreet? street;
  final bool isViewMode;

  const GoAddEditStreetScreen({
    super.key,
    this.street,
    this.isViewMode = false,
  });

  @override
  State<GoAddEditStreetScreen> createState() => _GoAddEditStreetScreenState();
}

class _GoAddEditStreetScreenState extends State<GoAddEditStreetScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoStreet> _streetBox;
  PolyEditor? _polyEditor;
  fm.Polyline? _tempPolyline;
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

  bool _didLoadMapData = false;
  bool _didInitRouteMode = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadMapData) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadAllMapData();
        if (!_didInitRouteMode) {
          _startRouteMode();
          _didInitRouteMode = true;
        }
        await _setupLayers();
        _didLoadMapData = true;
        if (!widget.isViewMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Tap on the map to add points for Street.'),
              action: SnackBarAction(
                label: 'Cancel',
                onPressed: _cancelRouteMode,
              ),
            ),
          );
        }
        debugPrint('Street: didChangeDependencies completed, polylines: ${_polylines.length}');
      });
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
              _updateTempRouteLayers();
              _layerUpdateKey++;
              debugPrint('Street: Updated layers, polylines: ${_polylines.length}, points: ${_polyEditor!.points.length}');
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
    if (widget.street != null) {
      _routeName = widget.street!.name;
      _polyEditor!.points.addAll(widget.street!.points);
      _updateTempRouteLayers();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds(widget.street!.points);
      });
      setState(() {
        _layerUpdateKey++;
        debugPrint('Street: Loaded existing route, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
      });
    }
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      debugPrint('Street: No points, reset to default view');
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

  void _updateTempRouteLayers() {
    _polylines.clear();
    if (_polyEditor!.points.length >= 2) {
      _tempPolyline = fm.Polyline(
        points: List<LatLng>.from(_polyEditor!.points),
        color: Colors.red,
        strokeWidth: 4.0,
      );
      _polylines.add(_tempPolyline!);
    } else {
      _tempPolyline = null;
    }
    debugPrint('Street: Updated temp layers, polylines: ${_polylines.length}, points: ${_polyEditor!.points.length}');
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (!widget.isViewMode) {
      _addRoutePoint(latLng);
    }
  }

  void _addRoutePoint(LatLng point) {
    _polyEditor!.add(_polyEditor!.points, point);
    _debounce(() {
      if (mounted) {
        setState(() {
          _updateTempRouteLayers();
          _layerUpdateKey++;
          debugPrint('Street: Added point, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
          if (_polyEditor!.points.length >= 2) {
            _fitBounds(_polyEditor!.points);
          }
        });
      }
    });
  }

  void _cancelRouteMode() async {
    if (_polyEditor?.points.isNotEmpty ?? false) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Street Creation'),
          content: const Text('Discard changes to this street?'),
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
      if (confirm != true) return;
    }
    Navigator.pop(context);
  }

  void _showSaveRouteDialog() async {
    if (widget.isViewMode) {
      Navigator.pop(context);
      return;
    }

    if (_polyEditor!.points.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 points to create a street.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _routeName.isEmpty && _polyEditor!.points.isNotEmpty
          ? 'Street ${_polyEditor!.points[0].latitude.toStringAsFixed(2)},${_polyEditor!.points[0].longitude.toStringAsFixed(2)}'
          : _routeName,
    );

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${widget.street != null ? 'Edit' : 'Save'} Street'),
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
        final street = GoStreet(
          name: name,
          latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
          longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
        );
        if (widget.street != null) {
          street.id = widget.street!.id;
        }

        _streetBox.put(street);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Street saved successfully.')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving Street: $e')),
          );
        }
      }
    }
  }

  void _removeLastRoutePoint() {
    if (_polyEditor != null && _polyEditor!.points.isNotEmpty) {
      _polyEditor!.points.removeLast();
      _debounce(() {
        if (mounted) {
          setState(() {
            _updateTempRouteLayers();
            _layerUpdateKey++;
            debugPrint('Street: Removed point, points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
            if (_polyEditor!.points.isNotEmpty) {
              _fitBounds(_polyEditor!.points);
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
    final allPoints = <LatLng>[];
    if (_polyEditor != null) {
      allPoints.addAll(_polyEditor!.points);
    }

    _markers.clear();
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
      _polylines.addAll(_streets.map((street) => fm.Polyline(
            points: street.points,
            color: Colors.red,
            strokeWidth: 3.0,
          )));
    }
    _updateTempRouteLayers();

    if (mounted) {
      setState(() {
        _layerUpdateKey++;
        debugPrint('Street: Setup layers, polylines: ${_polylines.length}, markers: ${_markers.length}');
      });
    }
    if (allPoints.isNotEmpty) {
      _fitBounds(allPoints);
    }
  }

  List<LatLng> _getAllMapPoints() {
    final allPoints = <LatLng>[];
    if (_polyEditor != null) {
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
                    title: const Text('Contacts'),
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
                    title: const Text('Churches'),
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
                    title: const Text('Ministries'),
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
                    title: const Text('Areas'),
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
                    title: const Text('Streets'),
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
                    title: const Text('Zones'),
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
        title: Text('${widget.street != null ? (widget.isViewMode ? 'View' : 'Edit') : 'Add'} Street'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showHideOptions,
            tooltip: 'Hide Options',
          ),
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveRouteDialog,
              tooltip: 'Save Street',
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            key: ValueKey<int>(_layerUpdateKey),
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: widget.street != null && widget.street!.points.isNotEmpty
                  ? widget.street!.points.first
                  : const LatLng(39.0, -98.0),
              initialZoom: widget.street != null && widget.street!.points.isNotEmpty ? 12.0 : 2.0,
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
              interactionOptions: fm.InteractionOptions(
                flags: widget.isViewMode
                    ? fm.InteractiveFlag.all
                    : fm.InteractiveFlag.pinchZoom | fm.InteractiveFlag.drag,
              ),
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_showStreets && _polylines.isNotEmpty)
                fm.PolylineLayer(
                  key: ValueKey<String>('polyline_layer_$_layerUpdateKey'),
                  polylines: _polylines,
                ),
              if (_polyEditor != null && !widget.isViewMode)
                DragMarkers(
                  markers: _polyEditor!.edit(),
                ),
              if (_showChurches || _showContacts || _showMinistries)
                fm.MarkerLayer(
                  markers: _markers,
                ),
              if (_showAreas)
                fm.PolygonLayer(
                  polygons: _polygons,
                ),
              if (_showZones)
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
                  onPressed: () {
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton.small(
                  heroTag: 'zoomOutBtn',
                  onPressed: () {
                    _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 16.0),
                if (!widget.isViewMode)
                  FloatingActionButton(
                    heroTag: 'addPointBtn',
                    onPressed: () {
                      _addRoutePoint(_mapController.mapController.camera.center);
                    },
                    child: const Icon(Icons.add_location_alt),
                  ),
                const SizedBox(height: 8.0),
                if (!widget.isViewMode && (_polyEditor?.points.isNotEmpty ?? false))
                  FloatingActionButton(
                    heroTag: 'removePointBtn',
                    onPressed: _removeLastRoutePoint,
                    child: const Icon(Icons.remove_circle_outline),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}