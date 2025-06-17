import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:async';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class GoAddEditAreaScreen extends StatefulWidget {
  final GoArea? area;
  final bool isViewMode;

  const GoAddEditAreaScreen({Key? key, this.area, this.isViewMode = false}) : super(key: key);

  @override
  _GoAddEditAreaScreenState createState() => _GoAddEditAreaScreenState();
}

class _GoAddEditAreaScreenState extends State<GoAddEditAreaScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoArea> _areaBox;
  PolyEditor? _polyEditor;
  List<fm.Polygon> _polygons = [];
  fm.Polygon? _tempPolygon; // Declare _tempPolygon
  String _areaName = '';
  Timer? _debounceTimer;
  bool _didInitAreaMode = false;
  int _layerUpdateKey = 0;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _areaBox = store.box<GoArea>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitAreaMode) {
      _startAreaMode();
      _didInitAreaMode = true;
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
              debugPrint('Area: Updated layers, polygons count: ${_polygons.length}, points: ${_polyEditor!.points.length}');
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
  }

  void _loadExistingArea() {
    if (widget.area != null) {
      _areaName = widget.area!.name;
      _polyEditor!.points.addAll(widget.area!.points);
      _updateTempAreaLayers();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds(widget.area!.points);
      });
      setState(() {
        _layerUpdateKey++; // Increment key when points are loaded
        debugPrint('Area: Loaded existing area, polygons count: ${_polygons.length}');
      });
    }
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      debugPrint('Area: No points, reset to default view');
      return;
    }

    final bounds = fm.LatLngBounds.fromPoints(points);
    final cameraFit = fm.CameraFit.bounds(
      bounds: bounds,
      padding: padding ?? const EdgeInsets.all(20.0),
    );
    final targetCamera = cameraFit.fit(_mapController.mapController.camera);

    debugPrint('Area: Fitting bounds to points: ${points.length}, center: ${targetCamera.center}, zoom: ${targetCamera.zoom}');

    _mapController.animateTo(
      dest: targetCamera.center,
      zoom: targetCamera.zoom,
    );
  }

  void _updateTempAreaLayers() {
    if (_polyEditor!.points.length >= 3) {
      // Update the existing polygon or create a new one if it doesn't exist
      if (_tempPolygon == null) {
        _tempPolygon = fm.Polygon(
          points: _polyEditor!.points,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          borderStrokeWidth: 2.0,
        );
        _polygons = [_tempPolygon!]; // Replace the list with the single polygon
      } else {
        _tempPolygon = fm.Polygon( // Create a new polygon with updated points
          points: _polyEditor!.points,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          borderStrokeWidth: 2.0,
        );
         _polygons[0] = _tempPolygon!; // Update the polygon in the list
      }
    } else {
      _polygons.clear(); // Clear the polygon if not enough points
      _tempPolygon = null;
    }
    debugPrint('Area: Updated temp layers, polygons count: ${_polygons.length}');
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
          _layerUpdateKey++; // Increment key when points are updated
          debugPrint('Area: Added point, total points: ${_polyEditor!.points.length}, polygons: ${_polygons.length}');
          if (_polyEditor!.points.length >= 3) {
            _fitBounds(_polyEditor!.points);
          }
        });
      }
    });
  }

  void _cancelAreaMode() async {
    if (_polyEditor?.points.isNotEmpty ?? false) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Area Creation'),
          content: const Text('Discard changes to this area?'),
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
        title: Text('${widget.area != null ? 'Edit' : 'Save'} Area'),
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
            const SnackBar(content: Text('Area saved successfully.')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving Area: $e')),
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
            _layerUpdateKey++; // Increment key when points are updated
            debugPrint('Area: Removed last point, remaining: ${_polyEditor!.points.length}, polygons: ${_polygons.length}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.area != null ? (widget.isViewMode ? 'View' : 'Edit') : 'Add'} Area'),
        actions: [
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
              initialCenter: widget.area != null && widget.area!.points.isNotEmpty
                  ? widget.area!.points.first
                  : const LatLng(39.0, -98.0),
              initialZoom: widget.area != null && widget.area!.points.isNotEmpty ? 12.0 : 2.0,
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_polygons.isNotEmpty)
                fm.PolygonLayer(
                  key: ValueKey<String>('polygon_layer_$_layerUpdateKey'),
                  polygons: _polygons,
                ),
              if (!widget.isViewMode && _polyEditor != null)
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
          if (!widget.isViewMode)
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
                  FloatingActionButton(
                    heroTag: 'addPointBtn',
                    onPressed: () {
                      _addAreaPoint(_mapController.mapController.camera.center);
                    },
                    child: const Icon(Icons.add_location_alt),
                  ),
                  const SizedBox(height: 8.0),
                  if (_polyEditor?.points.isNotEmpty ?? false)
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