import 'package:flutter/material.dart';
import 'package:by_faith/features/go/screens/go_contacts_screen.dart';
import 'package:by_faith/features/go/screens/go_offline_maps_screen.dart';
import 'package:by_faith/features/go/screens/go_profile_screen.dart';
import 'package:by_faith/features/go/screens/go_select_map_area_screen.dart';

class GoTabScreen extends StatelessWidget {
  const GoTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go'),
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
      body: const Center(
        child: Text('Go Tab Content'),
      ),
    );
  }
}