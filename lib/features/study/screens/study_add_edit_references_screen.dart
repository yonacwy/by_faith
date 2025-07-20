import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'package:by_faith/features/study/models/study_references_model.dart';
import 'package:by_faith/features/study/models/study_bibles_model.dart';
import 'package:by_faith/features/study/screens/study_tab_screen.dart';
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/objectbox.g.dart';
import 'package:by_faith/features/study/providers/study_references_verse_provider.dart';
import 'package:by_faith/features/study/providers/study_settings_font_provider.dart';
import 'package:provider/provider.dart';

class StudyAddEditReferencesScreen extends StatefulWidget {
  final String verseReference;

  const StudyAddEditReferencesScreen({super.key, required this.verseReference});

  @override
  State<StudyAddEditReferencesScreen> createState() => _StudyAddEditReferencesScreenState();
}

class _StudyAddEditReferencesScreenState extends State<StudyAddEditReferencesScreen> {
  List<Map<String, String>> _jsonReferencesWithText = [];
  List<CrossReference> _userReferences = [];

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    _jsonReferencesWithText = await verseProvider.getJsonReferences(widget.verseReference);
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
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    if (verseReference.contains('-')) {
      verseReference = verseReference.split('-')[0].trim();
    }

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

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.study_add_edit_references_screen.copied_to_clipboard,
          style: TextStyle(fontSize: Provider.of<StudySettingsFontProvider>(context, listen: false).fontSize),
        ),
      ),
    );
  }

  void _selectAllVerses() {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    final textToCopy = [
      ..._userReferences.map((ref) async => '${verseProvider.formatVerseReference(ref.toVerse)}: ${await verseProvider.getVerseText(ref.toVerse)}'),
      ..._jsonReferencesWithText.map((refMap) => Future.value('${verseProvider.formatVerseReference(refMap['toVerse']!)}: ${refMap['verseText']}')),
    ];
    Future.wait(textToCopy).then((texts) {
      _copyText(texts.join('\n'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final verseProvider = Provider.of<StudyReferencesVerseProvider>(context, listen: false);
    final fontProvider = Provider.of<StudySettingsFontProvider>(context);
    final formattedReference = verseProvider.formatVerseReference(widget.verseReference);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.study_add_edit_references_screen.title,
          style: TextStyle(fontSize: fontProvider.fontSize),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              t.study_add_edit_references_screen.current_verse.replaceAll('{verseReference}', formattedReference),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: fontProvider.fontSize),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_userReferences.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.user_references,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: fontProvider.fontSize),
                    ),
                  ),
                  ..._userReferences.map((ref) => FutureBuilder<String>(
                        future: verseProvider.getVerseText(ref.toVerse),
                        builder: (context, snapshot) {
                          final verseText = snapshot.data ?? t.study_add_edit_references_screen.loading;
                          return ListTile(
                            title: SelectionArea(
                              contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                                anchors: state.contextMenuAnchors,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _copyText('${verseProvider.formatVerseReference(ref.toVerse)}: $verseText');
                                      state.hideToolbar();
                                    },
                                    child: Text(
                                      'Copy',
                                      style: TextStyle(fontSize: fontProvider.fontSize),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _selectAllVerses();
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
                                onTap: () => _navigateToVerse(ref.toVerse),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: verseProvider.formatVerseReference(ref.toVerse),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontProvider.fontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' $verseText',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontProvider.fontSize),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: t.study_add_edit_references_screen.delete_reference,
                              onPressed: () => _deleteReference(ref),
                            ),
                          );
                        },
                      )),
                ],
                if (_jsonReferencesWithText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.json_references,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: fontProvider.fontSize),
                    ),
                  ),
                  ..._jsonReferencesWithText.map((refMap) {
                    final ref = refMap['toVerse']!;
                    final verseText = refMap['verseText']!;
                    return ListTile(
                      title: SelectionArea(
                        contextMenuBuilder: (context, state) => AdaptiveTextSelectionToolbar(
                          anchors: state.contextMenuAnchors,
                          children: [
                            TextButton(
                              onPressed: () {
                                _copyText('${verseProvider.formatVerseReference(ref)}: $verseText');
                                state.hideToolbar();
                              },
                              child: Text(
                                'Copy',
                                style: TextStyle(fontSize: fontProvider.fontSize),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _selectAllVerses();
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
                          onTap: () => _navigateToVerse(ref),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: verseProvider.formatVerseReference(ref),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontProvider.fontSize,
                                  ),
                                ),
                                TextSpan(
                                  text: ' $verseText',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontProvider.fontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                if (_jsonReferencesWithText.isEmpty && _userReferences.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.study_add_edit_references_screen.no_references.replaceAll('{verseReference}', formattedReference),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontProvider.fontSize),
                    ),
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