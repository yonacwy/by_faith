import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/screens/study_references_screen.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:collection/collection.dart';

class StudyAddEditReferencesScreen extends StatefulWidget {
  final String verseReference;

  const StudyAddEditReferencesScreen({super.key, required this.verseReference});

  @override
  State<StudyAddEditReferencesScreen> createState() => _StudyAddEditReferencesScreenState();
}

class _StudyAddEditReferencesScreenState extends State<StudyAddEditReferencesScreen> {
  List<String> _jsonReferences = [];
  List<CrossReference> _userReferences = [];

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    // Load references from cross_references.json
    try {
      final String response = await rootBundle.loadString('lib/features/study/assets/data/cross_references.json');
      final Map<String, dynamic> data = jsonDecode(response);
      _jsonReferences = (data[widget.verseReference] as List<dynamic>?)
              ?.map((item) => item['toVerse'] as String)
              .toList() ??
          [];
    } catch (e) {
      print('Error loading cross-references from JSON: $e');
    }

    // Load user-edited references from crossReferenceBox
    _userReferences = crossReferenceBox
        .query(CrossReference_.verse.equals(widget.verseReference))
        .build()
        .find();

    setState(() {});
  }

  void _addReference() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          onVerseSelected: (selectedVerse) {
            final newReference = CrossReference(verse: widget.verseReference, toVerse: selectedVerse);
            crossReferenceBox.put(newReference);
            _loadReferences();
          },
        ),
      ),
    );
  }

  void _deleteReference(CrossReference reference) {
    crossReferenceBox.remove(reference.id);
    _loadReferences();
  }

  void _navigateToVerse(String verseReference) {
    final parts = verseReference.split('.');
    if (parts.length != 3) return;
    final bookName = parts[0];
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);
    if (chapterNumber == null || verseNumber == null) return;

    final bibleVersion = bibleVersionBox.getAll().firstOrNull;
    if (bibleVersion == null) return;
    final book = bibleVersion.books.toList().firstWhereOrNull((b) => b.name == bookName);
    if (book == null) return;
    final chapter = book.chapters.toList().firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
    if (chapter == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyTabScreen(
          initialBook: book,
          initialChapter: chapter,
          initialVerseNumber: verseNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_add_edit_references_screen.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${t.study_add_edit_references_screen.current_verse.replaceAll('{verseReference}', widget.verseReference)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_jsonReferences.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.json_references,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._jsonReferences.map((ref) => ListTile(
                        title: Text(ref),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(t.study_add_edit_references_screen.add_reference_dialog_title),
                                content: Text(t.study_add_edit_references_screen.add_reference_dialog_content.replaceAll('{toVerse}', ref)),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(t.study_add_edit_references_screen.cancel_button),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(t.study_add_edit_references_screen.add_button),
                                    onPressed: () {
                                      final newReference = CrossReference(verse: widget.verseReference, toVerse: ref);
                                      crossReferenceBox.put(newReference);
                                      _loadReferences();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )),
                ],
                if (_userReferences.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.user_references,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._userReferences.map((ref) => ListTile(
                        title: Text(ref.toVerse),
                        onTap: () => _navigateToVerse(ref.toVerse),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: t.study_add_edit_references_screen.delete_reference,
                          onPressed: () => _deleteReference(ref),
                        ),
                      )),
                ],
                if (_jsonReferences.isEmpty && _userReferences.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(t.study_add_edit_references_screen.no_references),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReference,
        tooltip: t.study_add_edit_references_screen.add_reference,
        child: const Icon(Icons.add),
      ),
    );
  }
}