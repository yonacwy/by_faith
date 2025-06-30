import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:by_faith/features/study/screens/study_notes_screen.dart';
import 'package:by_faith/features/study/screens/study_search_screen.dart';
import 'package:by_faith/features/study/screens/study_settings_screen.dart';
import 'package:by_faith/features/study/screens/study_mapping_screen.dart';
import 'package:by_faith/features/study/screens/study_share_screen.dart';
import 'package:by_faith/features/study/screens/study_export_import_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:objectbox/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart'; // Updated import
import 'package:by_faith/app/i18n/strings.g.dart';

class StudyTabScreen extends StatelessWidget {
  const StudyTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_tab_screen.title),
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      t.study_tab_screen.study_menu,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: context.watch<StudySettingsFontProvider>().fontFamily, // Updated provider
                        fontSize: context.watch<StudySettingsFontProvider>().fontSize + 6, // Updated provider
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudyShareScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.import_export, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudyExportImportScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudySettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notes),
              title: const Text('Notes'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyNotesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Symbols.network_node),
              title: const Text('Mapping'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudyMappingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudySearchScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Study Tab Content'),
      ),
    );
  }
}