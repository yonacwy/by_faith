import 'package:flutter/material.dart';

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
  List<fm.Polyline> _polylines = [];
  String _routeName = '';
  Timer? _debounceTimer;
  int _layerUpdateKey = 0;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _streetBox = store.box<GoStreet>();
    _startRouteMode();
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _startRouteMode() {
    _polyEditor = PolyEditor(
      addClosePathMarker: false, // Streets are polylines, not polygons
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

    if (widget.street != null) {
      _loadExistingRoute();
    }

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
  }

  void _loadExistingRoute() {
    if (widget.street != null) {
      _routeName = widget.street!.name;
      _polyEditor!.points.addAll(widget.street!.points);
      _fitBounds(widget.street!.points);
    }
    _updateTempRouteLayers();
    setState(() {
      _layerUpdateKey++;
    });
  }

  void _fitBounds(List<LatLng> points, {EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
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

  void _updateTempRouteLayers() {
    _polylines.clear();
    if (_polyEditor!.points.isNotEmpty) {
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

    if ((_polyEditor?.points.length ?? 0) < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 points to create a street.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _routeName.isEmpty && _polyEditor != null && _polyEditor!.points.isNotEmpty
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
          Navigator.pop(context); // Pop the add/edit screen
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
      body: fm.FlutterMap(
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
            // Assuming a default online tile provider for now
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
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}