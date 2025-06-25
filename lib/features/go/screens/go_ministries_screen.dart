import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_ministry_screen.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';


class GoMinistriesScreen extends StatefulWidget {
  const GoMinistriesScreen({super.key});

  @override
  State<GoMinistriesScreen> createState() => _GoMinistriesScreenState();
}

class _GoMinistriesScreenState extends State<GoMinistriesScreen> {
  void _navigateToAddMinistry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GoAddEditMinistryScreen()),
    );
  }

  void _navigateToEditMinistry(GoMinistry ministry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoAddEditMinistryScreen(ministry: ministry)),
    );
  }

  void _deleteMinistry(GoMinistry ministry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_ministries_screen.delete_ministry,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        content: Text(
          t.go_ministries_screen.delete_ministry_confirmation.replaceAll('{ministryName}', ministry.ministryName),
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_ministries_screen.cancel,
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in ministry.notes) {
                goMinistryNotesBox.remove(note.id);
              }
              goMinistriesBox.remove(ministry.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.go_ministries_screen.ministry_deleted.replaceAll('{ministryName}', ministry.ministryName),
                    style: TextStyle(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              t.go_ministries_screen.delete,
              style: TextStyle(
                color: Colors.red,
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_ministries_screen.title,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddMinistry,
            tooltip: t.go_ministries_screen.add_ministry,
          ),
        ],
      ),
      body: StreamBuilder<List<GoMinistry>>(
        stream: goMinistriesBox == null
            ? Stream.value([])
            : goMinistriesBox.query().watch(triggerImmediately: true).map((query) => query.find()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                t.go_ministries_screen.no_ministries,
                style: TextStyle(
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize,
                ),
              ),
            );
          }

          final ministries = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: ministries.length,
            itemBuilder: (context, index) {
              final ministry = ministries[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.people),
                  ),
                  title: Text(
                    ministry.ministryName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: context.watch<FontProvider>().fontFamily,
                          fontSize: context.watch<FontProvider>().fontSize + 2,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ministry.contactName != null && ministry.contactName!.isNotEmpty)
                        Text(
                          t.go_ministries_screen.contact.replaceAll('{contactName}', ministry.contactName!),
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                      if (ministry.phone != null && ministry.phone!.isNotEmpty)
                        Text(
                          t.go_ministries_screen.phone.replaceAll('{phone}', ministry.phone!),
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                      if (ministry.email != null && ministry.email!.isNotEmpty)
                        Text(
                          t.go_ministries_screen.email.replaceAll('{email}', ministry.email!),
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                      if (ministry.address != null && ministry.address!.isNotEmpty)
                        Text(
                          t.go_ministries_screen.address.replaceAll('{address}', ministry.address!),
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                      if (ministry.partnerStatus != null && ministry.partnerStatus!.isNotEmpty)
                        Text(
                          t.go_ministries_screen.partner_status.replaceAll('{status}', ministry.partnerStatus!),
                          style: TextStyle(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                        ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ministry.phone != null && ministry.phone!.isNotEmpty)
                            Text(
                              'Phone: ${ministry.phone}',
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                          if (ministry.email != null && ministry.email!.isNotEmpty)
                            Text(
                              'Email: ${ministry.email}',
                              style: TextStyle(
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                          if (ministry.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              t.go_ministries_screen.notes,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize,
                              ),
                            ),
                            ...ministry.notes.map((note) => ListTile(
                                  title: quill.QuillEditor.basic(
                                    controller: quill.QuillController(
                                      document: quill.Document.fromJson(jsonDecode(note.content)),
                                      selection: const TextSelection.collapsed(offset: 0),
                                      readOnly: true,
                                    ),
                                  ),
                                  subtitle: Text(
                                    t.go_ministries_screen.created.replaceAll('{date}', DateFormat.yMMMd().format(note.createdAt)),
                                    style: TextStyle(
                                      fontFamily: context.watch<FontProvider>().fontFamily,
                                      fontSize: context.watch<FontProvider>().fontSize - 2,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddNoteScreen(
                                              ministry: ministry,
                                              note: note,
                                            ),
                                          ),
                                        ).then((_) => setState(() {})),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () {
                                          ministry.notes.remove(note);
                                          goMinistryNotesBox.remove(note.id);
                                          goMinistriesBox.put(ministry);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                )).toList(),
                          ],
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _navigateToEditMinistry(ministry),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteMinistry(ministry),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ], // Closing for children of ExpansionTile
                ), // Closing for ExpansionTile
              ); // Closing for Card
            },
          );
        },
      ),
    );
  }
}