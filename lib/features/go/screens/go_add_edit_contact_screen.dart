import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill_extensions;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/features/go/providers/go_settings_font_provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';

class GoAddEditContactScreen extends StatefulWidget {
  final GoContact? contact;
  final double? latitude;
  final double? longitude;

  const GoAddEditContactScreen({
    super.key,
    this.contact,
    this.latitude,
    this.longitude,
  });

  @override
  State<GoAddEditContactScreen> createState() => _GoAddEditContactScreenState();
}

class _GoAddEditContactScreenState extends State<GoAddEditContactScreen> {
  late bool _isEditing;
  late GoContact _contact;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.contact != null;
    _contact = widget.contact ??
        GoContact(
          fullName: '',
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
  }

  void _deleteContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_add_edit_contact_screen.delete_contact,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize + 2,
              ),
        ),
        content: Text(
          t.go_add_edit_contact_screen.delete_contact_confirmation.replaceAll('{fullName}', _contact.fullName),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_add_edit_contact_screen.cancel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: context.watch<FontProvider>().fontFamily,
                    fontSize: context.watch<FontProvider>().fontSize,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in _contact.notes) {
                goContactNotesBox.remove(note.id);
              }
              goContactsBox.remove(_contact.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.go_add_edit_contact_screen.contact_deleted.replaceAll('{fullName}', _contact.fullName),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: context.watch<FontProvider>().fontFamily,
                          fontSize: context.watch<FontProvider>().fontSize,
                        ),
                  ),
                ),
              );
            },
            child: Text(
              t.go_add_edit_contact_screen.delete,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
          _isEditing ? t.go_add_edit_contact_screen.contact_details : t.go_add_edit_contact_screen.add_contact,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize + 2,
              ),
        ),
        actions: _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.note_add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNoteScreen(contact: _contact),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: t.go_add_edit_contact_screen.add_note,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDetailsScreen(contact: _contact),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: t.go_add_edit_contact_screen.edit_details,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteContact,
                  tooltip: t.go_add_edit_contact_screen.delete_contact,
                ),
              ]
            : [],
      ),
      body: _isEditing ? _buildReadOnlyView() : _buildAddContactForm(),
    );
  }

  Widget _buildReadOnlyView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          t.go_add_edit_contact_screen.personal_information,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_contact_screen.full_name, _contact.fullName),
        _buildReadOnlyField(t.go_add_edit_contact_screen.address, _contact.address),
        _buildReadOnlyField(t.go_add_edit_contact_screen.birthday, _contact.birthday),
        _buildReadOnlyField(t.go_add_edit_contact_screen.phone, _contact.phone),
        _buildReadOnlyField(t.go_add_edit_contact_screen.email, _contact.email),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_contact_screen.eternal_status,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_contact_screen.status, _contact.eternalStatus),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_contact_screen.map_information,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_contact_screen.latitude, _contact.latitude?.toString()),
        _buildReadOnlyField(t.go_add_edit_contact_screen.longitude, _contact.longitude?.toString()),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_contact_screen.notes,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildNotesList(),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                  fontFamily: context.watch<FontProvider>().fontFamily,
                  fontSize: context.watch<FontProvider>().fontSize - 2,
                ),
          ),
          Text(
            value ?? t.go_add_edit_contact_screen.not_specified,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: context.watch<FontProvider>().fontSize,
                  fontFamily: context.watch<FontProvider>().fontFamily,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _contact.notes.length,
      itemBuilder: (context, index) {
        final note = _contact.notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: quill.QuillEditor.basic(
              controller: quill.QuillController(
                document: quill.Document.fromJson(jsonDecode(note.content)),
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: true,
              ),
            ),
            subtitle: Text(
              '${t.go_add_edit_contact_screen.created}: ${DateFormat.yMMMd().format(note.createdAt)}',
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
                      builder: (context) => AddNoteScreen(contact: _contact, note: note),
                    ),
                  ).then((_) => setState(() {})),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    _contact.notes.removeAt(index);
                    goContactNotesBox.remove(note.id);
                    goContactsBox.put(_contact);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddContactForm() {
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController(text: _contact.fullName);
    final addressController = TextEditingController(text: _contact.address);
    final birthdayController = TextEditingController(text: _contact.birthday);
    final phoneController = TextEditingController(text: _contact.phone);
    final emailController = TextEditingController(text: _contact.email);
    final latitudeController = TextEditingController(text: _contact.latitude?.toString());
    final longitudeController = TextEditingController(text: _contact.longitude?.toString());
    String? eternalStatus = _contact.eternalStatus;

    Future<void> pickBirthday() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null) {
        setState(() {
          birthdayController.text = DateFormat.yMMMd().format(pickedDate);
        });
      }
    }

    void saveContact() {
      if (formKey.currentState!.validate()) {
        final newContact = GoContact(
          fullName: fullNameController.text,
          address: addressController.text.isNotEmpty ? addressController.text : null,
          birthday: birthdayController.text.isNotEmpty ? birthdayController.text : null,
          phone: phoneController.text.isNotEmpty ? phoneController.text : null,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          latitude: double.tryParse(latitudeController.text),
          longitude: double.tryParse(longitudeController.text),
          eternalStatus: eternalStatus,
        );

        goContactsBox.put(newContact);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.go_add_edit_contact_screen.contact_added,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.go_add_edit_contact_screen.personal_information,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: context.watch<FontProvider>().fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: context.watch<FontProvider>().fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.full_name,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                validator: (value) => value == null || value.isEmpty
                    ? t.go_add_edit_contact_screen.please_enter_full_name
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.address,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                validator: (value) => value == null || value.isEmpty
                    ? t.go_add_edit_contact_screen.please_enter_address
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: birthdayController,
                readOnly: true,
                onTap: pickBirthday,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.birthday_optional,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.phone_optional,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.email_optional,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return t.go_add_edit_contact_screen.please_enter_valid_email;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                t.go_add_edit_contact_screen.eternal_status,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: context.watch<FontProvider>().fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: context.watch<FontProvider>().fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: eternalStatus,
                decoration: InputDecoration(
                  labelText: t.go_add_edit_contact_screen.status,
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                items: [
                  t.go_add_edit_contact_screen.saved,
                  t.go_add_edit_contact_screen.lost,
                  t.go_add_edit_contact_screen.seed_planted
                ].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: context.watch<FontProvider>().fontFamily,
                            fontSize: context.watch<FontProvider>().fontSize,
                          ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) => eternalStatus = newValue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                t.go_add_edit_contact_screen.map_information,
                style: TextStyle(
                  fontSize: context.watch<FontProvider>().fontSize + 2,
                  fontWeight: FontWeight.bold,
                  fontFamily: context.watch<FontProvider>().fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a latitude';
                  }
                  try {
                    double.parse(value);
                    return null;
                  } catch (e) {
                    return 'Please enter a valid number';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a longitude';
                  }
                  try {
                    double.parse(value);
                    return null;
                  } catch (e) {
                    return 'Please enter a valid number';
                  }
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: saveContact,
                  child: Text(
                    t.go_add_edit_contact_screen.save_contact,
                    style: TextStyle(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final GoContact contact;
  final GoContactNote? note;

  const AddNoteScreen({super.key, required this.contact, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final quill.QuillController _notesController = quill.QuillController.basic();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.note != null) {
      _notesController.document = quill.Document.fromJson(jsonDecode(widget.note!.content));
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String?> _pickImage(BuildContext context) async {
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(type: FileType.image, allowMultiple: false);
    return result?.files.single.path;
  }

  void _saveNote() {
    final content = jsonEncode(_notesController.document.toDelta().toJson());
    if (content.isNotEmpty) {
      if (widget.note != null) {
        widget.note!.content = content;
        widget.note!.updatedAt = DateTime.now();
        goContactNotesBox.put(widget.note!);
      } else {
        final newNote = GoContactNote(
          content: content,
          createdAt: DateTime.now(),
        );
        newNote.contact.target = widget.contact;
        goContactNotesBox.put(newNote);
        widget.contact.notes.add(newNote);
        goContactsBox.put(widget.contact);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? t.go_add_edit_contact_screen.edit_note : t.go_add_edit_contact_screen.add_note,
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: quill.QuillSimpleToolbar(
                controller: _notesController,
                config: quill.QuillSimpleToolbarConfig(
                  embedButtons: quill_extensions.FlutterQuillEmbeds.toolbarButtons(
                    imageButtonOptions: quill_extensions.QuillToolbarImageButtonOptions(
                      imageButtonConfig: quill_extensions.QuillToolbarImageConfig(
                        onRequestPickImage: _pickImage,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: quill.QuillEditor(
                  controller: _notesController,
                  focusNode: FocusNode(),
                  scrollController: _scrollController,
                  config: quill.QuillEditorConfig(
                    embedBuilders: quill_extensions.FlutterQuillEmbeds.editorBuilders(),
                    scrollable: true,
                    autoFocus: true,
                    expands: true,
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditDetailsScreen extends StatefulWidget {
  final GoContact contact;

  const EditDetailsScreen({super.key, required this.contact});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  String? _eternalStatus;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.contact.fullName);
    _addressController = TextEditingController(text: widget.contact.address);
    _birthdayController = TextEditingController(text: widget.contact.birthday);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
    _latitudeController = TextEditingController(text: widget.contact.latitude?.toString());
    _longitudeController = TextEditingController(text: widget.contact.longitude?.toString());
    _eternalStatus = widget.contact.eternalStatus;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthdayController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      widget.contact
        ..fullName = _fullNameController.text
        ..address = _addressController.text.isNotEmpty ? _addressController.text : null
        ..birthday = _birthdayController.text.isNotEmpty ? _birthdayController.text : null
        ..phone = _phoneController.text.isNotEmpty ? _phoneController.text : null
        ..email = _emailController.text.isNotEmpty ? _emailController.text : null
        ..latitude = double.tryParse(_latitudeController.text)
        ..longitude = double.tryParse(_longitudeController.text)
        ..eternalStatus = _eternalStatus;

      goContactsBox.put(widget.contact);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.go_add_edit_contact_screen.contact_updated)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.go_add_edit_contact_screen.edit_contact_details,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a full name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter an address' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _birthdayController,
                  readOnly: true,
                  onTap: _pickBirthday,
                  decoration: const InputDecoration(labelText: 'Birthday (Optional)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone (Optional)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text('Eternal Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _eternalStatus,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                  items: ['Saved', 'Lost', 'Seed Planted'].map((String status) {
                    return DropdownMenuItem<String>(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (String? newValue) => setState(() => _eternalStatus = newValue),
                ),
                const SizedBox(height: 24),
                const Text('Map Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a latitude';
                    try {
                      double.parse(value);
                      return null;
                    } catch (e) {
                      return 'Please enter a valid number';
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a longitude';
                    try {
                      double.parse(value);
                      return null;
                    } catch (e) {
                      return 'Please enter a valid number';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}