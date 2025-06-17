import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'dart:async';
import 'package:flutter_map_animations/flutter_map_animations.dart';

class GoAddEditZoneScreen extends StatefulWidget {
  final GoZone? zone;
  final bool isViewMode;

  const GoAddEditZoneScreen({
    super.key,
    this.zone,
    this.isViewMode = false,
  });

  @override
  State<GoAddEditZoneScreen> createState() => _GoAddEditZoneScreenState();
}

class _GoAddEditZoneScreenState extends State<GoAddEditZoneScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late Box<GoZone> _zoneBox;
  late LatLng _currentZoneCenter;
  late double _currentZoneRadius; // In meters
  String _zoneName = '';
  Timer? _debounceTimer;
  int _layerUpdateKey = 0;

  static const double _minRadius = 50.0; // meters
  static const double _maxRadius = 5000.0; // meters
  static const double _radiusStep = 50.0; // meters

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _zoneBox = store.box<GoZone>();

    if (widget.zone != null) {
      _zoneName = widget.zone!.name;
      _currentZoneCenter = LatLng(
        widget.zone!.latitude.clamp(-90.0, 90.0),
        widget.zone!.longitude.clamp(-180.0, 180.0),
      );
      _currentZoneRadius = widget.zone!.widthInMeters.clamp(_minRadius, _maxRadius);
    } else {
      _currentZoneCenter = const LatLng(39.0, -98.0); // Default center (central USA)
      _currentZoneRadius = 500.0; // Default radius
    }

    // Log initial values for debugging
    debugPrint('Initial Center: $_currentZoneCenter, Radius: $_currentZoneRadius');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateZoneLayer();
    if (widget.zone != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
      });
    }
  }

  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 100);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  void _updateZoneLayer() {
    _debounce(() {
      if (mounted) {
        setState(() {
          _layerUpdateKey++; // Force CircleLayer rebuild
        });
      }
    });
  }

  void _fitBounds(List<LatLng> points, {double? radius, EdgeInsets? padding}) {
    if (points.isEmpty) {
      _mapController.animateTo(dest: const LatLng(39.0, -98.0), zoom: 2.0);
      return;
    }

    try {
      fm.LatLngBounds bounds;
      if (radius != null && points.length == 1) {
        final center = points.first;
        const distance = Distance(); // From latlong2
        // Use a smaller multiplier to prevent overly large bounds
        final offsetDistance = radius * 1.2; // Adjusted for stability
        final northEast = distance.offset(center, offsetDistance, 45);
        final southWest = distance.offset(center, offsetDistance, 225);
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
      });
    } catch (e) {
      debugPrint('Error in _fitBounds: $e');
      _mapController.animateTo(dest: points.first, zoom: 12.0);
    }
  }

  void _handleMapTap(fm.TapPosition tapPosition, LatLng latLng) {
    if (!widget.isViewMode) {
      setState(() {
        _currentZoneCenter = LatLng(
          latLng.latitude.clamp(-90.0, 90.0),
          latLng.longitude.clamp(-180.0, 180.0),
        );
        _updateZoneLayer();
        _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
      });
    }
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
        title: Text('${widget.zone != null ? 'Edit' : 'Save'} Zone'),
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty.')),
                  );
                });
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Zone saved successfully.')),
            );
          });
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving Zone: $e')),
            );
          });
        }
      }
    }
  }

  void _increaseRadius() {
    setState(() {
      _currentZoneRadius = (_currentZoneRadius + _radiusStep).clamp(_minRadius, _maxRadius);
      _updateZoneLayer();
      _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
      debugPrint('Radius increased to: $_currentZoneRadius');
    });
  }

  void _decreaseRadius() {
    setState(() {
      _currentZoneRadius = (_currentZoneRadius - _radiusStep).clamp(_minRadius, _maxRadius);
      _updateZoneLayer();
      _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
      debugPrint('Radius decreased to: $_currentZoneRadius');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.zone != null ? (widget.isViewMode ? 'View' : 'Edit') : 'Add'} Zone'),
        actions: [
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _showSaveZoneDialog,
              tooltip: 'Save Zone',
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: _currentZoneCenter,
              initialZoom: 12.0,
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: _handleMapTap,
            ),
            children: [
              fm.TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                errorTileCallback: (tile, error, stackTrace) {
                  debugPrint('Tile loading error: $error');
                },
              ),
              fm.CircleLayer(
                key: ValueKey<String>('circle_layer_$_layerUpdateKey'),
                circles: [
                  fm.CircleMarker(
                    point: _currentZoneCenter,
                    radius: _currentZoneRadius.clamp(10.0, 10000.0), // Extra safety clamp
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2.0,
                    useRadiusInMeter: true,
                  ),
                ],
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
                          debugPrint('Marker dragged to: $_currentZoneCenter');
                        });
                      },
                    ),
                  ],
                ),
              fm.RichAttributionWidget(
                attributions: [
                  fm.TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => debugPrint('Attribution tapped'),
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _mapController.animateTo(zoom: _mapController.mapController.camera.zoom + 1);
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8.0),
                  FloatingActionButton.small(
                    heroTag: 'zoomOutBtn',
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _mapController.animateTo(zoom: _mapController.mapController.camera.zoom - 1);
                      });
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton.small(
                    heroTag: 'increaseRadiusBtn',
                    onPressed: _increaseRadius,
                    child: const Icon(Icons.add_circle_outline),
                  ),
                  const SizedBox(height: 8.0),
                  FloatingActionButton.small(
                    heroTag: 'decreaseRadiusBtn',
                    onPressed: _decreaseRadius,
                    child: const Icon(Icons.remove_circle_outline),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'setCenterBtn',
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _currentZoneCenter = _mapController.mapController.camera.center;
                          _updateZoneLayer();
                          _fitBounds([_currentZoneCenter], radius: _currentZoneRadius);
                          debugPrint('Center set to: $_currentZoneCenter');
                        });
                      });
                    },
                    child: const Icon(Icons.center_focus_strong),
                  ),
                ],
              ),
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