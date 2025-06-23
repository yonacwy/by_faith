import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_church_screen.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/font_provider.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/font_provider.dart';

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
          'Delete Church',
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${church.churchName}?',
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
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
                    'Church ${church.churchName} deleted',
                    style: TextStyle(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Delete',
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
          'Go Churches',
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddChurch,
            tooltip: 'Add Church',
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
                'No churches added yet.',
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
                          'Pastor: ${church.pastorName}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.phone != null && church.phone!.isNotEmpty)
                        Text(
                          'Phone: ${church.phone}',
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.email != null && church.email!.isNotEmpty)
                        Text(
                          'Email: ${church.email}',
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.address != null && church.address!.isNotEmpty)
                        Text(
                          'Address: ${church.address}',
                          style: TextStyle(
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          ),
                        ),
                      if (church.financialStatus != null && church.financialStatus!.isNotEmpty)
                        Text(
                          'Financial Status: ${church.financialStatus}',
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
                              'Phone: ${church.phone}',
                              style: TextStyle(
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                              ),
                            ),
                          if (church.email != null && church.email!.isNotEmpty)
                            Text(
                              'Email: ${church.email}',
                              style: TextStyle(
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                              ),
                            ),
                          if (church.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Notes:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
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
                                'Created: {DateFormat.yMMMd().format(note.createdAt)}',
                                style: TextStyle(
                                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize - 2,
                                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
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