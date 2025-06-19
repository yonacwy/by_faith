import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill_extensions;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:by_faith/features/go/models/go_model.dart';
import 'package:by_faith/objectbox.dart';
import 'package:file_picker/file_picker.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _churchNameController = TextEditingController();
  final _pastorNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final quill.QuillController _notesController = quill.QuillController.basic();
  String? _selectedFinancialStatus;
  bool _isEditing = false;
  late ScrollController _scrollController;

  final List<String> _financialStatusOptions = [
    'Supporting',
    'Not-Supporting',
    'Undecided',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _isEditing = widget.church != null;
    if (_isEditing) {
      _churchNameController.text = widget.church!.churchName;
      _pastorNameController.text = widget.church!.pastorName ?? '';
      _addressController.text = widget.church!.address ?? '';
      _phoneController.text = widget.church!.phone ?? '';
      _emailController.text = widget.church!.email ?? '';
      _latitudeController.text = widget.church!.latitude?.toString() ?? '';
      _longitudeController.text = widget.church!.longitude?.toString() ?? '';
      _selectedFinancialStatus = widget.church!.financialStatus;
      if (widget.church!.notes != null && widget.church!.notes!.isNotEmpty) {
        try {
          _notesController.document = quill.Document.fromJson(jsonDecode(widget.church!.notes!));
        } catch (e) {
          _notesController.document = quill.Document()..insert(0, widget.church!.notes!);
        }
      }
    } else {
      _latitudeController.text = widget.latitude?.toString() ?? '';
      _longitudeController.text = widget.longitude?.toString() ?? '';
    }
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

  void _saveChurch() {
    if (_formKey.currentState!.validate()) {
      final newChurch = GoChurch(
        churchName: _churchNameController.text,
        pastorName: _pastorNameController.text.isNotEmpty ? _pastorNameController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        notes: jsonEncode(_notesController.document.toDelta().toJson()),
        financialStatus: _selectedFinancialStatus,
      );

      if (_isEditing) {
        newChurch.id = widget.church!.id;
      }

      goChurchesBox.put(newChurch);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Church updated!' : 'Church added!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Church' : 'Add Church'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChurch,
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
                  decoration: const InputDecoration(
                    labelText: 'Church Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a church name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pastorNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pastor Name (Optional)',
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
                const Text('Financial Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Financial Status',
                  ),
                  value: _selectedFinancialStatus,
                  items: _financialStatusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFinancialStatus = newValue;
                    });
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
                    onPressed: _saveChurch,
                    child: const Text('Save Church'),
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