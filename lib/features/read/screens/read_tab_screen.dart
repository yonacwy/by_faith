import 'package:flutter/material.dart';
import 'package:by_faith/features/read/screens/read_bookmarks_screen.dart';
import 'package:by_faith/features/read/screens/read_favorites_screen.dart';
import 'package:by_faith/features/read/screens/read_settings_screen.dart';
import 'package:by_faith/features/read/screens/read_plans_screen.dart';

class ReadTabScreen extends StatelessWidget {
  const ReadTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[900],
              ),
              child: Text(
                'Read Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmarks'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadBookmarksScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadFavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Plans'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadPlansScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadSettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Read Tab Content'),
      ),
    );
  }
}