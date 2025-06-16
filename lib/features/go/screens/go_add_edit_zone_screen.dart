import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_route_models.dart'; // GoZone is in go_route_models.dart
import 'package:by_faith/objectbox.dart'; // Assuming ObjectBox store is accessible
import 'package:by_faith/objectbox.g.dart'; // Assuming generated ObjectBox code

class GoAddEditZoneScreen extends StatefulWidget {
  final GoZone? zone;

  const GoAddEditZoneScreen({Key? key, this.zone}) : super(key: key);

  @override
  _GoAddEditZoneScreenState createState() => _GoAddEditZoneScreenState();
}

class _GoAddEditZoneScreenState extends State<GoAddEditZoneScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late Box<GoZone> _zoneBox;

  @override
  void initState() {
    super.initState();
    _zoneBox = store.box<GoZone>();
    _nameController = TextEditingController(text: widget.zone?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveZone() {
    if (_formKey.currentState!.validate()) {
      final zone = widget.zone ?? GoZone(name: '', latitude: 0.0, longitude: 0.0, widthInMeters: 0.0, heightInMeters: 0.0);
      zone.name = _nameController.text;
      // For simplicity, latitude, longitude, widthInMeters, heightInMeters are not handled here
      // In a real scenario, these would likely be set when creating the zone on the map
      _zoneBox.put(zone);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zone == null ? 'Add Zone' : 'Edit Zone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Zone Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a zone name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveZone,
                child: const Text('Save Zone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}