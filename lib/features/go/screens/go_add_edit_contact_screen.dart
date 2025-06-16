import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill_extensions;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final quill.QuillController _notesController = quill.QuillController.basic();
  bool _isEditing = false;
  late ScrollController _scrollController;
  String? _eternalStatus; // Added variable for eternal status

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _isEditing = widget.contact != null;
    if (_isEditing) {
      _fullNameController.text = widget.contact!.fullName;
      _addressController.text = widget.contact!.address ?? '';
      _birthdayController.text = widget.contact!.birthday ?? '';
      _phoneController.text = widget.contact!.phone ?? '';
      _emailController.text = widget.contact!.email ?? '';
      _latitudeController.text = widget.contact!.latitude?.toString() ?? '';
      _longitudeController.text = widget.contact!.longitude?.toString() ?? '';
      _eternalStatus = widget.contact!.eternalStatus; // Initialize eternal status
      if (widget.contact!.notes != null) {
        try {
          _notesController.document = quill.Document.fromJson(jsonDecode(widget.contact!.notes!));
        } catch (e) {
          // Fallback for malformed JSON or plain text notes
          _notesController.document = quill.Document()..insert(0, widget.contact!.notes!);
        }
      }
    } else {
      _latitudeController.text = widget.latitude?.toString() ?? '';
      _longitudeController.text = widget.longitude?.toString() ?? '';
    }
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
    _notesController.dispose();
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

  Future<String?> _pickImage(BuildContext context) async {
    final picker = FilePicker.platform;
    final result = await picker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null; // Return null if no image is selected
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final newContact = GoContact(
        fullName: _fullNameController.text,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        birthday: _birthdayController.text.isNotEmpty ? _birthdayController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        notes: jsonEncode(_notesController.document.toDelta().toJson()),
      );

      // If editing, assign the existing ID to the newContact object
      if (_isEditing) {
        newContact.id = widget.contact!.id;
      }

      goContactsBox.put(newContact);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Contact updated!' : 'Contact added!')),
      );
      Navigator.pop(context); // Go back to contacts list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : 'Add Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveContact,
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
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _birthdayController,
                  readOnly: true,
                  onTap: _pickBirthday,
                  decoration: const InputDecoration(
                    labelText: 'Birthday (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    border: OutlineInputBorder(),
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
                const Text('Eternal Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Added Eternal Status section title
                const SizedBox(height: 8),
                DropdownButtonFormField<String>( // Added Dropdown for Eternal Status
                  value: _eternalStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Saved', 'Lost', 'Seed Planted'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _eternalStatus = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const Text('Map Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
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
                  controller: _longitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
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
                const Text('Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
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
                Container(
                  height: 200,
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
                      autoFocus: false,
                      expands: false,
                      padding: const EdgeInsets.all(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveContact,
                    child: const Text('Save Contact'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}