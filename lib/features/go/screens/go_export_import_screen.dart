import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/features/go/models/go_route_models.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';


class GoExportImportScreen extends StatefulWidget {
  const GoExportImportScreen({super.key});

  @override
  State<GoExportImportScreen> createState() => _GoExportImportScreenState();
}

class _GoExportImportScreenState extends State<GoExportImportScreen> {
  bool _isExportExpanded = false;
  bool _isImportExpanded = false;

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

  // Helper method to export data as JSON
  Future<void> _exportData<T>(
      List<T> items, String type, String fileName, Map<String, dynamic> Function(T) toJson) async {
    try {
      final data = items.map(toJson).toList();
      final jsonString = jsonEncode({'type': type, 'data': data});

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);
      await file.writeAsString(jsonString);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save $type JSON',
        fileName: '$fileName.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (result != null) {
        await file.copy(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$type exported successfully',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting $type: $e')),
        );
      }
    }
  }

  // Helper method to import data from JSON
  Future<void> _importData<T>(String expectedType, Box<T> box, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select $expectedType JSON',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

        if (jsonData['type'] != expectedType) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Invalid file: Expected $expectedType data',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
              ),
            );
          }
          return;
        }

        final data = (jsonData['data'] as List).cast<Map<String, dynamic>>();
        for (var item in data) {
          final entity = fromJson(item);
          box.put(entity);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$expectedType imported successfully',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            ),
          );
        }
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing $expectedType: $e')),
        );
      }
    }
  }

  // JSON converters for each entity
  Map<String, dynamic> _contactToJson(GoContact contact) {
    final notes = goContactNotesBox.query(GoContactNote_.contact.equals(contact.id)).build().find();
    return {
      'id': contact.id,
      'fullName': contact.fullName,
      'latitude': contact.latitude,
      'longitude': contact.longitude,
      'address': contact.address,
      'birthday': contact.birthday,
      'phone': contact.phone,
      'email': contact.email,
      'isVisited': contact.isVisited,
      'eternalStatus': contact.eternalStatus,
      'notes': notes
          .map((note) => {
                'id': note.id,
                'content': note.content,
                'createdAt': note.createdAt.toIso8601String(),
                'updatedAt': note.updatedAt?.toIso8601String(),
              })
          .toList(),
    };
  }

  GoContact _contactFromJson(Map<String, dynamic> json) {
    final contact = GoContact(
      id: json['id'] ?? 0,
      fullName: json['fullName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      birthday: json['birthday'],
      phone: json['phone'],
      email: json['email'],
      isVisited: json['isVisited'] ?? false,
      eternalStatus: json['eternalStatus'],
    );
    final notes = (json['notes'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    for (var noteJson in notes) {
      final note = GoContactNote(
        id: noteJson['id'] ?? 0,
        content: noteJson['content'],
        createdAt: DateTime.parse(noteJson['createdAt']),
        updatedAt: noteJson['updatedAt'] != null ? DateTime.parse(noteJson['updatedAt']) : null,
      );
      note.contact.target = contact;
      goContactNotesBox.put(note);
    }
    return contact;
  }

  Map<String, dynamic> _churchToJson(GoChurch church) {
    final notes = goChurchNotesBox.query(GoChurchNote_.church.equals(church.id)).build().find();
    return {
      'id': church.id,
      'churchName': church.churchName,
      'pastorName': church.pastorName,
      'address': church.address,
      'phone': church.phone,
      'email': church.email,
      'latitude': church.latitude,
      'longitude': church.longitude,
      'financialStatus': church.financialStatus,
      'notes': notes
          .map((note) => {
                'id': note.id,
                'content': note.content,
                'createdAt': note.createdAt.toIso8601String(),
                'updatedAt': note.updatedAt?.toIso8601String(),
              })
          .toList(),
    };
  }

  GoChurch _churchFromJson(Map<String, dynamic> json) {
    final church = GoChurch(
      id: json['id'] ?? 0,
      churchName: json['churchName'],
      pastorName: json['pastorName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      financialStatus: json['financialStatus'],
    );
    final notes = (json['notes'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    for (var noteJson in notes) {
      final note = GoChurchNote(
        id: noteJson['id'] ?? 0,
        content: noteJson['content'],
        createdAt: DateTime.parse(noteJson['createdAt']),
        updatedAt: noteJson['updatedAt'] != null ? DateTime.parse(noteJson['updatedAt']) : null,
      );
      note.church.target = church;
      goChurchNotesBox.put(note);
    }
    return church;
  }

  Map<String, dynamic> _ministryToJson(GoMinistry ministry) {
    final notes = goMinistryNotesBox.query(GoMinistryNote_.ministry.equals(ministry.id)).build().find();
    return {
      'id': ministry.id,
      'ministryName': ministry.ministryName,
      'contactName': ministry.contactName,
      'address': ministry.address,
      'phone': ministry.phone,
      'email': ministry.email,
      'latitude': ministry.latitude,
      'longitude': ministry.longitude,
      'partnerStatus': ministry.partnerStatus,
      'notes': notes
          .map((note) => {
                'id': note.id,
                'content': note.content,
                'createdAt': note.createdAt.toIso8601String(),
                'updatedAt': note.updatedAt?.toIso8601String(),
              })
          .toList(),
    };
  }

  GoMinistry _ministryFromJson(Map<String, dynamic> json) {
    final ministry = GoMinistry(
      id: json['id'] ?? 0,
      ministryName: json['ministryName'],
      contactName: json['contactName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      partnerStatus: json['partnerStatus'],
    );
    final notes = (json['notes'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    for (var noteJson in notes) {
      final note = GoMinistryNote(
        id: noteJson['id'] ?? 0,
        content: noteJson['content'],
        createdAt: DateTime.parse(noteJson['createdAt']),
        updatedAt: noteJson['updatedAt'] != null ? DateTime.parse(noteJson['updatedAt']) : null,
      );
      note.ministry.target = ministry;
      goMinistryNotesBox.put(note);
    }
    return ministry;
  }

  Map<String, dynamic> _areaToJson(GoArea area) {
    return {
      'id': area.id,
      'name': area.name,
      'latitudes': area.latitudes,
      'longitudes': area.longitudes,
    };
  }

  GoArea _areaFromJson(Map<String, dynamic> json) {
    return GoArea(
      id: json['id'] ?? 0,
      name: json['name'],
      latitudes: (json['latitudes'] as List<dynamic>).cast<double>(),
      longitudes: (json['longitudes'] as List<dynamic>).cast<double>(),
    );
  }

  Map<String, dynamic> _streetToJson(GoStreet street) {
    return {
      'id': street.id,
      'name': street.name,
      'latitudes': street.latitudes,
      'longitudes': street.longitudes,
      'type': street.type,
    };
  }

  GoStreet _streetFromJson(Map<String, dynamic> json) {
    return GoStreet(
      id: json['id'] ?? 0,
      name: json['name'],
      latitudes: (json['latitudes'] as List<dynamic>).cast<double>(),
      longitudes: (json['longitudes'] as List<dynamic>).cast<double>(),
      type: json['type'],
    );
  }

  Map<String, dynamic> _zoneToJson(GoZone zone) {
    return {
      'id': zone.id,
      'name': zone.name,
      'latitude': zone.latitude,
      'longitude': zone.longitude,
      'widthInMeters': zone.widthInMeters,
      'heightInMeters': zone.heightInMeters,
    };
  }

  GoZone _zoneFromJson(Map<String, dynamic> json) {
    return GoZone(
      id: json['id'] ?? 0,
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      widthInMeters: json['widthInMeters'],
      heightInMeters: json['heightInMeters'],
    );
  }

  // Export all data
  Future<void> _exportAll() async {
    final contacts = goContactsBox.getAll();
    final churches = goChurchesBox.getAll();
    final ministries = goMinistriesBox.getAll();
    final areas = _goAreasBox.getAll();
    final streets = _goStreetsBox.getAll();
    final zones = _goZonesBox.getAll();

    final data = {
      'type': 'all',
      'contacts': contacts.map(_contactToJson).toList(),
      'churches': churches.map(_churchToJson).toList(),
      'ministries': ministries.map(_ministryToJson).toList(),
      'areas': areas.map(_areaToJson).toList(),
      'streets': streets.map(_streetToJson).toList(),
      'zones': zones.map(_zoneToJson).toList(),
    };

    try {
      final jsonString = jsonEncode(data);
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/all_data.json';
      final file = File(filePath);
      await file.writeAsString(jsonString);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save All Data JSON',
        fileName: 'all_data.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (result != null) {
        await file.copy(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All data exported successfully',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting all data: $e')),
        );
      }
    }
  }

  // Import all data
  Future<void> _importAll() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select All Data JSON',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

        if (jsonData['type'] != 'all') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Invalid file: Expected all data',
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
              ),
            );
          }
          return;
        }

        // Import contacts
        final contacts = (jsonData['contacts'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var contactJson in contacts) {
          final contact = _contactFromJson(contactJson);
          goContactsBox.put(contact);
        }

        // Import churches
        final churches = (jsonData['churches'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var churchJson in churches) {
          final church = _churchFromJson(churchJson);
          goChurchesBox.put(church);
        }

        // Import ministries
        final ministries = (jsonData['ministries'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var ministryJson in ministries) {
          final ministry = _ministryFromJson(ministryJson);
          goMinistriesBox.put(ministry);
        }

        // Import areas
        final areas = (jsonData['areas'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var areaJson in areas) {
          final area = _areaFromJson(areaJson);
          _goAreasBox.put(area);
        }

        // Import streets
        final streets = (jsonData['streets'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var streetJson in streets) {
          final street = _streetFromJson(streetJson);
          _goStreetsBox.put(street);
        }

        // Import zones
        final zones = (jsonData['zones'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var zoneJson in zones) {
          final zone = _zoneFromJson(zoneJson);
          _goZonesBox.put(zone);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All data imported successfully',
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            ),
          );
        }
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing all data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_export_import_screen.title,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              t.go_export_import_screen.export_data,
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExportExpanded = expanded;
              });
            },
            initiallyExpanded: _isExportExpanded,
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.churches,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: goChurchesBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_churches,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : goChurchesBox.getAll().map((church) => ListTile(
                          title: Text(
                            church.churchName,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [church],
                            'churches',
                            church.churchName.replaceAll(' ', '_'),
                            _churchToJson,
                          ),
                        )).toList(),
              ),
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.contacts,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: goContactsBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_contacts,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : goContactsBox.getAll().map((contact) => ListTile(
                          title: Text(
                            contact.fullName,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [contact],
                            'contacts',
                            contact.fullName.replaceAll(' ', '_'),
                            _contactToJson,
                          ),
                        )).toList(),
              ),
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.ministries,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: goMinistriesBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_ministries,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : goMinistriesBox.getAll().map((ministry) => ListTile(
                          title: Text(
                            ministry.ministryName,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [ministry],
                            'ministries',
                            ministry.ministryName.replaceAll(' ', '_'),
                            _ministryToJson,
                          ),
                        )).toList(),
              ),
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.areas,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: _goAreasBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_areas,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : _goAreasBox.getAll().map((area) => ListTile(
                          title: Text(
                            area.name,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [area],
                            'areas',
                            area.name.replaceAll(' ', '_'),
                            _areaToJson,
                          ),
                        )).toList(),
              ),
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.streets,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: _goStreetsBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_streets,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : _goStreetsBox.getAll().map((street) => ListTile(
                          title: Text(
                            street.name,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [street],
                            'streets',
                            street.name.replaceAll(' ', '_'),
                            _streetToJson,
                          ),
                        )).toList(),
              ),
              ExpansionTile(
                title: Text(
                  t.go_export_import_screen.zones,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                children: _goZonesBox.getAll().isEmpty
                    ? [
                        ListTile(
                          title: Text(
                            t.go_export_import_screen.no_zones,
                            style: TextStyle(
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                        )
                      ]
                    : _goZonesBox.getAll().map((zone) => ListTile(
                          title: Text(
                            zone.name,
                            style: TextStyle(
                              fontFamily: context.watch<FontProvider>().fontFamily,
                              fontSize: context.watch<FontProvider>().fontSize,
                            ),
                          ),
                          onTap: () => _exportData(
                            [zone],
                            'zones',
                            zone.name.replaceAll(' ', '_'),
                            _zoneToJson,
                          ),
                        )).toList(),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.all,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: _exportAll,
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              t.go_export_import_screen.import_data,
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isImportExpanded = expanded;
              });
            },
            initiallyExpanded: _isImportExpanded,
            children: <Widget>[
              ListTile(
                title: Text(
                  t.go_export_import_screen.churches,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('churches', goChurchesBox, _churchFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.contacts,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('contacts', goContactsBox, _contactFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.ministries,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('ministries', goMinistriesBox, _ministryFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.areas,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('areas', _goAreasBox, _areaFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.streets,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('streets', _goStreetsBox, _streetFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.zones,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('zones', _goZonesBox, _zoneFromJson),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.all,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: _importAll,
              ),
            ],
          ),
        ],
      ),
    );
  }
}