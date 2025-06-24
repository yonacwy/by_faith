import 'package:flutter/material.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/home/screens/home_info_screen.dart';
import 'package:by_faith/features/home/screens/home_support_screen.dart';
import 'package:by_faith/features/home/screens/home_calendar_screen.dart';
import 'package:by_faith/features/home/screens/home_settings_screen.dart';
import 'package:by_faith/features/home/screens/home_user_profile_screen.dart';

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
              child: Text(
                t.home_tab_screen.menu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(t.home_tab_screen.info),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeInfoScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: Text(t.home_tab_screen.support),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeSupportScreen()),
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
              leading: const Icon(Icons.settings),
              title: Text(t.home_tab_screen.settings),
              onTap: () {
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
      body: Center(
        child: Text(t.home_tab_screen.content),
      ),
    );
  }
}