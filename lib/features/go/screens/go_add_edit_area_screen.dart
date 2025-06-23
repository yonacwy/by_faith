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
import 'package:by_faith/features/go/providers/font_provider.dart';

class GoAddEditAreaScreen extends StatefulWidget {
  final GoArea? area;
  final bool isViewMode;
  final LatLng? initialCenter;
  final double? initialZoom;

  const GoAddEditAreaScreen({Key? key, this.area, this.isViewMode = false, this.initialCenter, this.initialZoom}) : super(key: key);

  @override
  _GoAddEditAreaScreenState createState() => _GoAddEditAreaScreenState();
}

class _GoAddEditAreaScreenState extends State<GoAddEditAreaScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoArea> _areaBox;
  PolyEditor? _polyEditor;
  List<fm.Polygon> _polygons = [];
  fm.Polygon? _tempPolygon;
  String _areaName = '';
  Timer? _debounceTimer;
  bool _didInitAreaMode = false;
  bool _didLoadMapData = false;
  int _layerUpdateKey = 0;
  List<fm.Marker> _markers = [];
  List<fm.CircleMarker> _circleMarkers = [];
  List<fm.Polyline> _polylines = [];

  // ObjectBox Boxes for other map elements
  late Box<GoContact> _contactBox;
  late Box<GoChurch> _churchBox;
  late Box<GoMinistry> _ministryBox;
  late Box<GoStreet> _streetBox;
  late Box<GoZone> _zoneBox;

  // Lists to hold fetched data
  List<GoContact> _contacts = [];
  List<GoChurch> _churches = [];
  List<GoMinistry> _ministries = [];
  List<GoStreet> _streets = [];
  List<GoZone> _zones = [];
  List<GoArea> _areas = [];

  bool _showContacts = true;
  bool _showChurches = true;
  bool _showMinistries = true;
  bool _showAreas = true;
  bool _showStreets = true;
  bool _showZones = true;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _areaBox = store.box<GoArea>();
    _contactBox = store.box<GoContact>();
    _churchBox = store.box<GoChurch>();
    _ministryBox = store.box<GoMinistry>();
    _streetBox = store.box<GoStreet>();
    _zoneBox = store.box<GoZone>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadMapData) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadAllMapData();
        if (!_didInitAreaMode) {
          _startAreaMode();
          _didInitAreaMode = true;
        }
        await _setupLayers();
        _didLoadMapData = true;
        debugPrint('Area: didChangeDependencies completed, polygons: ${_polygons.length}');
      });
    }
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _startAreaMode() {
    _polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: [],
      pointIcon: const Icon(Icons.circle, size: 12, color: Colors.red),
      intermediateIcon: const Icon(Icons.circle, size: 8, color: Colors.blue),
      callbackRefresh: (LatLng? latLng) {
        _debounce(() {
          if (mounted) {
            setState(() {
              _updateTempAreaLayers();
              _layerUpdateKey++;
              debugPrint('Area: PolyEditor callback, polygons: ${_polygons.length}, points: ${_polyEditor!.points.length}');
            });
          }
        });
      },
    );

    if (widget.area != null) {
      _loadExistingArea();
    }

    if (!widget.isViewMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tap on the map to add points for Area.'),
            action: SnackBarAction(
              label: 'Cancel',
              onPressed: _cancelAreaMode,
            ),
          ),
        );
      });
    }
    debugPrint('Area: Started area mode, polyEditor initialized');
  }

  void _loadExistingArea() {
    if (widget.area != null) {
      _areaName = widget.area!.name;
      _polyEditor!.points.addAll(widget.area!.points);
      _updateTempAreaLayers();
      // Fit bounds after loading existing area points
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds(_getAllMapPoints());
      });
      setState(() {
        _layerUpdateKey++;
        debugPrint('Area: Loaded existing area, points: ${_polyEditor!.points.length}, polygons: ${_polygons.length}');
      });
    }
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      final center = widget.initialCenter ?? const LatLng(39.0, -98.0);
      final zoom = widget.initialZoom ?? 2.0;
      _mapController.animateTo(dest: center, zoom: zoom);
      debugPrint('Area: No points, reset to initial or default view (center: \\$center, zoom: \\$zoom)');
      return;
    }

    final bounds = fm.LatLngBounds.fromPoints(points);
    final cameraFit = fm.CameraFit.bounds(
      bounds: bounds,
      padding: padding ?? const EdgeInsets.all(20.0),
    );
    final targetCamera = cameraFit.fit(_mapController.mapController.camera);

    debugPrint('Area: Fitting bounds, points: ${points.length}, center: ${targetCamera.center}, zoom: ${targetCamera.zoom}');

    _mapController.animateTo(
      dest: targetCamera.center,
      zoom: targetCamera.zoom,
    );
  }

  void _updateTempAreaLayers() {
    _polygons.clear();
    if (_polyEditor!.points.length >= 3) {
      _tempPolygon = fm.Polygon(
        points: List<LatLng>.from(_polyEditor!.points),
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2.0,
      );
      _polygons.add(_tempPolygon!);
    } else {
      _tempPolygon = null;
    }
    debugPrint('Area: Updated temp layers, polygons: ${_polygons.length}, points: ${_polyEditor!.points.length}');
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (!widget.isViewMode) {
      _addAreaPoint(latLng);
    }
  }

  void _addAreaPoint(LatLng point) {
    _polyEditor!.add(_polyEditor!.points, point);
    _debounce(() {
      if (mounted) {
        setState(() {
          _updateTempAreaLayers();
          _layerUpdateKey++;
          debugPrint('Area: Added point, points: ${_polyEditor!.points.length}, polygons: ${_polygons.length}');
          // Fit bounds after adding a point, considering all visible layers
          _fitBounds(_getAllMapPoints());
        });
      }
    });
  }

  void _cancelAreaMode() async {
    if (_polyEditor?.points.isNotEmpty ?? false) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Cancel Area Creation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                ),
          ),
          content: Text(
            'Discard changes to this area?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Keep Editing',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Discard',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
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

  void _showSaveAreaDialog() async {
    if (widget.isViewMode) {
      Navigator.pop(context);
      return;
    }

    if (_polyEditor!.points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 3 points to create an area.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _areaName.isEmpty && _polyEditor!.points.isNotEmpty
          ? 'Area ${_polyEditor!.points[0].latitude.toStringAsFixed(2)},${_polyEditor!.points[0].longitude.toStringAsFixed(2)}'
          : _areaName,
    );

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${widget.area != null ? 'Edit' : 'Save'} Area',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
              ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Enter name',
            labelText: 'Name',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Name cannot be empty.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                          ),
                    ),
                  ),
                );
                return;
              }
              Navigator.pop(context, nameController.text.trim());
            },
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  ),
            ),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final area = GoArea(
          name: name,
          latitudes: _polyEditor!.points.map((p) => p.latitude).toList(),
          longitudes: _polyEditor!.points.map((p) => p.longitude).toList(),
        );
        if (widget.area != null) {
          area.id = widget.area!.id;
        }

        _areaBox.put(area);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Area saved successfully.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
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
                'Error saving Area: $e',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
              ),
            ),
          );
        }
      }
    }
  }

  void _removeLastAreaPoint() {
    if (_polyEditor != null && _polyEditor!.points.isNotEmpty) {
      _polyEditor!.points.removeLast();
      _debounce(() {
        if (mounted) {
          setState(() {
            _updateTempAreaLayers();
            _layerUpdateKey++;
            debugPrint('Area: Removed point, points: ${_polyEditor!.points.length}, polygons: ${_polygons.length}');
            // Fit bounds after removing a point, considering all visible layers
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
    _streets = _streetBox.getAll();
    _zones = _zoneBox.getAll();
    _areas = _areaBox.getAll();
    debugPrint('Area: Loaded map data, areas: ${_areas.length}');
  }

  Future<void> _setupLayers() async {
    final allPoints = <LatLng>[];
    if (_polyEditor != null) {
      allPoints.addAll(_polyEditor!.points);
    }

    _markers.clear();
    _polylines.clear();
    _circleMarkers.clear();
    _polygons.clear(); // Clear polygons here before adding all layers

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
    if (_showAreas) {
      _polygons.addAll(_areas.map((area) => fm.Polygon(
            points: area.points,
            color: Colors.blue.withOpacity(0.3),
            borderColor: Colors.blue,
            borderStrokeWidth: 2.0,
          )));
    }
    // _updateTempAreaLayers() is called within the PolyEditor callback, no need to call here
    // It's also called in _addAreaPoint and _removeLastAreaPoint

    if (mounted) {
      setState(() {
        _layerUpdateKey++;
        debugPrint('Area: Setup layers, polygons: ${_polygons.length}, markers: ${_markers.length}');
      });
    }
    // Fit bounds after all layers are set up
    _fitBounds(_getAllMapPoints());
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
        title: Text('${widget.area != null ? (widget.isViewMode ? 'View' : 'Edit') : 'Add'} Area'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showHideOptions,
            tooltip: 'Hide Options',
          ),
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveAreaDialog,
              tooltip: 'Save Area',
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: widget.initialCenter ?? (widget.area != null && widget.area!.points.isNotEmpty ? widget.area!.points.first : const LatLng(39.0, -98.0)),
              initialZoom: widget.initialZoom ?? (widget.area != null && widget.area!.points.isNotEmpty ? 12.0 : 2.0),
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_showAreas && _polygons.isNotEmpty)
                fm.PolygonLayer(
                  key: ValueKey<String>('polygon_layer_$_layerUpdateKey'),
                  polygons: _polygons,
                ),
              if (!widget.isViewMode && _polyEditor != null)
                DragMarkers(
                  markers: _polyEditor!.edit(),
                ),
              if (_showChurches || _showContacts || _showMinistries)
                fm.MarkerLayer(
                  markers: _markers,
                ),
              if (_showStreets)
                fm.PolylineLayer(
                  polylines: _polylines,
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
                      _addAreaPoint(_mapController.mapController.camera.center);
                    },
                    child: const Icon(Icons.add_location_alt),
                  ),
                const SizedBox(height: 8.0),
                if (!widget.isViewMode && (_polyEditor?.points.isNotEmpty ?? false))
                  FloatingActionButton(
                    heroTag: 'removePointBtn',
                    onPressed: _removeLastAreaPoint,
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