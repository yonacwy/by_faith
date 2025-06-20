import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill_extensions;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

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
        title: const Text('Delete Ministry'),
        content: Text('Are you sure you want to delete ${_ministry.ministryName}? This will delete all associated notes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                SnackBar(content: Text('Ministry ${_ministry.ministryName} deleted')),
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
        title: Text(_isEditing ? 'Ministry Details' : 'Add Ministry'),
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
                  tooltip: 'Add Note',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDetailsScreen(ministry: _ministry),
                    ),
                  ).then((_) => setState(() {})),
                  tooltip: 'Edit Details',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteMinistry,
                  tooltip: 'Delete Ministry',
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
        const Text('Ministry Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildReadOnlyField('Ministry Name', _ministry.ministryName),
        _buildReadOnlyField('Contact Name', _ministry.contactName),
        _buildReadOnlyField('Address', _ministry.address),
        _buildReadOnlyField('Phone', _ministry.phone),
        _buildReadOnlyField('Email', _ministry.email),
        const SizedBox(height: 24),
        const Text('Partner Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildReadOnlyField('Status', _ministry.partnerStatus),
        const SizedBox(height: 24),
        const Text('Map Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildReadOnlyField('Latitude', _ministry.latitude?.toString()),
        _buildReadOnlyField('Longitude', _ministry.longitude?.toString()),
        const SizedBox(height: 24),
        const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value ?? 'Not specified', style: const TextStyle(fontSize: 16)),
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
            subtitle: Text('Created: ${DateFormat.yMMMd().format(note.createdAt)}'),
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
          const SnackBar(content: Text('Ministry added!')),
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
              const Text('Ministry Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: ministryNameController,
                decoration: const InputDecoration(labelText: 'Ministry Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a ministry name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactNameController,
                decoration: const InputDecoration(labelText: 'Contact Name (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter an address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone (Optional)', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
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
                value: partnerStatus,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: partnerStatusOptions.map((String status) {
                  return DropdownMenuItem<String>(value: status, child: Text(status));
                }).toList(),
                onChanged: (String? newValue) => partnerStatus = newValue,
              ),
              const SizedBox(height: 24),
              const Text('Map Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: latitudeController,
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
                controller: longitudeController,
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
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: saveMinistry,
                  child: const Text('Save Ministry'),
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
        title: Text(widget.note != null ? 'Edit Note' : 'Add Note'),
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