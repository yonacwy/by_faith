import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_contact_screen.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';


class GoContactsScreen extends StatefulWidget {
  const GoContactsScreen({super.key});

  @override
  State<GoContactsScreen> createState() => _GoContactsScreenState();
}

class _GoContactsScreenState extends State<GoContactsScreen> {
  void _navigateToAddContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GoAddEditContactScreen()),
    );
  }

  void _navigateToEditContact(GoContact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoAddEditContactScreen(contact: contact)),
    );
  }

  void _deleteContact(GoContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_contacts_screen.title,
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        content: Text(
          t.go_contacts_screen.delete_contact_confirmation.replaceAll('{fullName}', contact.fullName),
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_contacts_screen.cancel,
              style: TextStyle(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in contact.notes) {
                goContactNotesBox.remove(note.id);
              }
              goContactsBox.remove(contact.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.go_contacts_screen.contact_deleted.replaceAll('{fullName}', contact.fullName),
                    style: TextStyle(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              t.go_contacts_screen.delete,
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
          t.go_contacts_screen.title,
          style: TextStyle(
            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddContact,
            tooltip: t.go_contacts_screen.add_contact,
          ),
        ],
      ),
      body: StreamBuilder<List<GoContact>>(
        stream: goContactsBox == null
            ? Stream.value([])
            : goContactsBox.query().watch(triggerImmediately: true).map((query) => query.find()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                t.go_contacts_screen.no_contacts,
                style: TextStyle(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
              ),
            );
          }

          final contacts = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    contact.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contact.phone != null && contact.phone!.isNotEmpty)
                        Text(
                          t.go_contacts_screen.phone.replaceAll('{phone}', contact.phone ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                          ),
                        ),
                      if (contact.email != null && contact.email!.isNotEmpty)
                        Text(
                          t.go_contacts_screen.email.replaceAll('{email}', contact.email ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                          ),
                        ),
                      if (contact.address != null && contact.address!.isNotEmpty)
                        Text(
                          t.go_contacts_screen.address.replaceAll('{address}', contact.address ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                          ),
                        ),
                      if (contact.eternalStatus != null && contact.eternalStatus!.isNotEmpty)
                        Text(
                          t.go_contacts_screen.eternal_status.replaceAll('{status}', contact.eternalStatus ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
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
                          if (contact.birthday != null && contact.birthday!.isNotEmpty)
                            Text(
                              t.go_contacts_screen.birthday.replaceAll('{birthday}', contact.birthday ?? ''),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                              ),
                            ),
                          if (contact.phone != null && contact.phone!.isNotEmpty)
                            Text(
                              t.go_contacts_screen.phone.replaceAll('{phone}', contact.phone ?? ''),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                              ),
                            ),
                          if (contact.email != null && contact.email!.isNotEmpty)
                            Text(
                              t.go_contacts_screen.email.replaceAll('{email}', contact.email ?? ''),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                              ),
                            ),
                          if (contact.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              t.go_contacts_screen.notes,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: context.watch<FontProvider>().fontFamily,
                                fontSize: context.watch<FontProvider>().fontSize + 2,
                              ),
                            ),
                            ...contact.notes.map((note) => ListTile(
                                  title: quill.QuillEditor.basic(
                                    controller: quill.QuillController(
                                      document: quill.Document.fromJson(jsonDecode(note.content)),
                                      selection: const TextSelection.collapsed(offset: 0),
                                      readOnly: true,
                                    ),
                                  ),
                                  subtitle: Text(
                                    t.go_contacts_screen.created.replaceAll('{date}', DateFormat.yMMMd().format(note.createdAt)),
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                                              contact: contact,
                                              note: note,
                                            ),
                                          ),
                                        ).then((_) => setState(() {})),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () {
                                          contact.notes.remove(note);
                                          goContactNotesBox.remove(note.id);
                                          goContactsBox.put(contact);
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
                                  onPressed: () => _navigateToEditContact(contact),
                                  tooltip: t.go_contacts_screen.edit,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteContact(contact),
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