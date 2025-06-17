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
  String _areaName = '';
  Timer? _debounceTimer;
  bool _didInitAreaMode = false;

  @override
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
      addClosePathMarker: true, // Areas are polygons, so close the path
      points: [],
      pointIcon: const Icon(Icons.circle, size: 12, color: Colors.red),
      intermediateIcon: const Icon(Icons.circle, size: 8, color: Colors.blue),
      callbackRefresh: (LatLng? latLng) {
        _debounce(() {
          if (mounted) {
            setState(() {
              _updateTempAreaLayers();
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
      // Schedule fitting bounds after the map is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds(widget.area!.points);
      });
    }
    _updateTempAreaLayers();
    setState(() {
    });
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      return;
    }

    final bounds = fm.LatLngBounds.fromPoints(points);

    final cameraFit = fm.CameraFit.bounds(
      bounds: bounds,
      padding: padding ?? EdgeInsets.all(20.0),
    );
    final targetCamera = cameraFit.fit(_mapController.mapController.camera);

    _mapController.animateTo(
      dest: targetCamera.center,
      zoom: targetCamera.zoom,
    );
  }

  void _updateTempAreaLayers() {
    _polygons.clear();
    if (_polyEditor!.points.isNotEmpty) {
      _polygons.add(
        fm.Polygon(
          points: _polyEditor!.points,
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          borderStrokeWidth: 2.0,
        ),
      );
    }
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
          if (_polyEditor!.points.length >= 2) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fitBounds(_polyEditor!.points);
            });
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

    if ((_polyEditor?.points.length ?? 0) < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 3 points to create an area.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _areaName.isEmpty && _polyEditor != null && _polyEditor!.points.isNotEmpty
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
          Navigator.pop(context); // Pop the add/edit screen
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
            if (_polyEditor!.points.isNotEmpty) {
              _fitBounds(_polyEditor!.points);
            } else {
              // If no points left, reset map view
              _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
            }
          });
        }
      });
    }
  }

  @override
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
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
                // Assuming a default online tile provider for now
              ),
              if (_polygons.isNotEmpty)
                fm.PolygonLayer(
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
          if (!widget.isViewMode) // Only show controls in add/edit mode
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Zoom Controls
                  FloatingActionButton.small(
                    heroTag: 'zoomInBtn', // Unique tag for hero animation
                    onPressed: () {
                      _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8.0),
                  FloatingActionButton.small(
                    heroTag: 'zoomOutBtn', // Unique tag for hero animation
                    onPressed: () {
                      _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 16.0), // Space between zoom and add/remove controls
                  // Add Point Button
                  FloatingActionButton(
                    heroTag: 'addPointBtn', // Unique tag for hero animation
                    onPressed: () {
                      // Add point at the current map center
                      _addAreaPoint(_mapController.mapController.camera.center);
                    },
                    child: const Icon(Icons.add_location_alt),
                  ),
                  const SizedBox(height: 8.0), // Space between add and remove point button
                  // Remove Point Button (conditional)
                  if (!widget.isViewMode && (_polyEditor?.points.isNotEmpty ?? false))
                    FloatingActionButton(
                      heroTag: 'removePointBtn', // Unique tag for hero animation
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