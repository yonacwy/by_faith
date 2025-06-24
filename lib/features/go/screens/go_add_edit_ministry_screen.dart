import 'package:by_faith/app/i18n/strings.g.dart';
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

class GoAddEditMinistryScreen extends StatefulWidget {
  final GoMinistry? ministry;
  final double? latitude;
  final double? longitude;

  const GoAddEditMinistryScreen({
    super.key,
    this.ministry,
    this.latitude,
    this.longitude,
  });

  @override
  State<GoAddEditMinistryScreen> createState() => _GoAddEditMinistryScreenState();
}

class _GoAddEditMinistryScreenState extends State<GoAddEditMinistryScreen> {
  late bool _isEditing;
  late GoMinistry _ministry;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.ministry != null;
    _ministry = widget.ministry ??
        GoMinistry(
          ministryName: '',
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
  }

  void _deleteMinistry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.go_add_edit_ministry_screen.delete_ministry,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
              ),
        ),
        content: Text(
          t.go_add_edit_ministry_screen.delete_ministry_confirmation.replaceAll('{ministryName}', _ministry.ministryName),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t.go_add_edit_ministry_screen.cancel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in _ministry.notes) {
                goMinistryNotesBox.remove(note.id);
              }
              goMinistriesBox.remove(_ministry.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.go_add_edit_ministry_screen.ministry_deleted.replaceAll('{ministryName}', _ministry.ministryName),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                          fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                        ),
                  ),
                ),
              );
            },
            child: Text(
              t.go_add_edit_ministry_screen.delete,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
          _isEditing ? t.go_add_edit_ministry_screen.ministry_details : t.go_add_edit_ministry_screen.add_ministry,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
              ),
        ),
        actions: _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.note_add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNoteScreen(ministry: _ministry),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: t.go_add_edit_ministry_screen.add_note,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDetailsScreen(ministry: _ministry),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: t.go_add_edit_ministry_screen.edit_details,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteMinistry,
                  tooltip: t.go_add_edit_ministry_screen.delete_ministry,
                ),
              ]
            : [],
      ),
      body: _isEditing ? _buildReadOnlyView() : _buildAddMinistryForm(),
    );
  }

  Widget _buildReadOnlyView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          t.go_add_edit_ministry_screen.ministry_information,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.ministry_name, _ministry.ministryName),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.contact_name, _ministry.contactName),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.address, _ministry.address),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.phone, _ministry.phone),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.email, _ministry.email),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_ministry_screen.partner_status,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.status, _ministry.partnerStatus),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_ministry_screen.map_information,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.latitude, _ministry.latitude?.toString()),
        _buildReadOnlyField(t.go_add_edit_ministry_screen.longitude, _ministry.longitude?.toString()),
        const SizedBox(height: 24),
        Text(
          t.go_add_edit_ministry_screen.notes,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
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
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize - 2,
                ),
          ),
          Text(
            value ?? t.go_add_edit_ministry_screen.not_specified,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
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
      itemCount: _ministry.notes.length,
      itemBuilder: (context, index) {
        final note = _ministry.notes[index];
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
              '${t.go_add_edit_ministry_screen.created}: ${DateFormat.yMMMd().format(note.createdAt)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize - 2,
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
                      builder: (context) => AddNoteScreen(ministry: _ministry, note: note),
                    ),
                  ).then((_) => setState(() {})),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    _ministry.notes.removeAt(index);
                    goMinistryNotesBox.remove(note.id);
                    goMinistriesBox.put(_ministry);
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

  Widget _buildAddMinistryForm() {
    final formKey = GlobalKey<FormState>();
    final ministryNameController = TextEditingController(text: _ministry.ministryName);
    final contactNameController = TextEditingController(text: _ministry.contactName);
    final addressController = TextEditingController(text: _ministry.address);
    final phoneController = TextEditingController(text: _ministry.phone);
    final emailController = TextEditingController(text: _ministry.email);
    final latitudeController = TextEditingController(text: _ministry.latitude?.toString());
    final longitudeController = TextEditingController(text: _ministry.longitude?.toString());
    String? partnerStatus = _ministry.partnerStatus;
    final partnerStatusOptions = ['Confirmed', 'Not-Confirmed', 'Undecided'];

    void saveMinistry() {
      if (formKey.currentState!.validate()) {
        final newMinistry = GoMinistry(
          ministryName: ministryNameController.text,
          contactName: contactNameController.text.isNotEmpty ? contactNameController.text : null,
          address: addressController.text.isNotEmpty ? addressController.text : null,
          phone: phoneController.text.isNotEmpty ? phoneController.text : null,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          latitude: double.tryParse(latitudeController.text),
          longitude: double.tryParse(longitudeController.text),
          partnerStatus: partnerStatus,
        );

        goMinistriesBox.put(newMinistry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ministry added!',
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
                'Ministry Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: ministryNameController,
                decoration: InputDecoration(
                  labelText: 'Ministry Name',
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(
                    fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                  ),
                ),
                style: TextStyle(
                  fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                  fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a ministry name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactNameController,
                decoration: InputDecoration(
                  labelText: 'Contact Name (Optional)',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an address'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone (Optional)',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Partner Status',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: partnerStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                items: partnerStatusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                            fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                          ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) => partnerStatus = newValue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Map Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                        fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
                      ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: Provider.of<FontProvider>(context, listen: false).fontFamily,
                      fontSize: Provider.of<FontProvider>(context, listen: false).fontSize,
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
                  onPressed: saveMinistry,
                  child: Text(
                    'Save Ministry',
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
  final GoMinistry ministry;
  final GoMinistryNote? note;

  const AddNoteScreen({super.key, required this.ministry, this.note});

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
        goMinistryNotesBox.put(widget.note!);
      } else {
        final newNote = GoMinistryNote(
          content: content,
          createdAt: DateTime.now(),
        );
        newNote.ministry.target = widget.ministry;
        goMinistryNotesBox.put(newNote);
        widget.ministry.notes.add(newNote);
        goMinistriesBox.put(widget.ministry);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? 'Edit Note' : 'Add Note',
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
  final GoMinistry ministry;

  const EditDetailsScreen({super.key, required this.ministry});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ministryNameController;
  late TextEditingController _contactNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  String? _partnerStatus;
  final partnerStatusOptions = ['Confirmed', 'Not-Confirmed', 'Undecided'];

  @override
  void initState() {
    super.initState();
    _ministryNameController = TextEditingController(text: widget.ministry.ministryName);
    _contactNameController = TextEditingController(text: widget.ministry.contactName);
    _addressController = TextEditingController(text: widget.ministry.address);
    _phoneController = TextEditingController(text: widget.ministry.phone);
    _emailController = TextEditingController(text: widget.ministry.email);
    _latitudeController = TextEditingController(text: widget.ministry.latitude?.toString());
    _longitudeController = TextEditingController(text: widget.ministry.longitude?.toString());
    _partnerStatus = widget.ministry.partnerStatus;
  }

  @override
  void dispose() {
    _ministryNameController.dispose();
    _contactNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      widget.ministry
        ..ministryName = _ministryNameController.text
        ..contactName = _contactNameController.text.isNotEmpty ? _contactNameController.text : null
        ..address = _addressController.text.isNotEmpty ? _addressController.text : null
        ..phone = _phoneController.text.isNotEmpty ? _phoneController.text : null
        ..email = _emailController.text.isNotEmpty ? _emailController.text : null
        ..latitude = double.tryParse(_latitudeController.text)
        ..longitude = double.tryParse(_longitudeController.text)
        ..partnerStatus = _partnerStatus;

      goMinistriesBox.put(widget.ministry);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ministry updated!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Ministry Details'),
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
                const Text('Ministry Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ministryNameController,
                  decoration: const InputDecoration(labelText: 'Ministry Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a ministry name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactNameController,
                  decoration: const InputDecoration(labelText: 'Contact Name (Optional)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter an address' : null,
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
                const Text('Partner Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _partnerStatus,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                  items: partnerStatusOptions.map((String status) {
                    return DropdownMenuItem<String>(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (String? newValue) => setState(() => _partnerStatus = newValue),
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