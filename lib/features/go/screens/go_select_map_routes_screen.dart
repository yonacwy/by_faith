import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_polywidget/flutter_map_polywidget.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class GoSelectMapRoutesScreen extends StatefulWidget {
  final String selectionType; // 'Area', 'Street', or 'Tag'
  final Object? existingItem;
  final bool isEditMode;
  final bool isViewMode;
  final Function(dynamic) onSave;

  const GoSelectMapRoutesScreen({
    super.key,
    required this.selectionType,
    required this.onSave,
    this.existingItem,
    this.isEditMode = false,
    this.isViewMode = false,
  });

  @override
  State<GoSelectMapRoutesScreen> createState() => _GoSelectMapRoutesScreenState();
}

class _GoSelectMapRoutesScreenState extends State<GoSelectMapRoutesScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  late PolyEditor _polyEditor;
  final List<fm.Polyline> _polylines = [];
  final List<fm.Polygon> _polygons = [];
  final List<PolyWidget> _polyWidgets = [];
  LatLng _currentCenter = const LatLng(35.4334, -83.8007); // Robbinsville, NC
  double _currentZoom = 10.0;
  final String _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  String _name = '';
  String _tagText = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _polyEditor = PolyEditor(
      addClosePathMarker: widget.selectionType == 'Area',
      points: [],
      pointIcon: const Icon(Icons.circle, size: 12, color: Colors.red),
      intermediateIcon: const Icon(Icons.circle, size: 8, color: Colors.blue),
      callbackRefresh: (LatLng? latLng) {
        // Debounce state updates during drag
        _debounce(() {
          if (mounted) {
            setState(() {
              _updateMapLayers();
            });
          }
        });
      },
    );
  }

  // Debounce function to limit state updates
  void _debounce(VoidCallback callback) {
    const debounceDuration = Duration(milliseconds: 500);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, callback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.existingItem != null && _polyWidgets.isEmpty && _polyEditor.points.isEmpty) {
      _loadExistingItem();
    }
  }

  void _loadExistingItem() {
    try {
      if (widget.existingItem is GoArea) {
        final area = widget.existingItem as GoArea;
        _name = area.name;
        for (final point in area.points) {
          _polyEditor.add(_polyEditor.points, point);
        }
        if (_polyEditor.points.isNotEmpty) {
          _currentCenter = _polyEditor.points[0];
          _currentZoom = 12.0;
        }
        _updateMapLayers();
      } else if (widget.existingItem is GoStreet) {
        final street = widget.existingItem as GoStreet;
        _name = street.name;
        for (final point in street.points) {
          _polyEditor.add(_polyEditor.points, point);
        }
        if (_polyEditor.points.isNotEmpty) {
          _currentCenter = _polyEditor.points[0];
          _currentZoom = 12.0;
        }
        _updateMapLayers();
      } else if (widget.existingItem is GoTag) {
        final tag = widget.existingItem as GoTag;
        _name = tag.name;
        _tagText = tag.text;
        _polyWidgets.add(PolyWidget(
          center: tag.center,
          widthInMeters: tag.widthInMeters,
          heightInMeters: tag.heightInMeters,
          child: Container(
            color: Colors.white.withOpacity(0.8),
            alignment: Alignment.center,
            child: Text(
              tag.text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
        _currentCenter = tag.center;
        _currentZoom = 14.0;
      }
      // Defer map animation until after the first frame is rendered
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (widget.selectionType == 'Street' && _polyEditor.points.isNotEmpty) {
            // Calculate bounds from points
            final southwest = _polyEditor.points.reduce((a, b) => LatLng(
                  a.latitude < b.latitude ? a.latitude : b.latitude,
                  a.longitude < b.longitude ? a.longitude : b.longitude,
                ));
            final northeast = _polyEditor.points.reduce((a, b) => LatLng(
                  a.latitude > b.latitude ? a.latitude : b.latitude,
                  a.longitude > b.longitude ? a.longitude : b.longitude,
                ));
            // Calculate center and zoom to fit bounds
            final center = LatLng(
              (southwest.latitude + northeast.latitude) / 2,
              (southwest.longitude + northeast.longitude) / 2,
            );
            // Approximate zoom level based on bounds (adjust as needed)
            final latDiff = (northeast.latitude - southwest.latitude).abs();
            final lngDiff = (northeast.longitude - southwest.longitude).abs();
            final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
            double zoom = 12.0 - (maxDiff * 10).clamp(0.0, 10.0); // Adjust zoom based on span
            zoom = zoom.clamp(2.0, 18.0); // Respect min/max zoom
            _mapController.animateTo(
              dest: center,
              zoom: zoom,
            );
          } else {
            _mapController.animateTo(dest: _currentCenter, zoom: _currentZoom);
          }
        });
      });
    } catch (e) {
      if (mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading item: $e')),
          );
        });
      }
    }
  }

  void _updateMapLayers() {
    _polygons.clear();
    _polylines.clear();
    if (widget.selectionType == 'Area' && _polyEditor.points.length >= 3) {
      _polygons.add(fm.Polygon(
        points: _polyEditor.points,
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2.0,
      ));
    } else if (widget.selectionType == 'Street' && _polyEditor.points.isNotEmpty) {
      _polylines.add(fm.Polyline(
        points: _polyEditor.points,
        color: Colors.red,
        strokeWidth: 4.0,
      ));
    }
  }

  void _addPoint(LatLng point) {
    print('Tapped at: $point');
    print('Selection type: ${widget.selectionType}');
    if (widget.isViewMode) return;
    try {
      if (widget.selectionType == 'Area' || widget.selectionType == 'Street') {
        print('Adding point to polyEditor');
        _polyEditor.add(_polyEditor.points, point);
        _debounce(() {
          if (mounted) {
            setState(() {
              _updateMapLayers();
            });
          }
        });
      } else if (widget.selectionType == 'Tag') {
        print('Adding tag polywidget');
        _debounce(() {
          if (mounted) {
            setState(() {
              _polyWidgets.clear(); // Allow only one tag
              _polyWidgets.add(PolyWidget(
                center: point,
                widthInMeters: 100,
                heightInMeters: 50,
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  alignment: Alignment.center,
                  child: Text(
                    _tagText.isEmpty ? 'New Tag' : _tagText,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ));
              _currentCenter = point;
              _mapController.animateTo(dest: _currentCenter);
            });
          }
        });
      }
    } catch (e) {
      print('Error adding point: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding point: $e')),
        );
      }
    }
  }

  void _showSaveDialog() async {
    if (widget.isViewMode) {
      Navigator.pop(context);
      return;
    }

    if (widget.selectionType == 'Area' && _polyEditor.points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 3 points to create an area.')),
      );
      return;
    }
    if (widget.selectionType == 'Street' && _polyEditor.points.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least 2 points to create a street.')),
      );
      return;
    }
    if (widget.selectionType == 'Tag' && _polyWidgets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a tag to save.')),
      );
      return;
    }

    TextEditingController nameController = TextEditingController(
      text: _name.isEmpty && _polyEditor.points.isNotEmpty
          ? '${widget.selectionType} ${_polyEditor.points[0].latitude.toStringAsFixed(2)},${_polyEditor.points[0].longitude.toStringAsFixed(2)}'
          : _name,
    );
    TextEditingController tagTextController = TextEditingController(text: _tagText.isEmpty ? 'New Tag' : _tagText);

    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          (widget.isEditMode ? t.go_select_map_routes_screen.edit : t.go_select_map_routes_screen.save) +
            ' ' + t.go_select_map_routes_screen[widget.selectionType.toLowerCase()],
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: t.go_select_map_routes_screen.enter_name,
                labelText: t.go_select_map_routes_screen.name,
                hintStyle: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
                labelStyle: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
            if (widget.selectionType == 'Tag')
              TextField(
                controller: tagTextController,
                decoration: InputDecoration(
                  hintText: t.go_select_map_routes_screen.enter_tag_text,
                  labelText: t.go_select_map_routes_screen.tag_text,
                  hintStyle: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                  labelStyle: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_select_map_routes_screen.cancel,
              style: TextStyle(
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
                      t.go_select_map_routes_screen.name_cannot_be_empty,
                      style: TextStyle(
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
              t.go_select_map_routes_screen.save,
              style: TextStyle(
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
        dynamic item;
        if (widget.selectionType == 'Area') {
          item = GoArea(
            name: name,
            latitudes: _polyEditor.points.map((p) => p.latitude).toList(),
            longitudes: _polyEditor.points.map((p) => p.longitude).toList(),
          );
        } else if (widget.selectionType == 'Street') {
          item = GoStreet(
            name: name,
            latitudes: _polyEditor.points.map((p) => p.latitude).toList(),
            longitudes: _polyEditor.points.map((p) => p.longitude).toList(),
          );
        } else if (widget.selectionType == 'Tag') {
          item = GoTag(
            name: name,
            text: tagTextController.text.trim().isEmpty ? 'New Tag' : tagTextController.text.trim(),
            latitude: _polyWidgets.last.center.latitude,
            longitude: _polyWidgets.last.center.longitude,
            widthInMeters: 100,
            heightInMeters: 50,
          );
        }
        if (widget.existingItem != null) {
          item.id = (widget.existingItem as dynamic).id; // Preserve ID for updates
        }
        widget.onSave(item);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving item: $e')),
        );
      }
    }
  }

  void zoomIn() {
    if (widget.isViewMode) return;
    final newZoom = (_mapController.mapController.camera.zoom + 1).clamp(2.0, 18.0);
    _mapController.animateTo(zoom: newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  void zoomOut() {
    if (widget.isViewMode) return;
    final newZoom = (_mapController.mapController.camera.zoom - 1).clamp(2.0, 18.0);
    _mapController.animateTo(zoom: newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.isViewMode
              ? t.go_select_map_routes_screen.view
              : widget.isEditMode
                  ? t.go_select_map_routes_screen.edit
                  : t.go_select_map_routes_screen.select) +
            ' ' + t.go_select_map_routes_screen[widget.selectionType.toLowerCase()],
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          if (!widget.isViewMode)
            IconButton(
              icon: Icon(
                Icons.save,
                size: context.watch<FontProvider>().fontSize * 1.2,
              ),
              onPressed: _showSaveDialog,
              tooltip: t.go_select_map_routes_screen.save,
            ),
        ],
      ),
      body: Stack(
        children: [
          fm.FlutterMap(
            mapController: _mapController.mapController,
            options: fm.MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              minZoom: 2.0,
              maxZoom: 18.0,
              onTap: widget.isViewMode
                  ? null
                  : (_, point) {
                      _addPoint(point);
                    },
              onPositionChanged: (position, hasGesture) {
                if (mounted && position.center != null && position.zoom != null) {
                  setState(() {
                    _currentCenter = position.center!;
                    _currentZoom = position.zoom!;
                  });
                }
              },
            ),
            children: [
              fm.TileLayer(
                urlTemplate: _tileProviderUrl,
              ),
              if (widget.selectionType == 'Area' && _polygons.isNotEmpty)
                fm.PolygonLayer(
                  polygons: _polygons,
                ),
              if (widget.selectionType == 'Street' && _polylines.isNotEmpty)
                fm.PolylineLayer(
                  polylines: _polylines,
                ),
              if (widget.selectionType == 'Tag' && _polyWidgets.isNotEmpty)
                PolyWidgetLayer(
                  polyWidgets: _polyWidgets,
                ),
              if (!widget.isViewMode)
                DragMarkers(
                  markers: _polyEditor.edit(),
                ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: widget.isViewMode ? null : zoomIn,
                  heroTag: 'zoomInBtn',
                  child: Icon(
                    Icons.add,
                    size: context.watch<FontProvider>().fontSize * 1.2,
                  ),
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton(
                  mini: true,
                  onPressed: widget.isViewMode ? null : zoomOut,
                  heroTag: 'zoomOutBtn',
                  child: Icon(
                    Icons.remove,
                    size: context.watch<FontProvider>().fontSize * 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (!widget.isViewMode)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: FloatingActionButton.extended(
                onPressed: _showSaveDialog,
                label: Text(
                  t.go_select_map_routes_screen.save,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                icon: Icon(
                  Icons.save,
                  size: context.watch<FontProvider>().fontSize * 1.2,
                ),
                heroTag: 'saveBtn',
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