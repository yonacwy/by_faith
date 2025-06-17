import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_tab_screen.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_area_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_street_screen.dart';
import 'package:by_faith/features/go/screens/go_add_edit_zone_screen.dart';

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
        title: Text('Rename $type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
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
        title: const Text('Route Planner'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: Text(
                  'Add Area',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  _navigateToMapScreen('Area');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions),
                title: Text(
                  'Add Street',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  _navigateToMapScreen('Street');
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: Text(
                  'Add Zone',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  _navigateToMapScreen('Zone');
                },
              ),
              ExpansionTile(
                title: Text(
                  'Areas',
                  style: Theme.of(context).textTheme.titleMedium,
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
                        return const Center(child: Text('No areas added yet.'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final area = snapshot.data![index];
                          return ListTile(
                            title: Text(area.name),
                            subtitle: area.points.isNotEmpty
                                ? Text('Lat: ${area.points.first.latitude.toStringAsFixed(4)}, Lon: ${area.points.first.longitude.toStringAsFixed(4)}')
                                : const Text('No coordinates'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Area', area),
                              itemBuilder: (context) => [
                                
                                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                                const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
                  style: Theme.of(context).textTheme.titleMedium,
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
                        return const Center(child: Text('No streets added yet.'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final street = snapshot.data![index];
                          return ListTile(
                            title: Text(street.name),
                            subtitle: street.points.isNotEmpty
                                ? Text('Lat: ${street.points.first.latitude.toStringAsFixed(4)}, Lon: ${street.points.first.longitude.toStringAsFixed(4)}')
                                : const Text('No coordinates'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Street', street),
                              itemBuilder: (context) => [
                                
                                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                                const PopupMenuItem(value: 'delete', child: Text('Delete')),
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
                  style: Theme.of(context).textTheme.titleMedium,
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
                        return const Center(child: Text('No zones added yet.'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final zone = snapshot.data![index];
                          return ListTile(
                            title: Text(zone.name),
                            subtitle: Text('Lat: ${zone.latitude.toStringAsFixed(4)}, Lon: ${zone.longitude.toStringAsFixed(4)}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Zone', zone),
                              itemBuilder: (context) => [
                                
                                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                                const PopupMenuItem(value: 'delete', child: Text('Delete')),
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