import 'package:flutter/material.dart';
import 'package:by_faith/features/pray/screens/pray_search_screen.dart';
import 'package:by_faith/features/pray/screens/pray_settings_screen.dart';
import 'package:by_faith/features/pray/screens/pray_share_screen.dart';
import 'package:by_faith/features/pray/screens/pray_plans_screen.dart';
import 'package:by_faith/features/pray/screens/pray_export_import_screen.dart';
import 'package:by_faith/features/pray/screens/pray_challenges_screen.dart';
import 'package:by_faith/features/pray/screens/pray_reminders_screen.dart';
import 'package:by_faith/features/pray/screens/pray_timers_screen.dart';
import 'package:by_faith/features/pray/screens/pray_walls_screen.dart';

class PrayTabScreen extends StatelessWidget {
  const PrayTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pray'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PraySearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort), // Added sort icon
            onPressed: () {
              // TODO: Implement sort functionality
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pray Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
                              MaterialPageRoute(builder: (context) => const PrayShareScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.import_export, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrayExportImportScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PraySettingsScreen()),
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
              leading: const Icon(Icons.flag),
              title: const Text('Challenges'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayChallengesScreen()),
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
                  MaterialPageRoute(builder: (context) => const PrayPlansScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayRemindersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayTimersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.fence),
              title: const Text('Walls'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrayWallsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Pray Tab Content'),
      ),
    );
  }
}