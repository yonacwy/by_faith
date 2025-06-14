import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_tab_screen.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';

class GoRoutePlannerScreen extends StatefulWidget {
  const GoRoutePlannerScreen({super.key});

  @override
  State<GoRoutePlannerScreen> createState() => _GoRoutePlannerScreenState();
}

class _GoRoutePlannerScreenState extends State<GoRoutePlannerScreen> {
  late Box<GoArea> _areaBox;
  late Box<GoStreet> _streetBox;
  late Box<GoTag> _tagBox;

  @override
  void initState() {
    super.initState();
    _areaBox = store.box<GoArea>();
    _streetBox = store.box<GoStreet>();
    _tagBox = store.box<GoTag>();
  }

  void _showRouteSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Add Area'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToMapScreen('Area');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions),
                title: const Text('Add Street'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToMapScreen('Street');
                },
              ),
              ListTile(
                leading: const Icon(Icons.tag),
                title: const Text('Add Tag'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToMapScreen('Tag');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToMapScreen(String type, {dynamic item, bool isEdit = false, bool isView = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoTabScreen(
          routeType: type,
          existingRoute: item,
          isEditMode: isEdit,
          isViewMode: isView,
        ),
      ),
    );
  }

  Future<void> _deleteItem(String type, int id) async {
    try {
      if (type == 'Area') {
        _areaBox.remove(id);
      } else if (type == 'Street') {
        _streetBox.remove(id);
      } else if (type == 'Tag') {
        _tagBox.remove(id);
      }
      setState(() {});
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
          decoration: InputDecoration(hintText: 'Enter new name'),
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
      if (type == 'Area') {
        item.name = result;
        _areaBox.put(item as GoArea);
      } else if (type == 'Street') {
        item.name = result;
        _streetBox.put(item as GoStreet);
      } else if (type == 'Tag') {
        item.name = result;
        _tagBox.put(item as GoTag);
      }
      setState(() {});
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
                leading: const Icon(Icons.route),
                title: Text(
                  'Select Route on Map',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: _showRouteSelection,
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
                      print('Area StreamBuilder: connectionState=${snapshot.connectionState}, hasData=${snapshot.hasData}, dataLength=${snapshot.data?.length}');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No areas added yet.'));
                      }
                      final areas = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: areas.length,
                        itemBuilder: (context, index) {
                          final area = areas[index];
                          return ListTile(
                            title: Text(area.name),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Area', area),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('View'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<List<GoStreet>>(
                    stream: _streetBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                    builder: (context, snapshot) {
                      print('Street StreamBuilder: connectionState=${snapshot.connectionState}, hasData=${snapshot.hasData}, dataLength=${snapshot.data?.length}');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No streets added yet.'));
                      }
                      final streets = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: streets.length,
                        itemBuilder: (context, index) {
                          final street = streets[index];
                          return ListTile(
                            title: Text(street.name),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Street', street),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('View'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
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
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                initiallyExpanded: true,
                children: [
                  StreamBuilder<List<GoTag>>(
                    stream: _tagBox.query().watch(triggerImmediately: true).map((query) => query.find()),
                    builder: (context, snapshot) {
                      print('Tag StreamBuilder: connectionState=${snapshot.connectionState}, hasData=${snapshot.hasData}, dataLength=${snapshot.data?.length}');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No tags added yet.'));
                      }
                      final tags = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tags.length,
                        itemBuilder: (context, index) {
                          final tag = tags[index];
                          return ListTile(
                            title: Text(tag.name),
                            subtitle: Text(tag.text),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuSelection(value, 'Tag', tag),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('View'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'rename',
                                  child: Text('Rename'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
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