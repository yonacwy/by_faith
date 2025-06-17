import 'package:flutter/material.dart';

class GoExportImportScreen extends StatefulWidget {
  const GoExportImportScreen({super.key});

  @override
  State<GoExportImportScreen> createState() => _GoExportImportScreenState();
}

class _GoExportImportScreenState extends State<GoExportImportScreen> {
  bool _isExportExpanded = false;
  bool _isImportExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export/Import'),
      ),
      body: ListView(
        children: <Widget>[
          // Data Management Section Header (Optional, can be a simple ListTile or similar)
          // For now, let's just add the expandable sections directly under the list view.

          ExpansionTile(
            title: const Text('Export Data'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExportExpanded = expanded;
              });
            },
            initiallyExpanded: _isExportExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Churches'),
                // Add export functionality for Churches here
              ),
              ListTile(
                title: const Text('Contacts'),
                // Add export functionality for Contacts here
              ),
              ListTile(
                title: const Text('Ministries'),
                // Add export functionality for Ministries here
              ),
              ListTile(
                title: const Text('Areas'),
                // Add export functionality for Areas here
              ),
              ListTile(
                title: const Text('Streets'),
                // Add export functionality for Streets here
              ),
              ListTile(
                title: const Text('Zones'),
                // Add export functionality for Zones here
              ),
              ListTile(
                title: const Text('All'),
                // Add export functionality for All here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Import Data'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isImportExpanded = expanded;
              });
            },
            initiallyExpanded: _isImportExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Churches'),
                // Add export functionality for Churches here
              ),
              ListTile(
                title: const Text('Contacts'),
                // Add export functionality for Contacts here
              ),
              ListTile(
                title: const Text('Ministries'),
                // Add export functionality for Ministries here
              ),
              ListTile(
                title: const Text('Areas'),
                // Add export functionality for Areas here
              ),
              ListTile(
                title: const Text('Streets'),
                // Add export functionality for Streets here
              ),
              ListTile(
                title: const Text('Zones'),
                // Add export functionality for Zones here
              ),
              ListTile(
                title: const Text('All'),
                // Add export functionality for All here
              ),
            ],
          ),
        ],
      ),
    );
  }
}