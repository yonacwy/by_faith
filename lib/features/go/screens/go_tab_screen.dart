import 'package:flutter/material.dart';
import 'package:by_faith/features/go/screens/go_contacts_screen.dart';
import 'package:by_faith/features/go/screens/go_offline_maps_screen.dart';
import 'package:by_faith/features/go/screens/go_profile_screen.dart';
import 'package:by_faith/features/go/screens/go_select_map_area_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:by_faith/core/data/data_sources/local/go_map_cache.dart';
import 'package:by_faith/features/go/screens/go_add_edit_contact_screen.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/core/data/data_sources/local/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart'; // For StreamBuilder

class GoTabScreen extends StatefulWidget {
  const GoTabScreen({super.key});

  @override
  State<GoTabScreen> createState() => _GoTabScreenState();
}

class _GoTabScreenState extends State<GoTabScreen> {
  final MapController _mapController = MapController();
  static const LatLng _initialCenter = LatLng(39.0, -98.0); // Center on the Americas
  bool _isLoading = true;
  TileProvider? _tileProvider;
  List<Marker> _markers = [];
  bool _isAddingMarker = false;

  @override
  void initState() {
    super.initState();
    _setupMarkers();
    goContactsBox.query().watch(triggerImmediately: true).listen((query) {
      _setupMarkers();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeMapCache(); // Initialize map cache here
  }

  Future<void> _initializeMapCache() async {
    try {
      await GoMapCache.initialize();
      _tileProvider = GoMapCache.getTileProvider();
    } catch (e) {
      _tileProvider = NetworkTileProvider(); // Fallback to network provider
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize map cache: $e. Using online map.')),
        );
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupMarkers() {
    final List<Marker> newMarkers = [];
    for (final contact in goContactsBox.getAll()) {
      if (contact.latitude != null && contact.longitude != null) {
        newMarkers.add(
          Marker(
            point: LatLng(contact.latitude!, contact.longitude!),
            width: 80.0,
            height: 80.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoAddEditContactScreen(contact: contact),
                  ),
                );
              },
              child: Image.asset('lib/features/go/assets/images/marker.png'),
            ),
          ),
        );
      }
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latLng) {
    if (_isAddingMarker) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoAddEditContactScreen(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
          ),
        ),
      ).then((_) {
        setState(() {
          _isAddingMarker = false; // Reset after returning from add contact screen
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Go Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoContactsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Offline Maps'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoOfflineMapsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.select_all),
              title: const Text('Select Map Area'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GoSelectMapAreaScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: 5.0,
                minZoom: 2.0,
                maxZoom: 18.0,
                onTap: _handleMapTap, // Add onTap callback
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  tileProvider: _tileProvider ?? NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: _markers, // Use the dynamic markers list
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => {},
                    ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoomInButton',
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoomOutButton',
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          );
                        },
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: "add_marker_fab",
                        onPressed: () {
                          setState(() {
                            _isAddingMarker = !_isAddingMarker; // Toggle adding marker mode
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isAddingMarker
                                  ? 'Tap on map to place a marker'
                                  : 'Marker placement mode off'),
                            ),
                          );
                        },
                        child: Icon(_isAddingMarker ? Icons.cancel : Icons.add_location_alt_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}