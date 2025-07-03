import 'package:flutter/material.dart';
import 'package:by_faith/features/read/screens/read_bookmarks_screen.dart';
import 'package:by_faith/features/read/screens/read_favorites_screen.dart';
import 'package:by_faith/features/read/screens/read_settings_screen.dart';
import 'package:by_faith/features/read/screens/read_plans_screen.dart';
import 'package:by_faith/features/read/screens/read_share_screen.dart';
import 'package:by_faith/features/read/screens/read_export_import_screen.dart';
import 'package:by_faith/features/read/screens/read_search_screen.dart';
import 'package:by_faith/features/read/screens/read_memorizations_screen.dart';
import 'package:by_faith/features/read/screens/read_highlights_screen.dart';

class ReadTabScreen extends StatelessWidget {
  const ReadTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReadSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen), // Fullscreen icon
            onPressed: () {
              // TODO: Implement fullscreen toggle logic
            },
          ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Read Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReadShareScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.import_export, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReadExportImportScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReadSettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
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
              leading: const Icon(Icons.highlight), // Using a relevant icon, adjust if needed
              title: const Text('Highlights'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadHighlightsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.memory), // Using a relevant icon, adjust if needed
              title: const Text('Memorizations'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReadMemorizationsScreen()),
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
          ],
        ),
      ),
      body: const Center(
        child: Text('Read Tab Content'),
      ),
    );
  }
}