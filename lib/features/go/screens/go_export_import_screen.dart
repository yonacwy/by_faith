import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // <-- Add this import
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

  // --- JSON Serialization Helpers --- //
  Map<String, dynamic> _contactNoteToJson(GoContactNote note) => {
    'content': note.content,
    'createdAt': note.createdAt.toIso8601String(),
    'updatedAt': note.updatedAt?.toIso8601String(),
  };
  GoContactNote _contactNoteFromJson(Map<String, dynamic> json) => GoContactNote(
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  );

  Map<String, dynamic> _churchNoteToJson(GoChurchNote note) => {
    'content': note.content,
    'createdAt': note.createdAt.toIso8601String(),
    'updatedAt': note.updatedAt?.toIso8601String(),
  };
  GoChurchNote _churchNoteFromJson(Map<String, dynamic> json) => GoChurchNote(
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  );

  Map<String, dynamic> _ministryNoteToJson(GoMinistryNote note) => {
    'content': note.content,
    'createdAt': note.createdAt.toIso8601String(),
    'updatedAt': note.updatedAt?.toIso8601String(),
  };
  GoMinistryNote _ministryNoteFromJson(Map<String, dynamic> json) => GoMinistryNote(
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
  );

  Map<String, dynamic> _contactToJson(GoContact contact) => {
    'fullName': contact.fullName,
    'latitude': contact.latitude,
    'longitude': contact.longitude,
    'address': contact.address,
    'birthday': contact.birthday,
    'phone': contact.phone,
    'email': contact.email,
    'isVisited': contact.isVisited,
    'eternalStatus': contact.eternalStatus,
    'notes': contact.notes.map(_contactNoteToJson).toList(),
  };
  GoContact _contactFromJson(Map<String, dynamic> json) {
    final contact = GoContact(
      fullName: json['fullName'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'],
      birthday: json['birthday'],
      phone: json['phone'],
      email: json['email'],
      isVisited: json['isVisited'] ?? false,
      eternalStatus: json['eternalStatus'],
    );
    if (json['notes'] != null) {
      for (var noteJson in (json['notes'] as List)) {
        final note = _contactNoteFromJson(noteJson);
        note.contact.target = contact;
        contact.notes.add(note);
      }
    }
    return contact;
  }

  Map<String, dynamic> _churchToJson(GoChurch church) => {
    'churchName': church.churchName,
    'pastorName': church.pastorName,
    'address': church.address,
    'phone': church.phone,
    'email': church.email,
    'latitude': church.latitude,
    'longitude': church.longitude,
    'financialStatus': church.financialStatus,
    'notes': church.notes.map(_churchNoteToJson).toList(),
  };
  GoChurch _churchFromJson(Map<String, dynamic> json) {
    final church = GoChurch(
      churchName: json['churchName'],
      pastorName: json['pastorName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      financialStatus: json['financialStatus'],
    );
    if (json['notes'] != null) {
      for (var noteJson in (json['notes'] as List)) {
        final note = _churchNoteFromJson(noteJson);
        note.church.target = church;
        church.notes.add(note);
      }
    }
    return church;
  }

  Map<String, dynamic> _ministryToJson(GoMinistry ministry) => {
    'ministryName': ministry.ministryName,
    'contactName': ministry.contactName,
    'address': ministry.address,
    'phone': ministry.phone,
    'email': ministry.email,
    'latitude': ministry.latitude,
    'longitude': ministry.longitude,
    'partnerStatus': ministry.partnerStatus,
    'notes': ministry.notes.map(_ministryNoteToJson).toList(),
  };
  GoMinistry _ministryFromJson(Map<String, dynamic> json) {
    final ministry = GoMinistry(
      ministryName: json['ministryName'],
      contactName: json['contactName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      partnerStatus: json['partnerStatus'],
    );
    if (json['notes'] != null) {
      for (var noteJson in (json['notes'] as List)) {
        final note = _ministryNoteFromJson(noteJson);
        note.ministry.target = ministry;
        ministry.notes.add(note);
      }
    }
    return ministry;
  }

  Map<String, dynamic> _areaToJson(GoArea area) => {
    'name': area.name,
    'latitudes': area.latitudes,
    'longitudes': area.longitudes,
  };
  GoArea _areaFromJson(Map<String, dynamic> json) => GoArea(
    name: json['name'],
    latitudes: (json['latitudes'] as List).map((e) => (e as num).toDouble()).toList(),
    longitudes: (json['longitudes'] as List).map((e) => (e as num).toDouble()).toList(),
  );

  Map<String, dynamic> _streetToJson(GoStreet street) => {
    'name': street.name,
    'latitudes': street.latitudes,
    'longitudes': street.longitudes,
    'type': street.type,
  };
  GoStreet _streetFromJson(Map<String, dynamic> json) => GoStreet(
    name: json['name'],
    latitudes: (json['latitudes'] as List).map((e) => (e as num).toDouble()).toList(),
    longitudes: (json['longitudes'] as List).map((e) => (e as num).toDouble()).toList(),
    type: json['type'],
  );

  Map<String, dynamic> _zoneToJson(GoZone zone) => {
    'name': zone.name,
    'latitude': zone.latitude,
    'longitude': zone.longitude,
    'widthInMeters': zone.widthInMeters,
    'heightInMeters': zone.heightInMeters,
  };
  GoZone _zoneFromJson(Map<String, dynamic> json) => GoZone(
    name: json['name'],
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    widthInMeters: (json['widthInMeters'] as num).toDouble(),
    heightInMeters: (json['heightInMeters'] as num).toDouble(),
  );

  // Helper method to export data as JSON
  Future<void> _exportData<T>(
      List<T> items, String type, String fileName, Map<String, dynamic> Function(T) toJson) async {
    try {
      // Get FontProvider before the async operation
      final fontProvider = Provider.of<FontProvider>(context, listen: false);

      final data = items.map(toJson).toList();
      final jsonString = jsonEncode({'type': type, 'data': data});
      final jsonBytes = utf8.encode(jsonString);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save $type JSON',
        fileName: '$fileName.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
        bytes: Uint8List.fromList(jsonBytes), // Pass bytes for Android/iOS
      );

      if (result != null) {
        // On Android/iOS, the file is already saved by FilePicker
        // On desktop, we may need to write the file manually
        if (!Platform.isAndroid && !Platform.isIOS) {
          final file = File(result);
          await file.writeAsBytes(jsonBytes);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$type exported successfully',
                style: TextStyle(
                  fontFamily: fontProvider.fontFamily,
                  fontSize: fontProvider.fontSize,
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
  Future<void> _importData<T>(String expectedType, Box<T> box, T Function(Map<String, dynamic>) fromJson, {bool Function(T, Map<String, dynamic>)? isDuplicate, void Function(T, Map<String, dynamic>)? updateEntity}) async {
    try {
      // Get FontProvider and TextStyles before the async operation
      final fontProvider = Provider.of<FontProvider>(context, listen: false);
      final successTextStyle = TextStyle(
        fontFamily: fontProvider.fontFamily,
        fontSize: fontProvider.fontSize,
      );
      final invalidFileTextStyle = TextStyle(
        fontSize: fontProvider.fontSize,
      );

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
                  style: invalidFileTextStyle, // Use the prepared style
                ),
              ),
            );
          }
          return;
        }

        final data = (jsonData['data'] as List).cast<Map<String, dynamic>>();
        for (var item in data) {
          bool found = false;
          if (isDuplicate != null && updateEntity != null) {
            for (var entity in box.getAll()) {
              if (isDuplicate(entity, item)) {
                updateEntity(entity, item);
                box.put(entity);
                found = true;
                break;
              }
            }
          }
          if (!found) {
            final entity = fromJson(item);
            box.put(entity);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$expectedType imported successfully',
                style: successTextStyle, // Use the prepared style
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

  // Helper functions to check duplicates and update entities
  bool _isDuplicateContact(GoContact entity, Map<String, dynamic> json) {
    return entity.fullName == json['fullName'] && entity.phone == json['phone'];
  }
  void _updateContact(GoContact entity, Map<String, dynamic> json) {
    entity.latitude = json['latitude'];
    entity.longitude = json['longitude'];
    entity.address = json['address'];
    entity.birthday = json['birthday'];
    entity.email = json['email'];
    entity.isVisited = json['isVisited'] ?? false;
    entity.eternalStatus = json['eternalStatus'];
    // Merge notes, avoid duplicates by content and createdAt
    if (json['notes'] != null) {
      final List<GoContactNote> existingNotes = entity.notes.toList();
      for (var noteJson in (json['notes'] as List)) {
        final importedNote = _contactNoteFromJson(noteJson);
        final duplicate = existingNotes.any((n) => n.content == importedNote.content && n.createdAt == importedNote.createdAt);
        if (!duplicate) {
          importedNote.contact.target = entity;
          entity.notes.add(importedNote);
        }
      }
    }
  }

  bool _isDuplicateChurch(GoChurch entity, Map<String, dynamic> json) {
    return entity.churchName == json['churchName'] && entity.address == json['address'];
  }
  void _updateChurch(GoChurch entity, Map<String, dynamic> json) {
    entity.pastorName = json['pastorName'];
    entity.phone = json['phone'];
    entity.email = json['email'];
    entity.latitude = json['latitude'];
    entity.longitude = json['longitude'];
    entity.financialStatus = json['financialStatus'];
    // Merge notes, avoid duplicates by content and createdAt
    if (json['notes'] != null) {
      final List<GoChurchNote> existingNotes = entity.notes.toList();
      for (var noteJson in (json['notes'] as List)) {
        final importedNote = _churchNoteFromJson(noteJson);
        final duplicate = existingNotes.any((n) => n.content == importedNote.content && n.createdAt == importedNote.createdAt);
        if (!duplicate) {
          importedNote.church.target = entity;
          entity.notes.add(importedNote);
        }
      }
    }
  }

  bool _isDuplicateMinistry(GoMinistry entity, Map<String, dynamic> json) {
    return entity.ministryName == json['ministryName'] && entity.address == json['address'];
  }
  void _updateMinistry(GoMinistry entity, Map<String, dynamic> json) {
    entity.contactName = json['contactName'];
    entity.phone = json['phone'];
    entity.email = json['email'];
    entity.latitude = json['latitude'];
    entity.longitude = json['longitude'];
    entity.partnerStatus = json['partnerStatus'];
    // Merge notes, avoid duplicates by content and createdAt
    if (json['notes'] != null) {
      final List<GoMinistryNote> existingNotes = entity.notes.toList();
      for (var noteJson in (json['notes'] as List)) {
        final importedNote = _ministryNoteFromJson(noteJson);
        final duplicate = existingNotes.any((n) => n.content == importedNote.content && n.createdAt == importedNote.createdAt);
        if (!duplicate) {
          importedNote.ministry.target = entity;
          entity.notes.add(importedNote);
        }
      }
    }
  }

  bool _isDuplicateArea(GoArea entity, Map<String, dynamic> json) {
    return entity.name == json['name'];
  }
  void _updateArea(GoArea entity, Map<String, dynamic> json) {
    entity.latitudes = (json['latitudes'] as List<dynamic>).cast<double>();
    entity.longitudes = (json['longitudes'] as List<dynamic>).cast<double>();
  }

  bool _isDuplicateStreet(GoStreet entity, Map<String, dynamic> json) {
    return entity.name == json['name'] && entity.type == json['type'];
  }
  void _updateStreet(GoStreet entity, Map<String, dynamic> json) {
    entity.latitudes = (json['latitudes'] as List<dynamic>).cast<double>();
    entity.longitudes = (json['longitudes'] as List<dynamic>).cast<double>();
  }

  bool _isDuplicateZone(GoZone entity, Map<String, dynamic> json) {
    return entity.name == json['name'];
  }
  void _updateZone(GoZone entity, Map<String, dynamic> json) {
    entity.latitude = json['latitude'];
    entity.longitude = json['longitude'];
    entity.widthInMeters = json['widthInMeters'];
    entity.heightInMeters = json['heightInMeters'];
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

    // Get FontProvider before any await
    final fontProvider = Provider.of<FontProvider>(context, listen: false);

    try {
      final jsonString = jsonEncode(data);
      final jsonBytes = utf8.encode(jsonString);
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save All Data JSON',
        fileName: 'all_data.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
        bytes: Uint8List.fromList(jsonBytes), // Pass bytes for Android/iOS
      );

      if (result != null) {
        // On Android/iOS, the file is already saved by FilePicker
        // On desktop, we may need to write the file manually
        if (!Platform.isAndroid && !Platform.isIOS) {
          final file = File(result);
          await file.writeAsBytes(jsonBytes);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All data exported successfully',
                style: TextStyle(
                  fontFamily: fontProvider.fontFamily,
                  fontSize: fontProvider.fontSize,
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
    // Get FontProvider before any await
    final fontProvider = Provider.of<FontProvider>(context, listen: false);
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
              SnackBar(content: Text('Invalid file: Expected all data')),
            );
          }
          return;
        }

        // Import contacts
        final contacts = (jsonData['contacts'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var contactJson in contacts) {
          bool found = false;
          for (var entity in goContactsBox.getAll()) {
            if (_isDuplicateContact(entity, contactJson)) {
              _updateContact(entity, contactJson);
              goContactsBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final contact = _contactFromJson(contactJson);
            goContactsBox.put(contact);
          }
        }

        // Import churches
        final churches = (jsonData['churches'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var churchJson in churches) {
          bool found = false;
          for (var entity in goChurchesBox.getAll()) {
            if (_isDuplicateChurch(entity, churchJson)) {
              _updateChurch(entity, churchJson);
              goChurchesBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final church = _churchFromJson(churchJson);
            goChurchesBox.put(church);
          }
        }

        // Import ministries
        final ministries = (jsonData['ministries'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var ministryJson in ministries) {
          bool found = false;
          for (var entity in goMinistriesBox.getAll()) {
            if (_isDuplicateMinistry(entity, ministryJson)) {
              _updateMinistry(entity, ministryJson);
              goMinistriesBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final ministry = _ministryFromJson(ministryJson);
            goMinistriesBox.put(ministry);
          }
        }

        // Import areas
        final areas = (jsonData['areas'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var areaJson in areas) {
          bool found = false;
          for (var entity in _goAreasBox.getAll()) {
            if (_isDuplicateArea(entity, areaJson)) {
              _updateArea(entity, areaJson);
              _goAreasBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final area = _areaFromJson(areaJson);
            _goAreasBox.put(area);
          }
        }

        // Import streets
        final streets = (jsonData['streets'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var streetJson in streets) {
          bool found = false;
          for (var entity in _goStreetsBox.getAll()) {
            if (_isDuplicateStreet(entity, streetJson)) {
              _updateStreet(entity, streetJson);
              _goStreetsBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final street = _streetFromJson(streetJson);
            _goStreetsBox.put(street);
          }
        }

        // Import zones
        final zones = (jsonData['zones'] as List<dynamic>).cast<Map<String, dynamic>>();
        for (var zoneJson in zones) {
          bool found = false;
          for (var entity in _goZonesBox.getAll()) {
            if (_isDuplicateZone(entity, zoneJson)) {
              _updateZone(entity, zoneJson);
              _goZonesBox.put(entity);
              found = true;
              break;
            }
          }
          if (!found) {
            final zone = _zoneFromJson(zoneJson);
            _goZonesBox.put(zone);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All data imported successfully',
                style: TextStyle(
                  fontFamily: fontProvider.fontFamily,
                  fontSize: fontProvider.fontSize,
                ),
              ),
            ),
          );
        }
        setState(() {});
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
                onTap: () => _importData('churches', goChurchesBox, _churchFromJson, isDuplicate: _isDuplicateChurch, updateEntity: _updateChurch),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.contacts,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('contacts', goContactsBox, _contactFromJson, isDuplicate: _isDuplicateContact, updateEntity: _updateContact),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.ministries,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('ministries', goMinistriesBox, _ministryFromJson, isDuplicate: _isDuplicateMinistry, updateEntity: _updateMinistry),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.areas,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('areas', _goAreasBox, _areaFromJson, isDuplicate: _isDuplicateArea, updateEntity: _updateArea),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.streets,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('streets', _goStreetsBox, _streetFromJson, isDuplicate: _isDuplicateStreet, updateEntity: _updateStreet),
              ),
              ListTile(
                title: Text(
                  t.go_export_import_screen.zones,
                  style: TextStyle(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
                ),
                onTap: () => _importData('zones', _goZonesBox, _zoneFromJson, isDuplicate: _isDuplicateZone, updateEntity: _updateZone),
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