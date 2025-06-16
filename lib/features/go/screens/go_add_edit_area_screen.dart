import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';

class GoAddEditAreaScreen extends StatefulWidget {
  final GoArea? area;
  final bool isViewMode;

  const GoAddEditAreaScreen({Key? key, this.area, this.isViewMode = false}) : super(key: key);

  @override
  _GoAddEditAreaScreenState createState() => _GoAddEditAreaScreenState();
}

class _GoAddEditAreaScreenState extends State<GoAddEditAreaScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late Box<GoArea> _areaBox;
  late AnimatedMapController _mapController;
  late LatLng _center;
  late double _radius;
  late double _zoom;
  fm.CircleMarker? _circleMarker;
  DragMarker? _dragMarker;
  fm.Polygon? _polygon;

  @override
  void initState() {
    super.initState();
    _areaBox = store.box<GoArea>();
    _nameController = TextEditingController(text: widget.area?.name ?? '');
    _mapController = AnimatedMapController(vsync: this);
    _center = widget.area != null && widget.area!.points.isNotEmpty
        ? widget.area!.points.first
        : const LatLng(39.0, -98.0);
    _zoom = widget.area != null ? 12.0 : 2.0;
    _updatePolygon();
  }

  void _updatePolygon() {
    setState(() {
      _polygon = fm.Polygon(
        points: [_center], // For now, just the center. Will be expanded later.
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2.0,
      );
      _dragMarker = DragMarker(
        point: _center,
        size: const Size(24.0, 24.0),
        builder: (context, point, isDragging) {
          return widget.isViewMode
              ? const Icon(Icons.location_on, color: Colors.red, size: 24.0)
              : const Icon(Icons.location_on, color: Colors.red, size: 24.0);
        },
        onDragEnd: (details, newPoint) {
          setState(() {
            _center = newPoint;
            _updatePolygon();
            _updatePolygon();
          });
        },
      );
    });
  }



  void _saveArea() {
    if (_formKey.currentState!.validate()) {
      final area = widget.area ?? GoArea(name: '', latitudes: [], longitudes: []);
      area.name = _nameController.text;
      area.latitudes = [_center.latitude];
      area.longitudes = [_center.longitude];
      _areaBox.put(area);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.area == null ? 'Area added' : 'Area updated'} successfully.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isViewMode ? 'View Area' : (widget.area == null ? 'Add Area' : 'Edit Area')),
        actions: [
          if (!widget.isViewMode)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveArea,
              tooltip: 'Save Area',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Area Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an area name';
                  }
                  return null;
                },
                enabled: !widget.isViewMode,
              ),
            ),
          ),
          Expanded(
            child: fm.FlutterMap(
              mapController: _mapController.mapController,
              options: fm.MapOptions(
                initialCenter: _center,
                initialZoom: _zoom,
                minZoom: 2.0,
                maxZoom: 18.0,
                onPositionChanged: (position, hasGesture) {
                  if (mounted && position.center != null && position.zoom != null) {
                    setState(() {
                      _zoom = position.zoom!;
                    });
                  }
                },
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider: fm.NetworkTileProvider(),
                ),
                if (_polygon != null)
                  fm.PolygonLayer(
                    polygons: [_polygon!],
                  ),
                if (_dragMarker != null)
                  DragMarkers(
                    markers: [_dragMarker!],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isViewMode
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'saveArea',
                  onPressed: _saveArea,
                  child: const Icon(Icons.save),
                ),
              ],
            ),
    );
  }
}