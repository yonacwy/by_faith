import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_church_screen.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';


class GoChurchesScreen extends StatefulWidget {
  const GoChurchesScreen({super.key});

  @override
  State<GoChurchesScreen> createState() => _GoChurchesScreenState();
}

class _GoChurchesScreenState extends State<GoChurchesScreen> {
  void _navigateToAddChurch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GoAddEditChurchScreen()),
    );
  }

  void _navigateToEditChurch(GoChurch church) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoAddEditChurchScreen(church: church)),
    );
  }

  void _deleteChurch(GoChurch church) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_churches_screen.delete_church,
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        content: Text(
          t.go_churches_screen.delete_church_confirmation.replaceAll('{churchName}', church.churchName),
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_churches_screen.cancel,
              style: TextStyle(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in church.notes) {
                goChurchNotesBox.remove(note.id);
              }
              goChurchesBox.remove(church.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.go_churches_screen.church_deleted.replaceAll('{churchName}', church.churchName),
                    style: TextStyle(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              t.go_churches_screen.delete,
              style: TextStyle(
                color: Colors.red,
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
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
          t.go_churches_screen.title,
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddChurch,
            tooltip: t.go_churches_screen.add_church,
          ),
        ],
      ),
      body: StreamBuilder<List<GoChurch>>(
        stream: goChurchesBox == null
            ? Stream.value([])
            : goChurchesBox.query().watch(triggerImmediately: true).map((query) => query.find()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                t.go_churches_screen.no_churches,
                style: TextStyle(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
              ),
            );
          }

          final churches = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: churches.length,
            itemBuilder: (context, index) {
              final church = churches[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.church),
                  ),
                  title: Text(
                    church.churchName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (church.pastorName != null && church.pastorName!.isNotEmpty)
                        Text(
                          t.go_churches_screen.pastor.replaceAll('{pastorName}', church.pastorName!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.phone != null && church.phone!.isNotEmpty)
                        Text(
                          t.go_churches_screen.phone.replaceAll('{phone}', church.phone!),
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.email != null && church.email!.isNotEmpty)
                        Text(
                          t.go_churches_screen.email.replaceAll('{email}', church.email!),
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.address != null && church.address!.isNotEmpty)
                        Text(
                          t.go_churches_screen.address.replaceAll('{address}', church.address!),
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.financialStatus != null && church.financialStatus!.isNotEmpty)
                        Text(
                          t.go_churches_screen.financial_status.replaceAll('{status}', church.financialStatus!),
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
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
                          if (church.phone != null && church.phone!.isNotEmpty)
                            Text(
                              'Phone: [200b${church.phone}',
                              style: TextStyle(
                                fontSize: context.watch<FontProvider>().fontSize,
                                fontFamily: context.watch<FontProvider>().fontFamily,
                              ),
                            ),
                          if (church.email != null && church.email!.isNotEmpty)
                            Text(
                              'Email: [200b${church.email}',
                              style: TextStyle(
                                fontSize: context.watch<FontProvider>().fontSize,
                                fontFamily: context.watch<FontProvider>().fontFamily,
                              ),
                            ),
                          if (church.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              t.go_churches_screen.notes,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.watch<FontProvider>().fontSize + 2,
                                fontFamily: context.watch<FontProvider>().fontFamily,
                              ),
                            ),
                            ...church.notes.map((note) => ListTile(
                              title: quill.QuillEditor.basic(
                                controller: quill.QuillController(
                                  document: quill.Document.fromJson(jsonDecode(note.content)),
                                  selection: const TextSelection.collapsed(offset: 0),
                                  readOnly: true,
                                ),
                              ),
                              subtitle: Text(
                                t.go_churches_screen.created.replaceAll('{date}', DateFormat.yMMMd().format(note.createdAt)),
                                style: TextStyle(
                                  fontSize: context.watch<FontProvider>().fontSize - 2,
                                  fontFamily: context.watch<FontProvider>().fontFamily,
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
                                          church: church,
                                          note: note,
                                        ),
                                      ),
                                    ).then((_) => setState(() {})),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                    onPressed: () {
                                      church.notes.remove(note);
                                      goChurchNotesBox.remove(note.id);
                                      goChurchesBox.put(church);
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
                                  onPressed: () => _navigateToEditChurch(church),
                                  tooltip: t.go_churches_screen.edit,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteChurch(church),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}