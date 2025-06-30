import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';

class GoSelectMapAreaScreen extends StatefulWidget {
final Function(String, double, double, double, double, int, ScaffoldMessengerState) onDownloadMap;

  const GoSelectMapAreaScreen({super.key, required this.onDownloadMap});

  @override
  State<GoSelectMapAreaScreen> createState() => _GoSelectMapAreaScreenState();
}

class _GoSelectMapAreaScreenState extends State<GoSelectMapAreaScreen> with TickerProviderStateMixin {
  late AnimatedMapController _mapController;
  final double _overlaySize = 0.5; // Adjusted overlay size for smaller area
  final String _tileProviderUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  LatLng _currentCenter = const LatLng(35.4334, -83.8007); // Center on Robbinsville, North Carolina
  double _currentZoom = 10.0; // Higher zoom for street-level detail
  bool _isLoadingSize = false;
  int _estimatedTileCount = 0;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _estimateTileCount();
  }

  Future<void> _estimateTileCount() async {
    setState(() {
      _isLoadingSize = true;
    });
    try {
      final southWest = LatLng(_currentCenter.latitude - _overlaySize / 2, _currentCenter.longitude - _overlaySize / 2);
      final northEast = LatLng(_currentCenter.latitude + _overlaySize / 2, _currentCenter.longitude + _overlaySize / 2);
      final zoom = _currentZoom.round(); // Use rounded zoom for consistency

      // Calculate tile count for the selected zoom level
      int tileCount = 0;
      final tileSouthWest = _latLngToTile(southWest, zoom);
      final tileNorthEast = _latLngToTile(northEast, zoom);

      // Ensure tile coordinates are valid and account for world wrapping
      final minX = math.min(tileSouthWest[0], tileNorthEast[0]);
      final maxX = math.max(tileSouthWest[0], tileNorthEast[0]);
      final minY = math.min(tileSouthWest[1], tileNorthEast[1]);
      final maxY = math.max(tileSouthWest[1], tileNorthEast[1]);

      final tilesX = (maxX - minX + 1).ceil();
      final tilesY = (maxY - minY + 1).ceil();

      // Ensure non-negative tile counts
      tileCount = (tilesX * tilesY).clamp(0, double.maxFinite.toInt());

      if (mounted) {
        setState(() {
          _estimatedTileCount = tileCount;
          _isLoadingSize = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _estimatedTileCount = 0;
          _isLoadingSize = false;
        });
      }
    }
  }

  List<int> _latLngToTile(LatLng point, int zoom) {
    final scale = math.pow(2, zoom).toDouble();
    // Normalize longitude to avoid wrapping issues
    double lon = point.longitude;
    while (lon > 180) lon -= 360;
    while (lon < -180) lon += 360;

    final worldX = ((lon + 180) / 360 * scale).floor();
    final sinLat = math.sin(point.latitude * math.pi / 180);
    final worldY = ((1 - math.log((1 + sinLat) / (1 - sinLat)) / (2 * math.pi)) / 2 * scale).floor();

    // Clamp tile coordinates to valid range
    final maxTile = (math.pow(2, zoom) - 1).toInt();
    return [
      worldX.clamp(0, maxTile),
      worldY.clamp(0, maxTile),
    ];
  }

  void _showDownloadDialog() {
    final estimatedSizeMB = (_estimatedTileCount * 10 / 1024).toStringAsFixed(2); // Assume 10KB per tile
    final double estimatedSize = _estimatedTileCount * 10 / 1024; // in MB
    if (_estimatedTileCount > 12000 || estimatedSize > 155.55) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            t.go_select_map_area_screen.download_limit_exceeded,
            style: TextStyle(
              fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
              fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
            ),
          ),
          content: Text(
            t.go_select_map_area_screen.download_limit_message,
            style: TextStyle(
              fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
              fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                t.go_select_map_area_screen.ok,
                style: TextStyle(
                  fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_select_map_area_screen.download_map,
          style: TextStyle(
            fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
          ),
        ),
        content: _isLoadingSize
            ? const CircularProgressIndicator()
            : Text(
                t.go_select_map_area_screen.download_map_question.replaceAll('{tiles}', '$_estimatedTileCount').replaceAll('{size}', estimatedSizeMB),
                style: TextStyle(
                  fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_select_map_area_screen.close,
              style: TextStyle(
                fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              TextEditingController controller = TextEditingController(text: 'Map _currentCenter.latitude.toStringAsFixed(2)},_currentCenter.longitude.toStringAsFixed(2)}');
              String? mapName = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    t.go_select_map_area_screen.name_your_map,
                    style: TextStyle(
                      fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                    ),
                  ),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: t.go_select_map_area_screen.enter_map_name,
                      hintStyle: TextStyle(
                        fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        t.go_select_map_area_screen.cancel,
                        style: TextStyle(
                          fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                          fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, controller.text.trim()),
                      child: Text(
                        t.go_select_map_area_screen.download,
                        style: TextStyle(
                          fontFamily: Provider.of<GoSettingsFontProvider>(context, listen: false).fontFamily,
                          fontSize: Provider.of<GoSettingsFontProvider>(context, listen: false).fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (mapName != null && mapName.isNotEmpty) {
                widget.onDownloadMap(
                  mapName,
                  _currentCenter.latitude - _overlaySize / 2,
                  _currentCenter.longitude - _overlaySize / 2,
                  _currentCenter.latitude + _overlaySize / 2,
                  _currentCenter.longitude + _overlaySize / 2,
                  _currentZoom.toInt(),
                  ScaffoldMessenger.of(context),
                );
                Navigator.pop(context); // Close download dialog
                Navigator.pop(context); // Return to OfflineMapsPage
              }
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void zoomIn() {
    if (!mounted) return;
    final newZoom = (_mapController.mapController.camera.zoom + 1).clamp(2.0, 18.0);
    _mapController.animateTo(zoom: newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
    _estimateTileCount();
  }

  void zoomOut() {
    if (!mounted) return;
    final newZoom = (_mapController.mapController.camera.zoom - 1).clamp(2.0, 18.0);
    _mapController.animateTo(zoom: newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
    _estimateTileCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_select_map_area_screen.title,
          style: TextStyle(
            fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
            fontSize: context.watch<GoSettingsFontProvider>().fontSize,
          ),
        ),
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
              onPositionChanged: (position, hasGesture) {
                if (mounted && position.center != null && position.zoom != null) {
                  setState(() {
                    _currentCenter = position.center!;
                    _currentZoom = position.zoom!;
                  });
                  _estimateTileCount();
                }
              },
            ),
            children: [
              fm.TileLayer(
                urlTemplate: _tileProviderUrl,
                tileProvider: fm.NetworkTileProvider(),
                userAgentPackageName: 'com.example.app',
              ),
              fm.PolygonLayer(
                polygons: [
                  fm.Polygon(
                    points: [
                      LatLng(_currentCenter.latitude - _overlaySize / 2, _currentCenter.longitude - _overlaySize / 2),
                      LatLng(_currentCenter.latitude - _overlaySize / 2, _currentCenter.longitude + _overlaySize / 2),
                      LatLng(_currentCenter.latitude + _overlaySize / 2, _currentCenter.longitude + _overlaySize / 2),
                      LatLng(_currentCenter.latitude + _overlaySize / 2, _currentCenter.longitude - _overlaySize / 2),
                    ],
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2.0,
                  ),
                ],
              ),
              fm.RichAttributionWidget(
                attributions: [
                  fm.TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => {},
                    textStyle: TextStyle(
                      fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                      fontSize: context.watch<GoSettingsFontProvider>().fontSize * 0.7,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoom_in_fab",
                  mini: true,
                  onPressed: zoomIn,
                  child: Icon(
                    Icons.add,
                    size: context.watch<GoSettingsFontProvider>().fontSize * 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "zoom_out_fab",
                  mini: true,
                  onPressed: zoomOut,
                  child: Icon(
                    Icons.remove,
                    size: context.watch<GoSettingsFontProvider>().fontSize * 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "download_fab",
                  onPressed: _showDownloadDialog,
                  child: Icon(
                    Icons.download,
                    size: context.watch<GoSettingsFontProvider>().fontSize * 1.2,
                  ),
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
    _mapController.dispose();
    super.dispose();
  }
}