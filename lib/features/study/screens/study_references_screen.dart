import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/features/study/screens/study_add_edit_references_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/study/providers/study_references_verse_provider.dart';
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart';
import 'package:provider/provider.dart';
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
    _groupedReferences = groupBy(allReferences, (reference) => reference.verse);
    setState(() {});
  }

  void _deleteReference(CrossReference reference) {
    crossReferenceBox.remove(reference.id);
    _loadReferences();
  }

  void _navigateToVerse(String verseReference, BuildContext context) {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    final parts = verseReference.split('.');
    if (parts.length != 3) return;
    final bookId = parts[0];
    final mappedBookId = StudyReferencesVerseProvider.bookIdToStorageIdMap[bookId] ??
        StudyReferencesVerseProvider.bookIdToStorageIdMap[bookId.toLowerCase()] ?? bookId.toUpperCase();
    final chapterNumber = int.tryParse(parts[1]);
    final verseNumber = int.tryParse(parts[2]);
    if (chapterNumber == null || verseNumber == null) return;

    final bibleVersion = store.box<BibleVersion>().getAll().isNotEmpty ? store.box<BibleVersion>().getAll().first : null;
    if (bibleVersion == null) return;
    try {
      final book = bibleVersion.books.firstWhere(
        (b) => b.bookId.toUpperCase() == mappedBookId.toUpperCase(),
        orElse: () => throw Exception('Book not found: $mappedBookId'),
      );
      final chapter = book.chapters.firstWhere(
        (c) => c.chapterNumber == chapterNumber,
        orElse: () => throw Exception('Chapter not found: $chapterNumber'),
      );

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
    } catch (e) {
      print('Navigation error: $e');
    }
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

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.study_references_screen.copied_to_clipboard,
          style: TextStyle(fontSize: Provider.of<StudySettingsFontProvider>(context, listen: false).fontSize),
        ),
      ),
    );
  }

  void _selectAllVerses(BuildContext context, List<CrossReference> references) {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    final textToCopy = references
        .map((ref) async => '${verseProvider.formatVerseReference(ref.toVerse)}: ${await verseProvider.getVerseText(ref.toVerse)}')
        .toList();
    Future.wait(textToCopy).then((texts) {
      _copyText(texts.join('\n'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    return Consumer<StudySettingsFontProvider>(
      builder: (context, fontProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              t.study_references_screen.title,
              style: TextStyle(fontSize: fontProvider.fontSize),
            ),
          ),
          body: _groupedReferences.isEmpty
              ? Center(
                  child: Text(
                    t.study_references_screen.no_references,
                    style: TextStyle(fontSize: fontProvider.fontSize),
                  ),
                )
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
                        title: Text(
                          verseProvider.formatVerseReference(verse),
                          style: TextStyle(fontSize: fontProvider.fontSize),
                        ),
                        children: references.map((reference) {
                          return FutureBuilder<String>(
                            future: verseProvider.getVerseText(reference.toVerse),
                            builder: (context, snapshot) {
                              final verseText = snapshot.data ?? t.study_references_screen.loading;
                              return ListTile(
                                contentPadding: const EdgeInsets.only(left: 32.0),
                                title: SelectionArea(
                                  contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                    anchors: state.contextMenuAnchors,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _copyText('${verseProvider.formatVerseReference(reference.toVerse)}: $verseText');
                                          state.hideToolbar();
                                        },
                                        child: Text(
                                          'Copy',
                                          style: TextStyle(fontSize: fontProvider.fontSize),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _selectAllVerses(context, references);
                                          state.hideToolbar();
                                        },
                                        child: Text(
                                          'Select All',
                                          style: TextStyle(fontSize: fontProvider.fontSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _navigateToVerse(reference.toVerse, context),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: verseProvider.formatVerseReference(reference.toVerse),
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontProvider.fontSize,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' $verseText',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  fontSize: fontProvider.fontSize,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                            },
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
      },
    );
  }
}