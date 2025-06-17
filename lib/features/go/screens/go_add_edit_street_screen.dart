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
  fm.Polyline? _tempPolyline; // Use a single polyline object
  List<fm.Polyline> _polylines = []; // Keep the list for the layer, but manage a single temp polyline
  String _routeName = '';
  Timer? _debounceTimer;
  int _layerUpdateKey = 0;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _streetBox = store.box<GoStreet>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startRouteMode();
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
              debugPrint('Street: Updated layers, polylines count: ${_polylines.length}, points: ${_polyEditor!.points.length}');
            });
          }
        });
      },
    );

    if (widget.street != null) {
      _loadExistingRoute();
    }

    if (!widget.isViewMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tap on the map to add points for Street.'),
            action: SnackBarAction(
              label: 'Cancel',
              onPressed: _cancelRouteMode,
            ),
          ),
        );
      });
    }
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
        _layerUpdateKey++; // Increment key when points are loaded
        debugPrint('Street: Loaded existing route, polylines count: ${_polylines.length}');
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

    debugPrint('Street: Fitting bounds to points: ${points.length}, center: ${targetCamera.center}, zoom: ${targetCamera.zoom}');

    _mapController.animateTo(
      dest: targetCamera.center,
      zoom: targetCamera.zoom,
    );
  }

  void _updateTempRouteLayers() {
    if (_polyEditor!.points.length >= 2) {
      // Update the existing polyline or create a new one if it doesn't exist
      if (_tempPolyline == null) {
        _tempPolyline = fm.Polyline(
          points: _polyEditor!.points,
          color: Colors.red,
          strokeWidth: 4.0,
        );
        _polylines = [_tempPolyline!]; // Replace the list with the single polyline
      } else {
        _tempPolyline = fm.Polyline( // Create a new polyline with updated points
          points: _polyEditor!.points,
          color: Colors.red,
          strokeWidth: 4.0,
        );
        _polylines[0] = _tempPolyline!; // Update the polyline in the list
      }
    } else {
      _polylines.clear(); // Clear the polyline if not enough points
      _tempPolyline = null;
    }
    debugPrint('Street: Updated temp layers, polylines count: ${_polylines.length}');
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
          debugPrint('Street: Added point, total points: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
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
      if (!confirm!) return;
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
              Navigator.of(context).pop(nameController.text.trim());
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
            _layerUpdateKey++; // Increment key when points are updated
            debugPrint('Street: Removed last point, remaining: ${_polyEditor!.points.length}, polylines: ${_polylines.length}');
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
        title: Text('${widget.street != null ? (widget.isViewMode ? 'View' : 'Edit') : 'Add'} Street'),
        actions: [
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
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: widget.street != null && widget.street!.points.isNotEmpty
                  ? widget.street!.points.first
                  : const LatLng(39.0, -98.0),
              initialZoom: widget.street != null && widget.street!.points.isNotEmpty ? 12.0 : 2.0,
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_polylines.isNotEmpty)
                fm.PolylineLayer(
                  key: ValueKey<String>('polyline_layer_$_layerUpdateKey'),
                  polylines: _polylines,
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
                      _addRoutePoint(_mapController.mapController.camera.center);
                    },
                    child: const Icon(Icons.add_location_alt),
                  ),
                  const SizedBox(height: 8.0),
                  if (_polyEditor?.points.isNotEmpty ?? false) 
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