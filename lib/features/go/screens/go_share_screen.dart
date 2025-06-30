import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.g.dart'; // Import generated ObjectBox file
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

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

  // Boxes for GoArea, GoStreet, GoZone
  late final Box<GoArea> _goAreasBox;
  late final Box<GoStreet> _goStreetsBox;
  late final Box<GoZone> _goZonesBox;

  @override
  void initState() {
    super.initState();
    // Initialize boxes
    _goAreasBox = store.box<GoArea>();
    _goStreetsBox = store.box<GoStreet>();
    _goZonesBox = store.box<GoZone>();
  }

  // Helper method to format contact data for sharing
  String _formatContact(GoContact contact) {
    final notes = goContactNotesBox
        .query(GoContactNote_.contact.equals(contact.id))
        .build()
        .find();
    return '''
Contact: ${contact.fullName}
Address: ${contact.address ?? 'N/A'}
Phone: ${contact.phone ?? 'N/A'}
Email: ${contact.email ?? 'N/A'}
Birthday: ${contact.birthday ?? 'N/A'}
Visited: ${contact.isVisited ? 'Yes' : 'No'}
Eternal Status: ${contact.eternalStatus ?? 'N/A'}
Coordinates: (${contact.latitude ?? 'N/A'}, ${contact.longitude ?? 'N/A'})
Notes: ${notes.isEmpty ? 'None' : notes.map((note) => note.content).join('\n')}
''';
  }

  // Helper method to format church data for sharing
  String _formatChurch(GoChurch church) {
    final notes = goChurchNotesBox
        .query(GoChurchNote_.church.equals(church.id))
        .build()
        .find();
    return '''
Church: ${church.churchName}
Pastor: ${church.pastorName ?? 'N/A'}
Address: ${church.address ?? 'N/A'}
Phone: ${church.phone ?? 'N/A'}
Email: ${church.email ?? 'N/A'}
Financial Status: ${church.financialStatus ?? 'N/A'}
Coordinates: (${church.latitude ?? 'N/A'}, ${church.longitude ?? 'N/A'})
Notes: ${notes.isEmpty ? 'None' : notes.map((note) => note.content).join('\n')}
''';
  }

  // Helper method to format ministry data for sharing
  String _formatMinistry(GoMinistry ministry) {
    final notes = goMinistryNotesBox
        .query(GoMinistryNote_.ministry.equals(ministry.id))
        .build()
        .find();
    return '''
Ministry: ${ministry.ministryName}
Contact: ${ministry.contactName ?? 'N/A'}
Address: ${ministry.address ?? 'N/A'}
Phone: ${ministry.phone ?? 'N/A'}
Email: ${ministry.email ?? 'N/A'}
Partner Status: ${ministry.partnerStatus ?? 'N/A'}
Coordinates: (${ministry.latitude ?? 'N/A'}, ${ministry.longitude ?? 'N/A'})
Notes: ${notes.isEmpty ? 'None' : notes.map((note) => note.content).join('\n')}
''';
  }

  // Helper method to format area data for sharing
  String _formatArea(GoArea area) {
    return '''
Area: ${area.name}
Coordinates: ${area.points.map((p) => '(${p.latitude}, ${p.longitude})').join(', ')}
''';
  }

  // Helper method to format street data for sharing
  String _formatStreet(GoStreet street) {
    return '''
Street: ${street.name}
Type: ${street.type ?? 'N/A'}
Coordinates: ${street.points.map((p) => '(${p.latitude}, ${p.longitude})').join(', ')}
''';
  }

  // Helper method to format zone data for sharing
  String _formatZone(GoZone zone) {
    return '''
Zone: ${zone.name}
Center: (${zone.latitude}, ${zone.longitude})
Dimensions: ${zone.widthInMeters}m x ${zone.heightInMeters}m
''';
  }

  // Helper method to format all data for sharing
  String _formatAllData() {
    final contacts = goContactsBox.getAll();
    final churches = goChurchesBox.getAll();
    final ministries = goMinistriesBox.getAll();
    final areas = _goAreasBox.getAll();
    final streets = _goStreetsBox.getAll();
    final zones = _goZonesBox.getAll();

    return '''
=== Contacts ===
${contacts.isEmpty ? 'None' : contacts.map(_formatContact).join('\n\n')}

=== Churches ===
${churches.isEmpty ? 'None' : churches.map(_formatChurch).join('\n\n')}

=== Ministries ===
${ministries.isEmpty ? 'None' : ministries.map(_formatMinistry).join('\n\n')}

=== Areas ===
${areas.isEmpty ? 'None' : areas.map(_formatArea).join('\n\n')}

=== Streets ===
${streets.isEmpty ? 'None' : streets.map(_formatStreet).join('\n\n')}

=== Zones ===
${zones.isEmpty ? 'None' : zones.map(_formatZone).join('\n\n')}
''';
  }

  // Helper method to share content
  Future<void> _shareContent(String content, String subject) async {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux) {
      final uri = Uri(
        scheme: 'mailto',
        queryParameters: {
          'subject': subject,
          'body': content,
        },
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      }
    } else {
      await Share.share(content, subject: subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_share_screen.title,
          style: TextStyle(
            fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
            fontSize: context.watch<GoSettingsFontProvider>().fontSize,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              t.go_share_screen.churches,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareChurchesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareChurchesExpanded,
            children: goChurchesBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_churches,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : goChurchesBox.getAll().map((church) => ListTile(
                      title: Text(
                        church.churchName,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatChurch(church),
                        'Church: ${church.churchName}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.contacts,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareContactsExpanded = expanded;
              });
            },
            initiallyExpanded: _shareContactsExpanded,
            children: goContactsBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_contacts,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : goContactsBox.getAll().map((contact) => ListTile(
                      title: Text(
                        contact.fullName,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatContact(contact),
                        'Contact: ${contact.fullName}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.ministries,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareMinistriesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareMinistriesExpanded,
            children: goMinistriesBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_ministries,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : goMinistriesBox.getAll().map((ministry) => ListTile(
                      title: Text(
                        ministry.ministryName,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatMinistry(ministry),
                        'Ministry: ${ministry.ministryName}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.areas,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareAreasExpanded = expanded;
              });
            },
            initiallyExpanded: _shareAreasExpanded,
            children: _goAreasBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_areas,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : _goAreasBox.getAll().map((area) => ListTile(
                      title: Text(
                        area.name,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatArea(area),
                        'Area: ${area.name}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.streets,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareStreetsExpanded = expanded;
              });
            },
            initiallyExpanded: _shareStreetsExpanded,
            children: _goStreetsBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_streets,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : _goStreetsBox.getAll().map((street) => ListTile(
                      title: Text(
                        street.name,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatStreet(street),
                        'Street: ${street.name}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.zones,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareZonesExpanded = expanded;
              });
            },
            initiallyExpanded: _shareZonesExpanded,
            children: _goZonesBox.getAll().isEmpty
                ? [
                    ListTile(
                      title: Text(
                        t.go_share_screen.no_zones,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                    )
                  ]
                : _goZonesBox.getAll().map((zone) => ListTile(
                      title: Text(
                        zone.name,
                        style: TextStyle(
                          fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                          fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                        ),
                      ),
                      onTap: () => _shareContent(
                        _formatZone(zone),
                        'Zone: ${zone.name}',
                      ),
                    )).toList(),
          ),
          ExpansionTile(
            title: Text(
              t.go_share_screen.all,
              style: TextStyle(
                fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                fontSize: context.watch<GoSettingsFontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _shareAllExpanded = expanded;
              });
            },
            initiallyExpanded: _shareAllExpanded,
            children: [
              ListTile(
                title: Text(
                  t.go_share_screen.share_all_data,
                  style: TextStyle(
                    fontFamily: context.watch<GoSettingsFontProvider>().fontFamily,
                    fontSize: context.watch<GoSettingsFontProvider>().fontSize,
                  ),
                ),
                onTap: () => _shareContent(
                  _formatAllData(),
                  'All By Faith Data',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}