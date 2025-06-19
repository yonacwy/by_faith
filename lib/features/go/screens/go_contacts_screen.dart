import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/features/go/screens/go_add_edit_contact_screen.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

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
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              goContactsBox.remove(contact.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contact ${contact.fullName} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddContact,
            tooltip: 'Add Contact',
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
            return const Center(child: Text('No contacts added yet.'));
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contact.phone != null && contact.phone!.isNotEmpty)
                        Text('Phone: ${contact.phone}'),
                      if (contact.email != null && contact.email!.isNotEmpty)
                        Text('Email: ${contact.email}'),
                      if (contact.address != null && contact.address!.isNotEmpty)
                        Text('Address: ${contact.address}'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (contact.birthday != null && contact.birthday!.isNotEmpty)
                            Text('Birthday: ${contact.birthday}'),
                          if (contact.phone != null && contact.phone!.isNotEmpty)
                            Text('Phone: ${contact.phone}'),
                          if (contact.email != null && contact.email!.isNotEmpty)
                            Text('Email: ${contact.email}'),
                          if (contact.eternalStatus != null)
                            Text('Eternal Status: ${contact.eternalStatus}'),
                          if (contact.notes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...contact.notes.map((note) => ListTile(
                                  title: quill.QuillEditor.basic(
                                    controller: quill.QuillController(
                                      document: quill.Document.fromJson(jsonDecode(note.content)),
                                      selection: const TextSelection.collapsed(offset: 0),
                                      readOnly: true,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Created: ${DateFormat.yMMMd().format(note.createdAt)}',
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