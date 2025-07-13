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
import 'package:by_faith/features/home/models/home_model.dart';
import '../providers/home_settings_font_provider.dart';
import 'package:by_faith/core/data/bible_parser/bible_parser_flutter.dart' as bp;
import 'package:by_faith/features/study/models/study_bibles_model.dart' as study_models;
import 'package:xml/xml.dart' as xml;
import 'package:by_faith/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeSettingsScreen extends StatefulWidget {
  const HomeSettingsScreen({super.key});

  @override
  _HomeSettingsScreenState createState() => _HomeSettingsScreenState();
}

class _HomeSettingsScreenState extends State<HomeSettingsScreen> {
  late Locale _selectedLanguage;
  bool _isBiblesInstalledExpanded = false;
  List<study_models.BibleVersion> _installedBibles = [];
  List<BiblesDownload> _downloadableBibles = [];
  List<BiblesDownload> _filteredBibles = [];
  bool _isLoading = false;
  String _loadingMessage = '';
  String? _uploadedFilePath;
  bool _showInstallButton = false;
  int _currentPage = 0;
  final int _pageSize = 100;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInstalledBibles();
    _loadDownloadableBibles();
    final prefs = getUserPreferences(userPreferencesBox);
    _selectedLanguage = Locale(prefs.languageCode ?? 'en');
    _searchController.addListener(_filterBibles);
  }

  void _loadInstalledBibles() {
    final bibleVersionBox = store.box<study_models.BibleVersion>();
    setState(() {
      _installedBibles = bibleVersionBox.getAll();
    });
  }

  void _loadDownloadableBibles() {
    setState(() {
      _downloadableBibles = biblesdownloadBox.getAll();
      _filteredBibles = _downloadableBibles;
    });
  }

  void _filterBibles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _currentPage = 0; // Reset to first page on search
      if (query.isEmpty) {
        _filteredBibles = _downloadableBibles;
      } else {
        _filteredBibles = _downloadableBibles
            .where((bible) => bible.shortTitle.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  List<BiblesDownload> _getCurrentPageBibles() {
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _filteredBibles.length);
    return _filteredBibles.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if ((_currentPage + 1) * _pageSize < _filteredBibles.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
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
      final Map<String, dynamic> parsedData = await compute(
        _extractAndParseBibleData,
        {
          'filePath': _uploadedFilePath!,
          'rootIsolateToken': RootIsolateToken.instance,
        },
      );

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
          await Directory(extractPath).delete(recursive: true).catchError((e) {});
          return;
        }

        final newBibleVersion = study_models.BibleVersion(
          name: bibleName,
          languageCode: languageCode,
        );
        final bibleVersionId = bibleVersionBox.put(newBibleVersion);

        final parsedBibleData = await compute(_parseBibleDataForDb, {
          'xmlContent': usfxXmlContent,
          'bibleVersionId': bibleVersionId,
          'bibleVersionName': bibleName,
          'bibleVersionLanguageCode': languageCode,
        });
        _saveBibleDataToDb(parsedBibleData);

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

      await Directory(extractPath).delete(recursive: true).catchError((e) {});
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

  Future<void> _downloadBible(String url, String name, String shortTitle) async {
    final t = Translations.of(context);
    setState(() {
      _isLoading = true;
      _loadingMessage = t.home_settings_screen.downloading_bible.replaceAll('{name}', shortTitle);
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = p.join(tempDir.path, '${name.replaceAll(' ', '_')}.zip');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _uploadedFilePath = filePath;
          _showInstallButton = true;
          _loadingMessage = t.home_settings_screen.file_selected;
        });
        _showSnackBar(t.home_settings_screen.file_selected_success.replaceAll('{name}', shortTitle));
      } else {
        _showSnackBar(t.home_settings_screen.download_failed);
      }
    } catch (e) {
      _showSnackBar('${t.home_settings_screen.download_failed}: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static Future<Map<String, dynamic>> _extractAndParseBibleData(Map<String, dynamic> data) async {
    final String filePath = data['filePath'];
    final RootIsolateToken? rootIsolateToken = data['rootIsolateToken'];

    if (rootIsolateToken != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
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
          } catch (e) {}
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
          } catch (e) {}
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
      final footnotes = <study_models.Footnote>[];

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
              }
            }
          }
        }
      }

      return {
        'books': books,
        'chapters': chapters,
        'verses': verses,
        'strongsEntries': strongsEntries,
        'footnotes': footnotes,
        'bibleVersionId': bibleVersionId,
        'bibleVersionName': bibleVersionName,
        'bibleVersionLanguageCode': bibleVersionLanguageCode,
      };
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  void _saveBibleDataToDb(Map<String, dynamic> parsedData) {
    final books = parsedData['books'] as List<study_models.Book>;
    final chapters = parsedData['chapters'] as List<study_models.Chapter>;
    final verses = parsedData['verses'] as List<study_models.Verse>;
    final strongsEntries = parsedData['strongsEntries'] as List<study_models.StrongsEntry>;
    final footnotes = parsedData['footnotes'] as List<study_models.Footnote>;
    final bibleVersionId = parsedData['bibleVersionId'] as int;

    final bookBox = store.box<study_models.Book>();
    final chapterBox = store.box<study_models.Chapter>();
    final verseBox = store.box<study_models.Verse>();
    final footnoteBox = store.box<study_models.Footnote>();
    final strongsEntryBox = store.box<study_models.StrongsEntry>();
    final bibleVersionBox = store.box<study_models.BibleVersion>();

    store.runInTransaction(TxMode.write, () {
      bookBox.putMany(books);
      chapterBox.putMany(chapters);
      verseBox.putMany(verses);
      strongsEntryBox.putMany(strongsEntries);
      footnoteBox.putMany(footnotes);

      final bibleVersion = bibleVersionBox.get(bibleVersionId);
      if (bibleVersion != null) {
        bibleVersion.books.addAll(books);
        bibleVersionBox.put(bibleVersion);
      }
    });
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
                    title: const Text('Download Bibles'),
                    leading: const Icon(Icons.download),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: t.home_settings_screen.search_bibles,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      if (_filteredBibles.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('No bibles found.'),
                        )
                      else
                        ..._getCurrentPageBibles().map((bible) {
                          return ListTile(
                            title: Text(bible.shortTitle),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              tooltip: 'Download Bible',
                              onPressed: () => _downloadBible(bible.url, bible.name, bible.shortTitle),
                            ),
                          );
                        }).toList(),
                      if (_filteredBibles.length > _pageSize)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: _currentPage > 0 ? _previousPage : null,
                              ),
                              Text('Page ${_currentPage + 1} of ${(_filteredBibles.length / _pageSize).ceil()}'),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: (_currentPage + 1) * _pageSize < _filteredBibles.length ? _nextPage : null,
                              ),
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
                    children: _installedBibles.isEmpty
                        ? [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(t.home_settings_screen.no_bibles_installed),
                            ),
                          ]
                        : _installedBibles.map((bible) {
                            return ListTile(
                              title: Text(bible.name),
                              subtitle: Text(bible.languageCode),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: t.home_settings_screen.delete_bible,
                                onPressed: () => _confirmAndDeleteBible(bible),
                              ),
                            );
                          }).toList(),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}