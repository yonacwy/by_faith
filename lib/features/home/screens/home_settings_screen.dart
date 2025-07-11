import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:by_faith/app/i18n/strings.g.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:by_faith/objectbox.dart';
import 'package:by_faith/core/models/user_preferences_model.dart';
import '../providers/home_settings_font_provider.dart';
import 'package:by_faith/core/data/bible_parser/bible_parser_flutter.dart' as bp;
import 'package:by_faith/features/study/models/study_bibles_model.dart' as study_models;
import 'package:xml/xml.dart' as xml;
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HomeSettingsScreen extends StatefulWidget {
  const HomeSettingsScreen({super.key});

  @override
  _HomeSettingsScreenState createState() => _HomeSettingsScreenState();
}

class _HomeSettingsScreenState extends State<HomeSettingsScreen> {
  late Locale _selectedLanguage;
  bool _isBiblesInstalledExpanded = false;
  List<study_models.BibleVersion> _installedBibles = [];
  bool _isLoading = false;
  String _loadingMessage = '';
  String? _uploadedFilePath;
  bool _showInstallButton = false;

  @override
  void initState() {
    super.initState();
    _loadInstalledBibles();
    final prefs = getUserPreferences(userPreferencesBox);
    _selectedLanguage = Locale(prefs.languageCode ?? 'en');
  }

