import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_tab_screen.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_area_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_street_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_zone_screen.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/font_provider.dart';

class GoRoutePlannerScreen extends StatefulWidget {
  const GoRoutePlannerScreen({super.key});

  @override
  State<GoRoutePlannerScreen> createState() => _GoRoutePlannerScreenState();
}

class _GoRoutePlannerScreenState extends State<GoRoutePlannerScreen> {
  late Box<GoArea> _areaBox;
  late Box<GoStreet> _streetBox;
  late Box<GoZone> _zoneBox;

  @override
  void initState() {
    super.initState();
    _areaBox = store.box<GoArea>();
    _streetBox = store.box<GoStreet>();
    _zoneBox = store.box<GoZone>();
  }


  void _navigateToMapScreen(String type, {dynamic item, bool isEdit = false, bool isView = false}) {
    Widget screen;
    // For GoRoutePlannerScreen, we do not have a live map, so just open Add Zone without initialCenter/initialZoom
    switch (type) {
      case 'Area':
        screen = GoAddEditAreaScreen(area: isEdit || isView ? item as GoArea : null, isViewMode: isView);
        break;
      case 'Street':
        screen = GoAddEditStreetScreen(street: isEdit || isView ? item as GoStreet : null, isViewMode: isView);
        break;
      case 'Zone':
        screen = GoAddEditZoneScreen(zone: isEdit || isView ? item as GoZone : null);
        break;
      default:
        return; // Should not happen
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _deleteItem(String type, int id) async {
    try {
      if (type == 'Area') {
        _areaBox.remove(id);
      } else if (type == 'Street') {
        _streetBox.remove(id);
      } else if (type == 'Zone') {
        _zoneBox.remove(id);
      }
WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete $type: $error')),
      );
    }
  }

  Future<void> _renameItem(String type, dynamic item) async {
    final controller = TextEditingController(text: item.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rename $type',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            hintStyle: TextStyle(
              fontFamily: context.watch<FontProvider>().fontFamily,
              fontSize: context.watch<FontProvider>().fontSize,
            ),
          ),
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        if (type == 'Area') {
          item.name = result;
          _areaBox.put(item as GoArea);
        } else if (type == 'Street') {
          item.name = result;
          _streetBox.put(item as GoStreet);
        } else if (type == 'Zone') {
          item.name = result;
          _zoneBox.put(item as GoZone);
WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to rename $type: $error')),
        );
      }
    }
  }

  void _viewItem(String type, dynamic item) {
    _navigateToMapScreen(type, item: item, isView: true);
  }

  void _editItem(String type, dynamic item) {
    _navigateToMapScreen(type, item: item, isEdit: true);
  }

  void _handleMenuSelection(String value, String type, dynamic item) {
    switch (value) {
      case 'view':
        _viewItem(type, item);
        break;
      case 'edit':
        _editItem(type, item);
        break;
      case 'rename':
        _renameItem(type, item);
        break;
      case 'delete':
        _deleteItem(type, item.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Route Planner',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Removed Add Area, Add Street, Add Zone ListTiles to avoid confusion
              ExpansionTile(
                title: Text(
                  'Areas',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<List<GoArea>>(
                    stream: _areaBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No areas added yet.',
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final area = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              area.name,
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                            subtitle: area.points.isNotEmpty
                                ? Text(
                                    'Lat: ${area.points.first.latitude.toStringAsFixed(4)}, Lon: ${area.points.first.longitude.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize * 0.8,
                                    ),
                                  )
                                : Text(
                                    'No coordinates',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize * 0.8,
                                    ),
                                  ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Area', area),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'rename',
                                  child: Text(
                                    'Rename',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Streets',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<List<GoStreet>>(
                    stream: _streetBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No streets added yet.',
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final street = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              street.name,
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                            subtitle: street.points.isNotEmpty
                                ? Text(
                                    'Lat: ${street.points.first.latitude.toStringAsFixed(4)}, Lon: ${street.points.first.longitude.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize * 0.8,
                                    ),
                                  )
                                : Text(
                                    'No coordinates',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize * 0.8,
                                    ),
                                  ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Street', street),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'rename',
                                  child: Text(
                                    'Rename',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Zones',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<List<GoZone>>(
                    stream: _zoneBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No zones added yet.',
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final zone = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              zone.name,
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                            subtitle: Text(
                              'Lat: ${zone.latitude.toStringAsFixed(4)}, Lon: ${zone.longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize * 0.8,
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Zone', zone),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'rename',
                                  child: Text(
                                    'Rename',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}