import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/home/screens/home_info_screen.dart';
import 'package:by_faith/features/home/screens/home_support_screen.dart';
import 'package:by_faith/features/home/screens/home_calendar_screen.dart';
import 'package:by_faith/features/home/screens/home_settings_screen.dart';
import 'package:by_faith/features/home/screens/home_user_profile_screen.dart';
import 'package:by_faith/features/home/screens/home_bibles_screen.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context); // Use context-based translations
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home_tab_screen.title),
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
                      t.home_tab_screen.menu,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeInfoScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.support_agent, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeSupportScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeSettingsScreen()),
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
              leading: const Icon(Icons.book), // Using a book icon for Bibles
              title: Text(t.home_tab_screen.bibles),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeBiblesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(t.home_tab_screen.calendar),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeCalendarScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(t.home_tab_screen.profile),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeUserProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(t.home_tab_screen.content),
      ),
    );
  }
}