import 'package:flutter/material.dart';

class GoShareScreen extends StatefulWidget {
  const GoShareScreen({super.key});

  @override
  State<GoShareScreen> createState() => _GoShareScreenState();
}

class _GoShareScreenState extends State<GoShareScreen> {
  bool _shareChurchesExpanded = false;
  bool _shareContactsExpanded = false;
  bool _shareMinistriesExpanded = false;
  bool _shareAreasExpanded = false;
  bool _shareStreetsExpanded = false;
  bool _shareZonesExpanded = false;
  bool _shareAllExpanded = false;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Churches'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareChurchesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareChurchesExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Churches options and actions will go here.'),
                // Add share Churches functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Contacts'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareContactsExpanded = expanded;
              });
            },
            initiallyExpanded: _shareContactsExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Contacts options and actions will go here.'),
                // Add share Contacts functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Ministries'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareMinistriesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareMinistriesExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Ministries options and actions will go here.'),
                // Add share Ministries functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Areas'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareAreasExpanded = expanded;
              });
            },
            initiallyExpanded: _shareAreasExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Areas options and actions will go here.'),
                // Add share Offline Maps functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Streets'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareStreetsExpanded = expanded;
              });
            },
            initiallyExpanded: _shareStreetsExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Streets options and actions will go here.'),
                // Add share Routes Planner functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Zones'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareZonesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareZonesExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Zones options and actions will go here.'),
                // Add share Routes Planner functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('All'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareAllExpanded = expanded;
              });
            },
            initiallyExpanded: _shareAllExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('All options and actions will go here.'),
                // Add share Routes Planner functionality widgets here
              ),
            ],
          ),
        ],
      ),
    );
  }
}