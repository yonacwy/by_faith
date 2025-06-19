import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill_extensions;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _ministryNameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final quill.QuillController _notesController = quill.QuillController.basic();
  bool _isEditing = false;
  String? _selectedPartnerStatus;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _isEditing = widget.ministry != null;
    if (_isEditing) {
      _ministryNameController.text = widget.ministry!.ministryName;
      _contactNameController.text = widget.ministry!.contactName ?? '';
      _addressController.text = widget.ministry!.address ?? '';
      _phoneController.text = widget.ministry!.phone ?? '';
      _emailController.text = widget.ministry!.email ?? '';
      _latitudeController.text = widget.ministry!.latitude?.toString() ?? '';
      _longitudeController.text = widget.ministry!.longitude?.toString() ?? '';
      if (widget.ministry!.notes != null && widget.ministry!.notes!.isNotEmpty) {
        try {
          _notesController.document = quill.Document.fromJson(jsonDecode(widget.ministry!.notes!));
        } catch (e) {
          _notesController.document = quill.Document()..insert(0, widget.ministry!.notes!);
        }
      }
    } else {
      _latitudeController.text = widget.latitude?.toString() ?? '';
      _longitudeController.text = widget.longitude?.toString() ?? '';
    }
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
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    return null;
  }

  void _saveMinistry() {
    if (_formKey.currentState!.validate()) {
      final newMinistry = GoMinistry(
        ministryName: _ministryNameController.text,
        contactName: _contactNameController.text.isNotEmpty ? _contactNameController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        notes: jsonEncode(_notesController.document.toDelta().toJson()),
        partnerStatus: _selectedPartnerStatus,
      );

      if (_isEditing) {
        newMinistry.id = widget.ministry!.id;
      }

      goMinistriesBox.put(newMinistry);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Ministry updated!' : 'Ministry added!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Ministry' : 'Add Ministry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMinistry,
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
                  decoration: const InputDecoration(
                    labelText: 'Ministry Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a ministry name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactNameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name (Optional)',
                    border: OutlineInputBorder(),
                  ),
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
                const Text('Partner Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPartnerStatus,
                  decoration: const InputDecoration(
                    labelText: 'Partner Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Confirmed', 'Not-Confirmed', 'Undecided'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPartnerStatus = newValue;
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
                    onPressed: _saveMinistry,
                    child: const Text('Save Ministry'),
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