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

class GoAddEditChurchScreen extends StatefulWidget {
  final GoChurch? church;
  final double? latitude;
  final double? longitude;

  const GoAddEditChurchScreen({
    super.key,
    this.church,
    this.latitude,
    this.longitude,
  });

  @override
  State<GoAddEditChurchScreen> createState() => _GoAddEditChurchScreenState();
}

class _GoAddEditChurchScreenState extends State<GoAddEditChurchScreen> {
  late bool _isEditing;
  late GoChurch _church;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.church != null;
    _church = widget.church ??
        GoChurch(
          churchName: '',
          latitude: widget.latitude,
          longitude: widget.longitude,
        );
  }

  void _deleteChurch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Church',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${_church.churchName}? This will delete all associated notes.',
          style: TextStyle(
            fontFamily: context.watch<FontProvider>().fontFamily,
            fontSize: context.watch<FontProvider>().fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: context.watch<FontProvider>().fontFamily,
                fontSize: context.watch<FontProvider>().fontSize,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Remove associated notes
              for (var note in _church.notes) {
                goChurchNotesBox.remove(note.id);
              }
              goChurchesBox.remove(_church.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Church ${_church.churchName} deleted',
                    style: TextStyle(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Delete',
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
          _isEditing ? 'Church Details' : 'Add Church',
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
                      builder: (context) => AddNoteScreen(church: _church),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: 'Add Note',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDetailsScreen(church: _church),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: 'Edit Details',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteChurch,
                  tooltip: 'Delete Church',
                ),
              ]
            : [],
      ),
      body: _isEditing ? _buildReadOnlyView() : _buildAddChurchForm(),
    );
  }

  Widget _buildReadOnlyView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Church Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField('Church Name', _church.churchName),
        _buildReadOnlyField('Pastor Name', _church.pastorName),
        _buildReadOnlyField('Address', _church.address),
        _buildReadOnlyField('Phone', _church.phone),
        _buildReadOnlyField('Email', _church.email),
        const SizedBox(height: 24),
        Text(
          'Financial Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField('Status', _church.financialStatus),
        const SizedBox(height: 24),
        Text(
          'Map Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: context.watch<FontProvider>().fontSize + 2,
                fontWeight: FontWeight.bold,
                fontFamily: context.watch<FontProvider>().fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        _buildReadOnlyField('Latitude', _church.latitude?.toString()),
        _buildReadOnlyField('Longitude', _church.longitude?.toString()),
        const SizedBox(height: 24),
        Text(
          'Notes',
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
            value ?? 'Not specified',
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
      itemCount: _church.notes.length,
      itemBuilder: (context, index) {
        final note = _church.notes[index];
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
              'Created: ${DateFormat.yMMMd().format(note.createdAt)}',
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
                      builder: (context) => AddNoteScreen(church: _church, note: note),
                    ),
                  ).then((_) => setState(() {})),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    _church.notes.removeAt(index);
                    goChurchNotesBox.remove(note.id);
                    goChurchesBox.put(_church);
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

  Widget _buildAddChurchForm() {
    final formKey = GlobalKey<FormState>();
    final churchNameController = TextEditingController(text: _church.churchName);
    final pastorNameController = TextEditingController(text: _church.pastorName);
    final addressController = TextEditingController(text: _church.address);
    final phoneController = TextEditingController(text: _church.phone);
    final emailController = TextEditingController(text: _church.email);
    final latitudeController = TextEditingController(text: _church.latitude?.toString());
    final longitudeController = TextEditingController(text: _church.longitude?.toString());
    String? financialStatus = _church.financialStatus;
    final financialStatusOptions = ['Supporting', 'Not-Supporting', 'Undecided'];

    void saveChurch() {
      if (formKey.currentState!.validate()) {
        final newChurch = GoChurch(
          churchName: churchNameController.text,
          pastorName: pastorNameController.text.isNotEmpty ? pastorNameController.text : null,
          address: addressController.text.isNotEmpty ? addressController.text : null,
          phone: phoneController.text.isNotEmpty ? phoneController.text : null,
          email: emailController.text.isNotEmpty ? emailController.text : null,
          latitude: double.tryParse(latitudeController.text),
          longitude: double.tryParse(longitudeController.text),
          financialStatus: financialStatus,
        );

        goChurchesBox.put(newChurch);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Church added!',
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
                'Church Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: context.watch<FontProvider>().fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: context.watch<FontProvider>().fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: churchNameController,
                decoration: InputDecoration(
                  labelText: 'Church Name',
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
                    ? 'Please enter a church name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: pastorNameController,
                decoration: InputDecoration(
                  labelText: 'Pastor Name (Optional)',
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
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
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
                  labelText: 'Email (Optional)',
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
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Financial Status',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: context.watch<FontProvider>().fontSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: context.watch<FontProvider>().fontFamily,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: financialStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: const OutlineInputBorder(),
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: context.watch<FontProvider>().fontFamily,
                        fontSize: context.watch<FontProvider>().fontSize,
                      ),
                ),
                items: financialStatusOptions.map((String status) {
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
                onChanged: (String? newValue) => financialStatus = newValue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: context.watch<FontProvider>().fontFamily,
                      fontSize: context.watch<FontProvider>().fontSize,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Map Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  onPressed: saveChurch,
                  child: Text(
                    'Save Church',
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
  final GoChurch church;
  final GoChurchNote? note;

  const AddNoteScreen({super.key, required this.church, this.note});

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
        goChurchNotesBox.put(widget.note!);
      } else {
        final newNote = GoChurchNote(
          content: content,
          createdAt: DateTime.now(),
        );
        newNote.church.target = widget.church;
        goChurchNotesBox.put(newNote);
        widget.church.notes.add(newNote);
        goChurchesBox.put(widget.church);
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
  final GoChurch church;

  const EditDetailsScreen({super.key, required this.church});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _churchNameController;
  late TextEditingController _pastorNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  String? _financialStatus;
  final financialStatusOptions = ['Supporting', 'Not-Supporting', 'Undecided'];

  @override
  void initState() {
    super.initState();
    _churchNameController = TextEditingController(text: widget.church.churchName);
    _pastorNameController = TextEditingController(text: widget.church.pastorName);
    _addressController = TextEditingController(text: widget.church.address);
    _phoneController = TextEditingController(text: widget.church.phone);
    _emailController = TextEditingController(text: widget.church.email);
    _latitudeController = TextEditingController(text: widget.church.latitude?.toString());
    _longitudeController = TextEditingController(text: widget.church.longitude?.toString());
    _financialStatus = widget.church.financialStatus;
  }

  @override
  void dispose() {
    _churchNameController.dispose();
    _pastorNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      widget.church
        ..churchName = _churchNameController.text
        ..pastorName = _pastorNameController.text.isNotEmpty ? _pastorNameController.text : null
        ..address = _addressController.text.isNotEmpty ? _addressController.text : null
        ..phone = _phoneController.text.isNotEmpty ? _phoneController.text : null
        ..email = _emailController.text.isNotEmpty ? _emailController.text : null
        ..latitude = double.tryParse(_latitudeController.text)
        ..longitude = double.tryParse(_longitudeController.text)
        ..financialStatus = _financialStatus;

      goChurchesBox.put(widget.church);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Church updated!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Church Details'),
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
                const Text('Church Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _churchNameController,
                  decoration: const InputDecoration(labelText: 'Church Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a church name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pastorNameController,
                  decoration: const InputDecoration(labelText: 'Pastor Name (Optional)', border: OutlineInputBorder()),
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
                const Text('Financial Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _financialStatus,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                  items: financialStatusOptions.map((String status) {
                    return DropdownMenuItem<String>(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (String? newValue) => setState(() => _financialStatus = newValue),
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