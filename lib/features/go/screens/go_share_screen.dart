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
  bool _shareOfflineMapsExpanded = false;
  bool _shareRoutesPlannerExpanded = false;

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
            title: const Text('Offline Maps'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareOfflineMapsExpanded = expanded;
              });
            },
            initiallyExpanded: _shareOfflineMapsExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Offline Maps options and actions will go here.'),
                // Add share Offline Maps functionality widgets here
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Routes Planner'),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareRoutesPlannerExpanded = expanded;
              });
            },
            initiallyExpanded: _shareRoutesPlannerExpanded,
            children: <Widget>[
              ListTile(
                title: const Text('Routes Planner options and actions will go here.'),
                // Add share Routes Planner functionality widgets here
              ),
            ],
          ),
        ],
      ),
    );
  }
}