  void _loadInstalledBibles() {
    final bibleVersionBox = store.box<study_models.BibleVersion>();
    setState(() {
      _installedBibles = bibleVersionBox.getAll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = TranslationProvider.of(context).locale.flutterLocale;
  }

  void _deleteBible(study_models.BibleVersion bible) {
    final t = Translations.of(context);
    final bibleVersionBox = store.box<study_models.BibleVersion>();
    final bookBox = store.box<study_models.Book>();
    final chapterBox = store.box<study_models.Chapter>();
    final verseBox = store.box<study_models.Verse>();
    final strongsEntryBox = store.box<study_models.StrongsEntry>();

    setState(() {
      _isLoading = true;
      _loadingMessage = t.home_settings_screen.deleting_bible;
    });

    try {
      final bookIds = bible.books.map((book) => book.id).toList();
      final chapterIds = bible.books
          .expand((book) => book.chapters)
          .map((chapter) => chapter.id)
          .toList();
      final verseIds = bible.books
          .expand((book) => book.chapters)
          .expand((chapter) => chapter.verses)
          .map((verse) => verse.id)
          .toList();
      final strongsEntryIds = bible.books
          .expand((book) => book.chapters)
          .expand((chapter) => chapter.verses)
          .expand((verse) => verse.strongsEntries)
          .map((entry) => entry.id)
          .toList();

      store.runInTransaction(TxMode.write, () {
        strongsEntryBox.removeMany(strongsEntryIds);
        verseBox.removeMany(verseIds);
        chapterBox.removeMany(chapterIds);
        bookBox.removeMany(bookIds);
        bibleVersionBox.remove(bible.id);
      });

      final prefs = getUserPreferences(userPreferencesBox);
      if (prefs.currentBibleVersionId == bible.id) {
        prefs.currentBibleVersionId = null;
        userPreferencesBox.put(prefs);
      }

      _showSnackBar(t.home_settings_screen.bible_deleted.replaceAll('{name}', bible.name));
    } catch (e) {
      _showSnackBar('${t.home_settings_screen.delete_failed}: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
      _loadInstalledBibles();
    }
  }

  Future<void> _selectBibleZipFile() async {
    final t = Translations.of(context);
    setState(() {
      _isLoading = true;
      _loadingMessage = t.home_settings_screen.preparing_upload;
      _uploadedFilePath = null;
      _showInstallButton = false;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null && result.files.single.path != null) {
        String? filePath = result.files.single.path;
        if (filePath == null) {
          _showSnackBar(t.home_settings_screen.file_not_selected);
          return;
        }

        File file = File(filePath);
        if (!file.existsSync()) {
          _showSnackBar(t.home_settings_screen.file_not_found);
          return;
        }

        if (!filePath.toLowerCase().endsWith('.zip')) {
          _showSnackBar(t.home_settings_screen.not_a_zip_file);
          return;
        }

        setState(() {
          _uploadedFilePath = filePath;
          _showInstallButton = true;
          _loadingMessage = t.home_settings_screen.file_selected;
        });
        _showSnackBar(t.home_settings_screen.file_selected_success.replaceAll('{name}', p.basename(filePath)));
      } else {
        _showSnackBar(t.home_settings_screen.file_not_selected);
      }
    } catch (e) {
      _showSnackBar('${t.home_settings_screen.upload_failed}: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _installSelectedBible() async {
    final t = Translations.of(context);
    if (_uploadedFilePath == null) {
      _showSnackBar(t.home_settings_screen.no_file_to_install);
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingMessage = t.home_settings_screen.preparing_upload;
    });

    try {
      if (RootIsolateToken.instance == null) {
        throw Exception('RootIsolateToken is null. Ensure it is initialized in main.dart.');
      }

      final startTime = DateTime.now();
      final Map<String, dynamic> parsedData = await compute(
        _extractAndParseBibleData,
        {
          'filePath': _uploadedFilePath!,
          'rootIsolateToken': RootIsolateToken.instance,
        },
      );
      // debugPrint('Extraction took: ${DateTime.now().difference(startTime).inMilliseconds}ms');

      if (parsedData['error'] != null) {
        _showSnackBar('${t.home_settings_screen.install_failed}: ${parsedData['error']}');
        return;
      }

      final String? usfxXmlContent = parsedData['xmlContent'];
      final String? bibleName = parsedData['bibleName'];
      final String? languageCode = parsedData['languageCode'];
      final String extractPath = parsedData['extractPath'];

      if (usfxXmlContent != null && bibleName != null && languageCode != null) {
        setState(() {
          _loadingMessage = t.home_settings_screen.saving_to_database;
        });

        final bibleVersionBox = store.box<study_models.BibleVersion>();
        study_models.BibleVersion? existingVersion = bibleVersionBox
            .query(BibleVersion_.languageCode.equals(languageCode).and(BibleVersion_.name.equals(bibleName)))
            .build()
            .findFirst();

        if (existingVersion != null) {
          _showSnackBar(t.home_settings_screen.bible_already_exists.replaceAll('{name}', bibleName));
          await Directory(extractPath).delete(recursive: true).catchError((e) {
            // debugPrint('Failed to delete temp directory: $e');
          });
          return;
        }

        final newBibleVersion = study_models.BibleVersion(
          name: bibleName,
          languageCode: languageCode,
        );
        final bibleVersionId = bibleVersionBox.put(newBibleVersion);

        final startDbTime = DateTime.now();
        final parsedBibleData = await compute(_parseBibleDataForDb, {
          'xmlContent': usfxXmlContent,
          'bibleVersionId': bibleVersionId,
          'bibleVersionName': bibleName,
          'bibleVersionLanguageCode': languageCode,
        });
        _saveBibleDataToDb(parsedBibleData);
        // debugPrint('Database save took: ${DateTime.now().difference(startDbTime).inMilliseconds}ms');

        final prefs = getUserPreferences(userPreferencesBox);
        prefs.currentBibleVersionId = bibleVersionId;
        userPreferencesBox.put(prefs);

        _showSnackBar(t.home_settings_screen.install_success);
        setState(() {
          _uploadedFilePath = null;
          _showInstallButton = false;
        });
      } else {
        _showSnackBar(t.home_settings_screen.no_xml_found);
      }

      await Directory(extractPath).delete(recursive: true).catchError((e) {
        // debugPrint('Failed to delete temp directory: $e');
      });
    } catch (e) {
      _showSnackBar('${t.home_settings_screen.install_failed}: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
      _loadInstalledBibles();
    }
  }

  static Future<Map<String, dynamic>> _extractAndParseBibleData(Map<String, dynamic> data) async {
    final String filePath = data['filePath'];
    final RootIsolateToken? rootIsolateToken = data['rootIsolateToken'];

    if (rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    } else {
      // debugPrint('RootIsolateToken was null in isolate.');
    }

    Directory? tempDir;
    String? extractPath;

    try {
      File file = File(filePath);
      List<int> bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      tempDir = await getTemporaryDirectory();
      extractPath = p.join(tempDir.path, 'bible_upload_temp');
      final extractDir = Directory(extractPath);

      if (await extractDir.exists()) {
        await extractDir.delete(recursive: true);
      }
      await extractDir.create(recursive: true);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile && filename.toLowerCase().endsWith('.xml')) {
          final data = file.content as List<int>;
          final currentXmlFilePath = p.join(extractPath, filename);
          File(currentXmlFilePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }
      }

      String? usfxXmlFilePath;
      String? metadataXmlFilePath;

      await for (final entity in extractDir.list(recursive: false, followLinks: false)) {
        if (entity is File && entity.path.toLowerCase().endsWith('.xml')) {
          final filename = p.basename(entity.path).toLowerCase();
          if (filename.contains('metadata.xml')) {
            metadataXmlFilePath = entity.path;
          }
          try {
            final xmlContent = await entity.readAsString();
            final xmlDocument = xml.XmlDocument.parse(xmlContent);
            if (xmlDocument.rootElement.name.local == 'usfx') {
              usfxXmlFilePath = entity.path;
            }
          } catch (e) {
            // Ignore non-USFX XML parsing errors
          }
        }
      }

      if (usfxXmlFilePath != null) {
        final xmlContent = await File(usfxXmlFilePath).readAsString();
        final xmlDocument = xml.XmlDocument.parse(xmlContent);
        final usfxElement = xmlDocument.rootElement;

        String bibleName = usfxElement.getAttribute('name') ?? p.basenameWithoutExtension(usfxXmlFilePath);
        final languageCode = usfxElement.getAttribute('lang') ?? 'en';

        if (metadataXmlFilePath != null) {
          try {
            final metadataXmlContent = await File(metadataXmlFilePath).readAsString();
            final metadataXmlDocument = xml.XmlDocument.parse(metadataXmlContent);
            final nameElement = metadataXmlDocument.findAllElements('name').firstWhere(
              (element) => (element.parent is xml.XmlElement) && (element.parent as xml.XmlElement).name.local == 'identification',
              orElse: () => metadataXmlDocument.findAllElements('title').firstOrNull ?? xml.XmlElement(xml.XmlName('name')),
            );
            if (nameElement.innerText.isNotEmpty) {
              bibleName = nameElement.innerText;
            }
          } catch (e) {
            // Ignore metadata parsing errors
          }
        }
        return {
          'xmlContent': xmlContent,
          'bibleName': bibleName,
          'languageCode': languageCode,
          'extractPath': extractPath,
        };
      } else {
        return {'error': 'No USFX XML file found in the ZIP.', 'extractPath': extractPath};
      }
    } catch (e) {
      return {
        'error': e.toString(),
        'extractPath': extractPath ?? p.join((await getTemporaryDirectory()).path, 'bible_upload_temp_error'),
      };
    }
  }

  static Future<Map<String, dynamic>> _parseBibleDataForDb(Map<String, dynamic> data) async {
    final String xmlContent = data['xmlContent'];
    final int bibleVersionId = data['bibleVersionId'];
    final String bibleVersionName = data['bibleVersionName'];
    final String bibleVersionLanguageCode = data['bibleVersionLanguageCode'];

    try {
      final parser = bp.UsfxParser(xmlContent);
      final books = <study_models.Book>[];
      final chapters = <study_models.Chapter>[];
      final verses = <study_models.Verse>[];
      final strongsEntries = <study_models.StrongsEntry>[];
      final footnotes = <study_models.Footnote>[]; // Declare footnotes list

      final bibleVersion = study_models.BibleVersion(
        id: bibleVersionId,
        name: bibleVersionName,
        languageCode: bibleVersionLanguageCode,
      );

      await for (final parsedBook in parser.parseBooks()) {
        final book = study_models.Book(
          name: parsedBook.title,
          bookId: parsedBook.id.toLowerCase(),
        );
        book.bibleVersion.target = bibleVersion;
        books.add(book);

        for (final parsedChapter in parsedBook.chapters) {
          final chapter = study_models.Chapter(
            chapterNumber: parsedChapter.num,
          );
          chapter.book.target = book;
          chapters.add(chapter);

          for (final parsedVerse in parsedChapter.verses) {
            final verse = study_models.Verse(
              verseNumber: parsedVerse.num,
              text: parsedVerse.text,
            );
            verse.chapter.target = chapter;
            verses.add(verse);

            for (final strongsEntry in parsedVerse.strongsEntries) {
              final strongsNumber = strongsEntry['strongsNumber'] as String?;
              final word = strongsEntry['word'] as String?;
              final position = strongsEntry['position'] as int?;
              if (strongsNumber != null && word != null && position != null && strongsNumber.isNotEmpty && word.isNotEmpty) {
                final entry = study_models.StrongsEntry(
                  strongsNumber: strongsNumber,
                  word: word,
                  position: position,
                );
                entry.verse.target = verse;
                strongsEntries.add(entry);
              } else {
                // debugPrint('Invalid Strong\'s entry skipped: $strongsEntry');
              }
            }

            for (final footnoteData in parsedVerse.footnotes) {
              final caller = footnoteData['caller'] as String?;
              final text = footnoteData['text'] as String?;
              if (caller != null && text != null && caller.isNotEmpty && text.isNotEmpty) {
                final footnote = study_models.Footnote(
                  caller: caller,
                  text: text,
                );
                footnote.verse.target = verse;
                footnotes.add(footnote);
              } else {
                // debugPrint('Invalid footnote skipped: $footnoteData');
              }
            }
          }
        }

        // Debug: Print chapters for this book
        final chaptersForBook = chapters.where((c) => c.book.target == book).map((c) => c.chapterNumber).toList();
        // debugPrint('PARSE DEBUG: Book ${book.bookId} (${book.name}) chapters: $chaptersForBook');
      }

      return {
        'books': books,
        'chapters': chapters,
        'verses': verses,
        'strongsEntries': strongsEntries,
        'footnotes': footnotes, // Add footnotes to the returned map
        'bibleVersionId': bibleVersionId,
        'bibleVersionName': bibleVersionName,
        'bibleVersionLanguageCode': bibleVersionLanguageCode,
      };
    } catch (e, stackTrace) {
      // debugPrint('Parse error: $e\n$stackTrace');
      rethrow;
    }
  }

  void _saveBibleDataToDb(Map<String, dynamic> parsedData) {
    final books = parsedData['books'] as List<study_models.Book>;
    final chapters = parsedData['chapters'] as List<study_models.Chapter>;
    final verses = parsedData['verses'] as List<study_models.Verse>;
    final strongsEntries = parsedData['strongsEntries'] as List<study_models.StrongsEntry>;
    final footnotes = parsedData['footnotes'] as List<study_models.Footnote>; // Retrieve footnotes
    final bibleVersionId = parsedData['bibleVersionId'] as int;

    final bookBox = store.box<study_models.Book>();
    final chapterBox = store.box<study_models.Chapter>();
    final verseBox = store.box<study_models.Verse>();
    final footnoteBox = store.box<study_models.Footnote>(); // Get footnote box
    final strongsEntryBox = store.box<study_models.StrongsEntry>();
    final bibleVersionBox = store.box<study_models.BibleVersion>();

    store.runInTransaction(TxMode.write, () {
      // Put all entities
      bookBox.putMany(books);
      chapterBox.putMany(chapters);
      verseBox.putMany(verses);
      strongsEntryBox.putMany(strongsEntries);
      footnoteBox.putMany(footnotes); // Put footnotes into the box

      final bibleVersion = bibleVersionBox.get(bibleVersionId);
      if (bibleVersion != null) {
        bibleVersion.books.addAll(books);
        bibleVersionBox.put(bibleVersion);
      }
    });

    // Debug: Verify Genesis chapters
    final genesisBook = books.firstWhere((b) => b.bookId == 'gen', orElse: () => study_models.Book(name: 'Genesis', bookId: 'gen'));
    final genesisChapters = chapters.where((c) => c.book.targetId == genesisBook.id).map((c) => c.chapterNumber).toList();
    // debugPrint('SAVE DEBUG: Chapters for Genesis: $genesisChapters');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.home_settings_screen.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(_loadingMessage),
                ],
              ),
            ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.home_settings_screen.bible_settings, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.home_settings_screen.bible_install, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        TextField(
                          controller: TextEditingController(text: _uploadedFilePath != null ? p.basename(_uploadedFilePath!) : ''),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: t.home_settings_screen.uploaded_file,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _selectBibleZipFile,
                          icon: const Icon(Icons.cloud_upload),
                          label: Text(t.home_settings_screen.upload_bible),
                        ),
                        if (_showInstallButton) ...[
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _installSelectedBible,
                            icon: const Icon(Icons.install_desktop),
                            label: Text(t.home_settings_screen.install_bible),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Text(t.home_settings_screen.bible_download),
                    leading: const Icon(Icons.download),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.home_settings_screen.download_instructions),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(t.home_settings_screen.bibles_installed),
                    leading: const Icon(Icons.menu_book),
                    initiallyExpanded: _isBiblesInstalledExpanded,
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        _isBiblesInstalledExpanded = expanded;
                      });
                    },
                    children: [
                      _installedBibles.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(t.home_settings_screen.no_bibles_installed),
                            )
                          : Column(
                              children: _installedBibles.map((bible) => ListTile(
                                    title: Text(bible.name),
                                    subtitle: Text(bible.languageCode),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: t.home_settings_screen.delete_bible,
                                      onPressed: () => _confirmAndDeleteBible(bible),
                                    ),
                                  )).toList(),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.home_settings_screen.text_settings, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(t.home_settings_screen.font_family),
                    subtitle: const Text('Roboto'),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      // TODO: Implement Font Family selection
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.home_settings_screen.font_size),
                        Slider(
                          value: context.watch<HomeSettingsFontProvider>().fontSize,
                          min: 10,
                          max: 30,
                          divisions: 20,
                          label: context.watch<HomeSettingsFontProvider>().fontSize.round().toString(),
                          onChanged: (double value) {
                            context.read<HomeSettingsFontProvider>().setFontSize(value);
                          },
                        ),
                        Text(t.home_settings_screen.preview),
                        Text(
                          'For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.',
                          style: TextStyle(fontSize: context.watch<HomeSettingsFontProvider>().fontSize),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.home_settings_screen.global_settings, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(t.home_settings_screen.language_settings, style: Theme.of(context).textTheme.titleMedium),
                  ListTile(
                    title: Text(t.home_settings_screen.app_language),
                    subtitle: Text(_selectedLanguage.languageCode == 'en'
                        ? 'English'
                        : _selectedLanguage.languageCode == 'es'
                            ? 'Spanish'
                            : 'Hindi'),
                    trailing: DropdownButton<Locale>(
                      value: _selectedLanguage,
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          setState(() {
                            _selectedLanguage = newLocale;
                            LocaleSettings.setLocale(AppLocale.values.firstWhere((e) => e.flutterLocale == newLocale));
                            final prefs = getUserPreferences(userPreferencesBox);
                            prefs.languageCode = newLocale.languageCode;
                            userPreferencesBox.put(prefs);
                          });
                        }
                      },
                      items: AppLocaleUtils.supportedLocales.map<DropdownMenuItem<Locale>>((Locale locale) {
                        return DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(locale.languageCode == 'en'
                              ? 'English'
                              : locale.languageCode == 'es'
                                  ? 'Spanish'
                                  : 'Hindi'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAndDeleteBible(study_models.BibleVersion bible) {
    final t = Translations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.home_settings_screen.confirm_delete_title),
          content: Text(t.home_settings_screen.confirm_delete_message.replaceAll('{name}', bible.name)),
          actions: <Widget>[
            TextButton(
              child: Text(t.home_settings_screen.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(t.home_settings_screen.delete),
              onPressed: () {
                _deleteBible(bible);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}