import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/screens/study_add_edit_references_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class StudyReferencesScreen extends StatefulWidget {
  final String? initialVerseReference;

  const StudyReferencesScreen({super.key, this.initialVerseReference});

  @override
  State<StudyReferencesScreen> createState() => _StudyReferencesScreenState();
}

class _StudyReferencesScreenState extends State<StudyReferencesScreen> {
  Map<String, List<CrossReference>> _groupedReferences = {};

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  void _loadReferences() {
    final allReferences = crossReferenceBox.getAll();

    _groupedReferences =
        groupBy(allReferences, (reference) => reference.verse);
    setState(() {});
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

    final bibleVersion = store.box<BibleVersion>().getAll().firstOrNull;
    if (bibleVersion == null) return;
    final book = bibleVersion.books.firstWhereOrNull((b) => b.name == bookName);
    if (book == null) return;
    final chapter = book.chapters.firstWhereOrNull((c) => c.chapterNumber == chapterNumber);
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

  void _editReferences(String verseReference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyAddEditReferencesScreen(
          verseReference: verseReference,
        ),
      ),
    ).then((_) => _loadReferences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.study_references_screen.title),
      ),
      body: _groupedReferences.isEmpty
          ? Center(child: Text(t.study_references_screen.no_references))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _groupedReferences.keys.length,
              itemBuilder: (context, index) {
                final verse = _groupedReferences.keys.elementAt(index);
                final references = _groupedReferences[verse]!;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ExpansionTile(
                    title: Text(verse),
                    children: references.map((reference) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 32.0),
                        title: Text(reference.toVerse),
                        onTap: () => _navigateToVerse(reference.toVerse),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: t.study_references_screen.edit_reference,
                              onPressed: () => _editReferences(reference.verse),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: t.study_references_screen.delete_reference,
                              onPressed: () => _deleteReference(reference),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudyTabScreen(
                onVerseSelected: (selectedVerse) {
                  _editReferences(selectedVerse);
                },
              ),
            ),
          );
        },
        tooltip: t.study_references_screen.add_reference,
        child: const Icon(Icons.add),
      ),
    );
  }
}