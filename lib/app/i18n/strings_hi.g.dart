///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsHi implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsHi({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.hi,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <hi>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsHi _root = this; // ignore: unused_field

	@override 
	TranslationsHi $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsHi(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsMainHi main = _TranslationsMainHi._(_root);
	@override late final _TranslationsHomeBuilderScreenHi home_builder_screen = _TranslationsHomeBuilderScreenHi._(_root);
	@override late final _TranslationsHomeJournalScreenHi home_journal_screen = _TranslationsHomeJournalScreenHi._(_root);
	@override late final _TranslationsHomeLibraryScreenHi home_library_screen = _TranslationsHomeLibraryScreenHi._(_root);
	@override late final _TranslationsHomeTabScreenHi home_tab_screen = _TranslationsHomeTabScreenHi._(_root);
	@override late final _TranslationsHomeSettingsScreenHi home_settings_screen = _TranslationsHomeSettingsScreenHi._(_root);
	@override late final _TranslationsGoAddEditAreaScreenHi go_add_edit_area_screen = _TranslationsGoAddEditAreaScreenHi._(_root);
	@override late final _TranslationsGoAddEditChurchScreenHi go_add_edit_church_screen = _TranslationsGoAddEditChurchScreenHi._(_root);
	@override late final _TranslationsGoAddEditContactScreenHi go_add_edit_contact_screen = _TranslationsGoAddEditContactScreenHi._(_root);
	@override late final _TranslationsGoAddEditMinistryScreenHi go_add_edit_ministry_screen = _TranslationsGoAddEditMinistryScreenHi._(_root);
	@override late final _TranslationsGoAddEditStreetScreenHi go_add_edit_street_screen = _TranslationsGoAddEditStreetScreenHi._(_root);
	@override late final _TranslationsGoAddEditZoneScreenHi go_add_edit_zone_screen = _TranslationsGoAddEditZoneScreenHi._(_root);
	@override late final _TranslationsGoChurchesScreenHi go_churches_screen = _TranslationsGoChurchesScreenHi._(_root);
	@override late final _TranslationsGoContactsScreenHi go_contacts_screen = _TranslationsGoContactsScreenHi._(_root);
	@override late final _TranslationsGoExportImportScreenHi go_export_import_screen = _TranslationsGoExportImportScreenHi._(_root);
	@override late final _TranslationsGoMinistriesScreenHi go_ministries_screen = _TranslationsGoMinistriesScreenHi._(_root);
	@override late final _TranslationsGoOfflineMapsScreenHi go_offline_maps_screen = _TranslationsGoOfflineMapsScreenHi._(_root);
	@override late final _TranslationsGoRoutePlannerScreenHi go_route_planner_screen = _TranslationsGoRoutePlannerScreenHi._(_root);
	@override late final _TranslationsGoSearchScreenHi go_search_screen = _TranslationsGoSearchScreenHi._(_root);
	@override late final _TranslationsGoSelectMapAreaScreenHi go_select_map_area_screen = _TranslationsGoSelectMapAreaScreenHi._(_root);
	@override late final _TranslationsGoSelectMapRoutesScreenHi go_select_map_routes_screen = _TranslationsGoSelectMapRoutesScreenHi._(_root);
	@override late final _TranslationsGoSettingsScreenHi go_settings_screen = _TranslationsGoSettingsScreenHi._(_root);
	@override late final _TranslationsGoShareScreenHi go_share_screen = _TranslationsGoShareScreenHi._(_root);
	@override late final _TranslationsGoTabScreenHi go_tab_screen = _TranslationsGoTabScreenHi._(_root);
	@override late final _TranslationsStudyTabScreenHi study_tab_screen = _TranslationsStudyTabScreenHi._(_root);
	@override late final _TranslationsStudySettingsScreenHi study_settings_screen = _TranslationsStudySettingsScreenHi._(_root);
}

// Path: main
class _TranslationsMainHi implements TranslationsMainEn {
	_TranslationsMainHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'मुख्य शीर्षक';
	@override String get home => 'होम';
	@override String get pray => 'प्रार्थना';
	@override String get read => 'पढ़ें';
	@override String get study => 'अध्ययन';
	@override String get go => 'जाओ';
}

// Path: home_builder_screen
class _TranslationsHomeBuilderScreenHi implements TranslationsHomeBuilderScreenEn {
	_TranslationsHomeBuilderScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'निर्माता';
	@override String get content => 'सामग्री';
}

// Path: home_journal_screen
class _TranslationsHomeJournalScreenHi implements TranslationsHomeJournalScreenEn {
	_TranslationsHomeJournalScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'जर्नल';
	@override String get content => 'जर्नल सामग्री';
}

// Path: home_library_screen
class _TranslationsHomeLibraryScreenHi implements TranslationsHomeLibraryScreenEn {
	_TranslationsHomeLibraryScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'पुस्तकालय';
	@override String get content => 'पुस्तकालय सामग्री';
}

// Path: home_tab_screen
class _TranslationsHomeTabScreenHi implements TranslationsHomeTabScreenEn {
	_TranslationsHomeTabScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'होम';
	@override String get menu => 'होम मेनू';
	@override String get info => 'जानकारी';
	@override String get support => 'सहायता';
	@override String get profile => 'प्रोफ़ाइल';
	@override String get builder => 'निर्माता';
	@override String get calendar => 'कैलेंडर';
	@override String get journal => 'जर्नल';
	@override String get library => 'पुस्तकालय';
	@override String get settings => 'सेटिंग्स';
	@override String get content => 'होम टैब सामग्री';
}

// Path: home_settings_screen
class _TranslationsHomeSettingsScreenHi implements TranslationsHomeSettingsScreenEn {
	_TranslationsHomeSettingsScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सेटिंग्स';
	@override String get language => 'भाषा';
	@override String get english => 'अंग्रेज़ी';
	@override String get spanish => 'स्पेनिश';
	@override String get hindi => 'हिंदी';
	@override String get text_settings => 'पाठ सेटिंग्स';
	@override String get font_family => 'फ़ॉन्ट परिवार';
	@override String get font_size => 'फ़ॉन्ट आकार:';
	@override String get preview => 'पूर्वावलोकन:';
	@override String get global_settings => 'वैश्विक सेटिंग्स';
	@override String get language_settings => 'भाषा सेटिंग्स';
	@override String get app_language => 'ऐप भाषा';
	@override String get back => 'वापस';
	@override String get load => 'लोड करें';
}

// Path: go_add_edit_area_screen
class _TranslationsGoAddEditAreaScreenHi implements TranslationsGoAddEditAreaScreenEn {
	_TranslationsGoAddEditAreaScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tap_to_add_points => 'क्षेत्र के लिए बिंदु जोड़ने के लिए मानचित्र पर टैप करें।';
	@override String get cancel => 'रद्द करें';
	@override String get cancel_area_creation => 'क्षेत्र निर्माण रद्द करें';
	@override String get discard_changes_to_area => 'क्या आप इस क्षेत्र में किए गए परिवर्तन हटाना चाहते हैं?';
	@override String get keep_editing => 'संपादन जारी रखें';
	@override String get discard => 'हटाएँ';
	@override String get add_at_least_3_points => 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
	@override String get edit_area => 'क्षेत्र संपादित करें';
	@override String get save_area => 'क्षेत्र सहेजें';
	@override String get hide_options => 'विकल्प छुपाएँ';
	@override String get enter_name => 'नाम दर्ज करें';
	@override String get name => 'नाम';
	@override String get name_cannot_be_empty => 'नाम खाली नहीं हो सकता।';
	@override String get area_saved_successfully => 'क्षेत्र सफलतापूर्वक सहेजा गया।';
	@override String get error_saving_area => 'क्षेत्र सहेजने में त्रुटि: ';
	@override String get add_area_title => 'क्षेत्र जोड़ें';
	@override String get edit_area_title => 'क्षेत्र संपादित करें';
	@override String get view_area_title => 'क्षेत्र देखें';
	@override String get contacts => 'संपर्क';
	@override String get churches => 'चर्च';
	@override String get ministries => 'मंत्रालय';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
}

// Path: go_add_edit_church_screen
class _TranslationsGoAddEditChurchScreenHi implements TranslationsGoAddEditChurchScreenEn {
	_TranslationsGoAddEditChurchScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get delete_church => 'चर्च हटाएँ';
	@override String get delete_church_confirmation => 'क्या आप वाकई {churchName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get church_deleted => 'चर्च {churchName} हटाया गया';
	@override String get church_details => 'चर्च विवरण';
	@override String get add_church => 'चर्च जोड़ें';
	@override String get add_note => 'नोट जोड़ें';
	@override String get edit_details => 'विवरण संपादित करें';
	@override String get church_information => 'चर्च जानकारी';
	@override String get church_name => 'चर्च का नाम';
	@override String get pastor_name => 'पादरी का नाम';
	@override String get address => 'पता';
	@override String get phone => 'फोन';
	@override String get email => 'ईमेल';
	@override String get not_specified => 'निर्दिष्ट नहीं';
	@override String get financial_status => 'वित्तीय स्थिति';
	@override String get status => 'स्थिति';
	@override String get map_information => 'मानचित्र जानकारी';
	@override String get latitude => 'अक्षांश';
	@override String get longitude => 'देशांतर';
	@override String get notes => 'नोट्स';
	@override String get created => 'निर्मित';
	@override String get pastor_name_optional => 'पादरी का नाम (वैकल्पिक)';
	@override String get please_enter_church_name => 'कृपया चर्च का नाम दर्ज करें';
	@override String get please_enter_address => 'कृपया पता दर्ज करें';
	@override String get phone_optional => 'फोन (वैकल्पिक)';
	@override String get email_optional => 'ईमेल (वैकल्पिक)';
	@override String get please_enter_valid_email => 'कृपया मान्य ईमेल दर्ज करें';
	@override String get supporting => 'समर्थन कर रहे हैं';
	@override String get not_supporting => 'समर्थन नहीं कर रहे हैं';
	@override String get undecided => 'अनिर्णीत';
	@override String get church_added => 'चर्च जोड़ा गया!';
	@override String get please_enter_latitude => 'कृपया अक्षांश दर्ज करें';
	@override String get please_enter_longitude => 'कृपया देशांतर दर्ज करें';
	@override String get please_enter_valid_number => 'कृपया मान्य संख्या दर्ज करें';
}

// Path: go_add_edit_contact_screen
class _TranslationsGoAddEditContactScreenHi implements TranslationsGoAddEditContactScreenEn {
	_TranslationsGoAddEditContactScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get delete_contact => 'संपर्क हटाएँ';
	@override String get delete_contact_confirmation => 'क्या आप वाकई {fullName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get contact_deleted => 'संपर्क {fullName} हटाया गया';
	@override String get contact_details => 'संपर्क विवरण';
	@override String get add_contact => 'संपर्क जोड़ें';
	@override String get add_note => 'नोट जोड़ें';
	@override String get edit_details => 'विवरण संपादित करें';
	@override String get personal_information => 'व्यक्तिगत जानकारी';
	@override String get full_name => 'पूरा नाम';
	@override String get address => 'पता';
	@override String get birthday => 'जन्मदिन';
	@override String get phone => 'फोन';
	@override String get email => 'ईमेल';
	@override String get not_specified => 'निर्दिष्ट नहीं';
	@override String get eternal_status => 'अनंत स्थिति';
	@override String get status => 'स्थिति';
	@override String get map_information => 'मानचित्र जानकारी';
	@override String get latitude => 'अक्षांश';
	@override String get longitude => 'देशांतर';
	@override String get notes => 'नोट्स';
	@override String get created => 'निर्मित';
	@override String get please_enter_full_name => 'कृपया पूरा नाम दर्ज करें';
	@override String get please_enter_address => 'कृपया पता दर्ज करें';
	@override String get birthday_optional => 'जन्मदिन (वैकल्पिक)';
	@override String get phone_optional => 'फोन (वैकल्पिक)';
	@override String get email_optional => 'ईमेल (वैकल्पिक)';
	@override String get please_enter_valid_email => 'कृपया मान्य ईमेल दर्ज करें';
	@override String get saved => 'सहेजा गया';
	@override String get lost => 'खो गया';
	@override String get seed_planted => 'बीज बोया गया';
	@override String get contact_added => 'संपर्क जोड़ा गया!';
	@override String get save_contact => 'संपर्क सहेजें';
	@override String get edit_note => 'नोट संपादित करें';
	@override String get contact_updated => 'संपर्क अपडेट किया गया!';
	@override String get edit_contact_details => 'संपर्क विवरण संपादित करें';
}

// Path: go_add_edit_ministry_screen
class _TranslationsGoAddEditMinistryScreenHi implements TranslationsGoAddEditMinistryScreenEn {
	_TranslationsGoAddEditMinistryScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get delete_ministry => 'मंत्रालय हटाएँ';
	@override String get delete_ministry_confirmation => 'क्या आप वाकई {ministryName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get ministry_deleted => 'मंत्रालय {ministryName} हटाया गया';
	@override String get ministry_details => 'मंत्रालय विवरण';
	@override String get add_ministry => 'मंत्रालय जोड़ें';
	@override String get add_note => 'नोट जोड़ें';
	@override String get edit_details => 'विवरण संपादित करें';
	@override String get ministry_information => 'मंत्रालय जानकारी';
	@override String get ministry_name => 'मंत्रालय का नाम';
	@override String get contact_name => 'संपर्क नाम';
	@override String get address => 'पता';
	@override String get phone => 'फोन';
	@override String get email => 'ईमेल';
	@override String get not_specified => 'निर्दिष्ट नहीं';
	@override String get partner_status => 'साझेदार स्थिति';
	@override String get status => 'स्थिति';
	@override String get map_information => 'मानचित्र जानकारी';
	@override String get latitude => 'अक्षांश';
	@override String get longitude => 'देशांतर';
	@override String get notes => 'नोट्स';
	@override String get created => 'निर्मित';
	@override String get please_enter_ministry_name => 'कृपया मंत्रालय का नाम दर्ज करें';
	@override String get please_enter_address => 'कृपया पता दर्ज करें';
	@override String get phone_optional => 'फोन (वैकल्पिक)';
	@override String get email_optional => 'ईमेल (वैकल्पिक)';
	@override String get please_enter_valid_email => 'कृपया मान्य ईमेल दर्ज करें';
	@override String get confirmed => 'पुष्टि की गई';
	@override String get not_confirmed => 'पुष्टि नहीं की गई';
	@override String get undecided => 'अनिर्णीत';
	@override String get ministry_added => 'मंत्रालय जोड़ा गया!';
	@override String get please_enter_latitude => 'कृपया अक्षांश दर्ज करें';
	@override String get please_enter_longitude => 'कृपया देशांतर दर्ज करें';
	@override String get please_enter_valid_number => 'कृपया मान्य संख्या दर्ज करें';
}

// Path: go_add_edit_street_screen
class _TranslationsGoAddEditStreetScreenHi implements TranslationsGoAddEditStreetScreenEn {
	_TranslationsGoAddEditStreetScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tap_to_add_points => 'बिंदु जोड़ने के लिए मानचित्र पर टैप करें।';
	@override String get cancel => 'रद्द करें';
	@override String get cancel_creation => 'निर्माण रद्द करें';
	@override String get discard_changes => 'क्या आप इस रूट में किए गए परिवर्तन हटाना चाहते हैं?';
	@override String get keep_editing => 'संपादन जारी रखें';
	@override String get discard => 'हटाएँ';
	@override String get add_at_least_2_points => 'रूट बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
	@override String get enter_name => 'नाम दर्ज करें';
	@override String get name => 'नाम';
	@override String get name_cannot_be_empty => 'नाम खाली नहीं हो सकता।';
	@override String get save => 'सहेजें';
	@override String get edit => 'संपादित करें';
	@override String get route_saved_successfully => 'रूट सफलतापूर्वक सहेजा गया।';
	@override String get error_saving_route => 'रूट सहेजने में त्रुटि: {error}';
	@override String get contacts => 'संपर्क';
	@override String get churches => 'चर्च';
	@override String get ministries => 'मंत्रालय';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get view => 'देखें';
	@override String get add => 'जोड़ें';
	@override String get hide_options => 'विकल्प छुपाएँ';
	@override String get zoom_in => 'ज़ूम इन';
	@override String get zoom_out => 'ज़ूम आउट';
	@override String get add_point => 'बिंदु जोड़ें';
	@override String get remove_point => 'बिंदु हटाएँ';
	@override String get street => 'सड़क';
	@override String get river => 'नदी';
	@override String get path => 'पथ';
	@override String get view_street_title => 'सड़क देखें';
	@override String get edit_street_title => 'सड़क संपादित करें';
	@override String get add_street_title => 'सड़क जोड़ें';
	@override String get save_street => 'सड़क सहेजें';
}

// Path: go_add_edit_zone_screen
class _TranslationsGoAddEditZoneScreenHi implements TranslationsGoAddEditZoneScreenEn {
	_TranslationsGoAddEditZoneScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get tap_to_set_center => 'ज़ोन केंद्र सेट करने के लिए मानचित्र पर टैप करें।';
	@override String get cancel => 'रद्द करें';
	@override String get cancel_zone_creation => 'ज़ोन निर्माण रद्द करें';
	@override String get discard_changes => 'क्या आप इस ज़ोन में किए गए परिवर्तन हटाना चाहते हैं?';
	@override String get keep_editing => 'संपादन जारी रखें';
	@override String get discard => 'हटाएँ';
	@override String get enter_name => 'नाम दर्ज करें';
	@override String get name => 'नाम';
	@override String get name_cannot_be_empty => 'नाम खाली नहीं हो सकता।';
	@override String get save => 'सहेजें';
	@override String get edit => 'संपादित करें';
	@override String get zone_saved_successfully => 'ज़ोन सफलतापूर्वक सहेजा गया।';
	@override String get error_saving_zone => 'ज़ोन सहेजने में त्रुटि: {error}';
	@override String get contacts => 'संपर्क';
	@override String get churches => 'चर्च';
	@override String get ministries => 'मंत्रालय';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get view => 'देखें';
	@override String get add => 'जोड़ें';
	@override String get hide_options => 'विकल्प छुपाएँ';
	@override String get zoom_in => 'ज़ूम इन';
	@override String get zoom_out => 'ज़ूम आउट';
	@override String get increase_radius => 'त्रिज्या बढ़ाएँ';
	@override String get decrease_radius => 'त्रिज्या घटाएँ';
	@override String get set_center => 'केंद्र सेट करें';
	@override String get view_zone_title => 'क्षेत्र देखें';
	@override String get edit_zone_title => 'क्षेत्र संपादित करें';
	@override String get add_zone_title => 'क्षेत्र जोड़ें';
	@override String get save_zone => 'क्षेत्र सहेजें';
}

// Path: go_churches_screen
class _TranslationsGoChurchesScreenHi implements TranslationsGoChurchesScreenEn {
	_TranslationsGoChurchesScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'गो चर्च';
	@override String get add_church => 'चर्च जोड़ें';
	@override String get delete_church => 'चर्च हटाएँ';
	@override String get delete_church_confirmation => 'क्या आप वाकई {churchName} को हटाना चाहते हैं?';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get church_deleted => 'चर्च {churchName} हटाया गया';
	@override String get no_churches => 'अभी तक कोई चर्च नहीं जोड़ा गया है।';
	@override String get pastor => 'पादरी: {pastorName}';
	@override String get phone => 'फोन: {phone}';
	@override String get email => 'ईमेल: {email}';
	@override String get address => 'पता: {address}';
	@override String get financial_status => 'वित्तीय स्थिति: {status}';
	@override String get notes => 'नोट्स:';
	@override String get created => 'निर्मित: {date}';
	@override String get edit => 'संपादित करें';
}

// Path: go_contacts_screen
class _TranslationsGoContactsScreenHi implements TranslationsGoContactsScreenEn {
	_TranslationsGoContactsScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'गो संपर्क';
	@override String get add_contact => 'संपर्क जोड़ें';
	@override String get delete_contact => 'संपर्क हटाएँ';
	@override String get delete_contact_confirmation => 'क्या आप वाकई {fullName} को हटाना चाहते हैं?';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get contact_deleted => 'संपर्क {fullName} हटाया गया';
	@override String get no_contacts => 'अभी तक कोई संपर्क नहीं जोड़ा गया है।';
	@override String get full_name => 'पूरा नाम';
	@override String get phone => 'फोन: {phone}';
	@override String get email => 'ईमेल: {email}';
	@override String get address => 'पता: {address}';
	@override String get eternal_status => 'अनंत स्थिति: {status}';
	@override String get birthday => 'जन्मदिन: {birthday}';
	@override String get notes => 'नोट्स:';
	@override String get created => 'निर्मित: {date}';
	@override String get edit => 'संपादित करें';
}

// Path: go_export_import_screen
class _TranslationsGoExportImportScreenHi implements TranslationsGoExportImportScreenEn {
	_TranslationsGoExportImportScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'निर्यात/आयात';
	@override String get export_data => 'डेटा निर्यात करें';
	@override String get import_data => 'डेटा आयात करें';
	@override String get churches => 'चर्च';
	@override String get contacts => 'संपर्क';
	@override String get ministries => 'मंत्रालय';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get all => 'सभी';
	@override String get no_churches => 'कोई चर्च उपलब्ध नहीं है';
	@override String get no_contacts => 'कोई संपर्क उपलब्ध नहीं है';
	@override String get no_ministries => 'कोई मंत्रालय उपलब्ध नहीं है';
	@override String get no_areas => 'कोई क्षेत्र उपलब्ध नहीं है';
	@override String get no_streets => 'कोई सड़क उपलब्ध नहीं है';
	@override String get no_zones => 'कोई ज़ोन उपलब्ध नहीं है';
	@override String get save_json => '{type} JSON सहेजें';
	@override String get select_json => '{type} JSON चुनें';
	@override String get export_success => '{type} सफलतापूर्वक निर्यात किया गया';
	@override String get import_success => '{type} सफलतापूर्वक आयात किया गया';
	@override String get error_export => '{type} निर्यात करने में त्रुटि: {error}';
	@override String get error_import => '{type} आयात करने में त्रुटि: {error}';
	@override String get invalid_file => 'अमान्य फ़ाइल: अपेक्षित {type} डेटा';
	@override String get all_export_success => 'सभी डेटा सफलतापूर्वक निर्यात किए गए';
	@override String get all_import_success => 'सभी डेटा सफलतापूर्वक आयात किए गए';
	@override String get error_export_all => 'सभी डेटा निर्यात करने में त्रुटि: {error}';
	@override String get error_import_all => 'सभी डेटा आयात करने में त्रुटि: {error}';
}

// Path: go_ministries_screen
class _TranslationsGoMinistriesScreenHi implements TranslationsGoMinistriesScreenEn {
	_TranslationsGoMinistriesScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'गो मंत्रालय';
	@override String get add_ministry => 'मंत्रालय जोड़ें';
	@override String get delete_ministry => 'मंत्रालय हटाएँ';
	@override String get delete_ministry_confirmation => 'क्या आप वाकई {ministryName} को हटाना चाहते हैं?';
	@override String get cancel => 'रद्द करें';
	@override String get delete => 'हटाएँ';
	@override String get ministry_deleted => 'मंत्रालय {ministryName} हटाया गया';
	@override String get no_ministries => 'अभी तक कोई मंत्रालय नहीं जोड़ा गया है।';
	@override String get contact => 'संपर्क: {contactName}';
	@override String get phone => 'फोन: {phone}';
	@override String get email => 'ईमेल: {email}';
	@override String get address => 'पता: {address}';
	@override String get partner_status => 'साझेदार स्थिति: {status}';
	@override String get notes => 'नोट्स:';
	@override String get created => 'निर्मित: {date}';
	@override String get edit => 'संपादित करें';
}

// Path: go_offline_maps_screen
class _TranslationsGoOfflineMapsScreenHi implements TranslationsGoOfflineMapsScreenEn {
	_TranslationsGoOfflineMapsScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'ऑफ़लाइन मानचित्र';
	@override String get select_your_own_map => 'अपना स्वयं का मानचित्र चुनें';
	@override String get downloaded_maps => 'डाउनलोड किए गए मानचित्र';
	@override String get no_maps_downloaded => 'अभी तक कोई मानचित्र डाउनलोड नहीं किया गया है।';
	@override String get max_maps_warning => 'आप केवल 5 मानचित्र (डिफ़ॉल्ट वर्ल्ड मानचित्र सहित) रख सकते हैं। कृपया नया मानचित्र डाउनलोड करने से पहले एक मानचित्र हटाएँ।';
	@override String get failed_to_delete_map => 'मानचित्र हटाने में विफल ({mapName}): {error}';
	@override String get rename_map => 'मानचित्र का नाम बदलें';
	@override String get enter_new_map_name => 'नया मानचित्र नाम दर्ज करें';
	@override String get cancel => 'रद्द करें';
	@override String get save => 'सहेजें';
	@override String get failed_to_rename_map => 'मानचित्र का नाम बदलने में विफल: {error}';
	@override String get view => 'देखें';
	@override String get update => 'अपडेट करें';
	@override String get rename => 'नाम बदलें';
	@override String get delete => 'हटाएँ';
	@override String get world => 'विश्व';
	@override String get map_updated_successfully => 'मानचित्र "{mapName}" सफलतापूर्वक अपडेट किया गया';
	@override String get failed_to_update_map => 'मानचित्र अपडेट करने में विफल: {error}';
}

// Path: go_route_planner_screen
class _TranslationsGoRoutePlannerScreenHi implements TranslationsGoRoutePlannerScreenEn {
	_TranslationsGoRoutePlannerScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'रूट प्लानर';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get no_areas => 'अभी तक कोई क्षेत्र नहीं जोड़ा गया है।';
	@override String get no_streets => 'अभी तक कोई सड़क नहीं जोड़ी गई है।';
	@override String get no_zones => 'अभी तक कोई ज़ोन नहीं जोड़ा गया है।';
	@override String get edit => 'संपादित करें';
	@override String get rename => 'नाम बदलें';
	@override String get delete => 'हटाएँ';
	@override String get view => 'देखें';
	@override String get add => 'जोड़ें';
	@override String get lat => 'अक्षांश: {lat}';
	@override String get lon => 'देशांतर: {lon}';
	@override String get no_coordinates => 'कोई निर्देशांक नहीं';
	@override String get failed_to_delete => '{type} हटाने में विफल: {error}';
	@override String get failed_to_rename => '{type} का नाम बदलने में विफल: {error}';
	@override String get rename_type => '{type} का नाम बदलें';
	@override String get enter_new_name => 'नया नाम दर्ज करें';
	@override String get cancel => 'रद्द करें';
	@override String get save => 'सहेजें';
}

// Path: go_search_screen
class _TranslationsGoSearchScreenHi implements TranslationsGoSearchScreenEn {
	_TranslationsGoSearchScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'पता खोजें';
	@override String get enter_address => 'पता दर्ज करें';
	@override String get please_enter_address => 'कृपया पता दर्ज करें।';
	@override String get address_not_found => 'पता नहीं मिला।';
	@override String get found => 'मिला: {displayName}';
	@override String get latitude => 'अक्षांश: {lat}';
	@override String get longitude => 'देशांतर: {lon}';
	@override String get error_searching_address => 'पता खोजने में त्रुटि: {error}';
	@override String get search => 'खोजें';
}

// Path: go_select_map_area_screen
class _TranslationsGoSelectMapAreaScreenHi implements TranslationsGoSelectMapAreaScreenEn {
	_TranslationsGoSelectMapAreaScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'मानचित्र क्षेत्र चुनें';
	@override String get download_limit_exceeded => 'डाउनलोड सीमा पार हो गई';
	@override String get download_limit_message => 'चयनित क्षेत्र अधिकतम सीमा (12,000 टाइल्स या 155.55 MB) से अधिक है। कृपया छोटा क्षेत्र चुनें।';
	@override String get ok => 'ठीक है';
	@override String get download_map => 'मानचित्र डाउनलोड करें';
	@override String get download_map_question => 'क्या आप इस क्षेत्र का मानचित्र डाउनलोड करना चाहते हैं? अनुमानित टाइल्स: {tiles}, लगभग {size} MB।';
	@override String get close => 'बंद करें';
	@override String get name_your_map => 'अपने मानचित्र का नाम दें';
	@override String get enter_map_name => 'मानचित्र नाम दर्ज करें';
	@override String get cancel => 'रद्द करें';
	@override String get download => 'डाउनलोड करें';
}

// Path: go_select_map_routes_screen
class _TranslationsGoSelectMapRoutesScreenHi implements TranslationsGoSelectMapRoutesScreenEn {
	_TranslationsGoSelectMapRoutesScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'मानचित्र रूट चुनें';
	@override String get select => 'चुनें';
	@override String get edit => 'संपादित करें';
	@override String get view => 'देखें';
	@override String get area => 'क्षेत्र';
	@override String get street => 'सड़क';
	@override String get tag => 'टैग';
	@override String get add_at_least_3_points => 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
	@override String get add_at_least_2_points => 'सड़क बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
	@override String get add_a_tag => 'सहेजने के लिए टैग जोड़ें।';
	@override String get enter_name => 'नाम दर्ज करें';
	@override String get name => 'नाम';
	@override String get name_cannot_be_empty => 'नाम खाली नहीं हो सकता।';
	@override String get save => 'सहेजें';
	@override String get cancel => 'रद्द करें';
	@override String get tag_text => 'टैग पाठ';
	@override String get enter_tag_text => 'टैग पाठ दर्ज करें';
	@override String get error_loading_item => 'आइटम लोड करने में त्रुटि: {error}';
	@override String get error_adding_point => 'बिंदु जोड़ने में त्रुटि: {error}';
	@override String get error_saving_item => 'आइटम सहेजने में त्रुटि: {error}';
	@override String get zoom_in => 'ज़ूम इन';
	@override String get zoom_out => 'ज़ूम आउट';
}

// Path: go_settings_screen
class _TranslationsGoSettingsScreenHi implements TranslationsGoSettingsScreenEn {
	_TranslationsGoSettingsScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सेटिंग्स';
	@override String get text_settings => 'पाठ सेटिंग्स';
	@override String get font_family => 'फ़ॉन्ट परिवार';
	@override String get font_size => 'फ़ॉन्ट आकार:';
	@override String get preview => 'पूर्वावलोकन:';
	@override String get back => 'वापस';
	@override String get load => 'लोड करें';
	@override String get sample_text => 'और उसने उनसे कहा, सारी दुनिया में जाकर सब प्राणी को सुसमाचार प्रचार करो।';
}

// Path: go_share_screen
class _TranslationsGoShareScreenHi implements TranslationsGoShareScreenEn {
	_TranslationsGoShareScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'साझा करें';
	@override String get churches => 'चर्च';
	@override String get contacts => 'संपर्क';
	@override String get ministries => 'मंत्रालय';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get all => 'सभी';
	@override String get no_churches => 'कोई चर्च उपलब्ध नहीं है';
	@override String get no_contacts => 'कोई संपर्क उपलब्ध नहीं है';
	@override String get no_ministries => 'कोई मंत्रालय उपलब्ध नहीं है';
	@override String get no_areas => 'कोई क्षेत्र उपलब्ध नहीं है';
	@override String get no_streets => 'कोई सड़क उपलब्ध नहीं है';
	@override String get no_zones => 'कोई ज़ोन उपलब्ध नहीं है';
	@override String get share_all_data => 'सभी डेटा साझा करें';
	@override String get all_by_faith_data => 'सभी बाय फेथ डेटा';
	@override String get could_not_launch_email => 'ईमेल क्लाइंट लॉन्च नहीं कर सके';
}

// Path: go_tab_screen
class _TranslationsGoTabScreenHi implements TranslationsGoTabScreenEn {
	_TranslationsGoTabScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get markers_in_zone => 'ज़ोन में मार्कर';
	@override String get close => 'बंद करें';
	@override String get add_area => 'क्षेत्र जोड़ें';
	@override String get add_street => 'सड़क जोड़ें';
	@override String get add_zone => 'ज़ोन जोड़ें';
	@override String get add_contact => 'संपर्क जोड़ें';
	@override String get add_church => 'चर्च जोड़ें';
	@override String get add_ministry => 'मंत्रालय जोड़ें';
	@override String get offline_maps => 'ऑफ़लाइन मानचित्र';
	@override String get route_planner => 'रूट प्लानर';
	@override String get churches => 'चर्च';
	@override String get contacts => 'संपर्क';
	@override String get ministries => 'मंत्रालय';
	@override String get menu => 'गो मेनू';
	@override String get search_address => 'पता खोजें';
	@override String get save_route => 'रूट सहेजें';
	@override String get hide_options => 'विकल्प छुपाएँ';
	@override String get open_menu => 'मेनू खोलें';
	@override String get tap_to_add_marker => 'मानचित्र पर मार्कर जोड़ने के लिए टैप करें।';
	@override String get route_creation_cancelled => 'रूट निर्माण रद्द किया गया।';
	@override String get add_at_least_3_points => 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
	@override String get add_at_least_2_points => 'सड़क बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
	@override String get enter_name => 'नाम दर्ज करें';
	@override String get name => 'नाम';
	@override String get cancel => 'रद्द करें';
	@override String get save => 'सहेजें';
	@override String get search => 'खोजें';
	@override String get address_not_found => 'पता नहीं मिला।';
	@override String get error_searching_address => 'पता खोजने में त्रुटि: {error}';
	@override String get downloading => 'डाउनलोड हो रहा है {mapName}';
	@override String get starting_download => 'डाउनलोड शुरू हो रहा है...';
	@override String get downloaded_tiles => '{attempted} में से {max} टाइल्स डाउनलोड हुईं ({percent}%)';
	@override String get failed_to_download_map => 'मानचित्र डाउनलोड करने में विफल ({mapName}): {error}';
	@override String get tap_to_place_the_zone => 'ज़ोन रखने के लिए टैप करें।';
	@override String get select_area_or_street_from_the_route_planner => 'रूट प्लानर से क्षेत्र या सड़क चुनें।';
	@override String get areas => 'क्षेत्र';
	@override String get streets => 'सड़कें';
	@override String get zones => 'ज़ोन';
	@override String get enter_address => 'पता दर्ज करें';
	@override String get world => 'विश्व';
	@override String get go_menu => 'गो मेनू';
	@override String get tap_on_the_map_to_add_a_marker => 'मानचित्र पर मार्कर जोड़ने के लिए टैप करें।';
}

// Path: study_tab_screen
class _TranslationsStudyTabScreenHi implements TranslationsStudyTabScreenEn {
	_TranslationsStudyTabScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'अध्ययन';
	@override String get study_menu => 'अध्ययन मेनू';
}

// Path: study_settings_screen
class _TranslationsStudySettingsScreenHi implements TranslationsStudySettingsScreenEn {
	_TranslationsStudySettingsScreenHi._(this._root);

	final TranslationsHi _root; // ignore: unused_field

	// Translations
	@override String get title => 'सेटिंग्स';
	@override String get text_settings => 'पाठ सेटिंग्स';
	@override String get font_family => 'फ़ॉन्ट परिवार';
	@override String get font_size => 'फ़ॉन्ट आकार:';
	@override String get preview => 'पूर्वावलोकन:';
	@override String get back => 'वापस';
	@override String get load => 'लोड करें';
	@override String get sample_text => 'अपने आप को परमेश्वर के सामने स्वीकार्य बनाने के लिए अध्ययन करो, ताकि तुम एक ऐसे काम करने वाले बनो जिसे लज्जित न होना पड़े, और जो सत्य के वचन को ठीक प्रकार से प्रस्तुत करता है।';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsHi {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'main.title': return 'मुख्य शीर्षक';
			case 'main.home': return 'होम';
			case 'main.pray': return 'प्रार्थना';
			case 'main.read': return 'पढ़ें';
			case 'main.study': return 'अध्ययन';
			case 'main.go': return 'जाओ';
			case 'home_builder_screen.title': return 'निर्माता';
			case 'home_builder_screen.content': return 'सामग्री';
			case 'home_journal_screen.title': return 'जर्नल';
			case 'home_journal_screen.content': return 'जर्नल सामग्री';
			case 'home_library_screen.title': return 'पुस्तकालय';
			case 'home_library_screen.content': return 'पुस्तकालय सामग्री';
			case 'home_tab_screen.title': return 'होम';
			case 'home_tab_screen.menu': return 'होम मेनू';
			case 'home_tab_screen.info': return 'जानकारी';
			case 'home_tab_screen.support': return 'सहायता';
			case 'home_tab_screen.profile': return 'प्रोफ़ाइल';
			case 'home_tab_screen.builder': return 'निर्माता';
			case 'home_tab_screen.calendar': return 'कैलेंडर';
			case 'home_tab_screen.journal': return 'जर्नल';
			case 'home_tab_screen.library': return 'पुस्तकालय';
			case 'home_tab_screen.settings': return 'सेटिंग्स';
			case 'home_tab_screen.content': return 'होम टैब सामग्री';
			case 'home_settings_screen.title': return 'सेटिंग्स';
			case 'home_settings_screen.language': return 'भाषा';
			case 'home_settings_screen.english': return 'अंग्रेज़ी';
			case 'home_settings_screen.spanish': return 'स्पेनिश';
			case 'home_settings_screen.hindi': return 'हिंदी';
			case 'home_settings_screen.text_settings': return 'पाठ सेटिंग्स';
			case 'home_settings_screen.font_family': return 'फ़ॉन्ट परिवार';
			case 'home_settings_screen.font_size': return 'फ़ॉन्ट आकार:';
			case 'home_settings_screen.preview': return 'पूर्वावलोकन:';
			case 'home_settings_screen.global_settings': return 'वैश्विक सेटिंग्स';
			case 'home_settings_screen.language_settings': return 'भाषा सेटिंग्स';
			case 'home_settings_screen.app_language': return 'ऐप भाषा';
			case 'home_settings_screen.back': return 'वापस';
			case 'home_settings_screen.load': return 'लोड करें';
			case 'go_add_edit_area_screen.tap_to_add_points': return 'क्षेत्र के लिए बिंदु जोड़ने के लिए मानचित्र पर टैप करें।';
			case 'go_add_edit_area_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_area_screen.cancel_area_creation': return 'क्षेत्र निर्माण रद्द करें';
			case 'go_add_edit_area_screen.discard_changes_to_area': return 'क्या आप इस क्षेत्र में किए गए परिवर्तन हटाना चाहते हैं?';
			case 'go_add_edit_area_screen.keep_editing': return 'संपादन जारी रखें';
			case 'go_add_edit_area_screen.discard': return 'हटाएँ';
			case 'go_add_edit_area_screen.add_at_least_3_points': return 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
			case 'go_add_edit_area_screen.edit_area': return 'क्षेत्र संपादित करें';
			case 'go_add_edit_area_screen.save_area': return 'क्षेत्र सहेजें';
			case 'go_add_edit_area_screen.hide_options': return 'विकल्प छुपाएँ';
			case 'go_add_edit_area_screen.enter_name': return 'नाम दर्ज करें';
			case 'go_add_edit_area_screen.name': return 'नाम';
			case 'go_add_edit_area_screen.name_cannot_be_empty': return 'नाम खाली नहीं हो सकता।';
			case 'go_add_edit_area_screen.area_saved_successfully': return 'क्षेत्र सफलतापूर्वक सहेजा गया।';
			case 'go_add_edit_area_screen.error_saving_area': return 'क्षेत्र सहेजने में त्रुटि: ';
			case 'go_add_edit_area_screen.add_area_title': return 'क्षेत्र जोड़ें';
			case 'go_add_edit_area_screen.edit_area_title': return 'क्षेत्र संपादित करें';
			case 'go_add_edit_area_screen.view_area_title': return 'क्षेत्र देखें';
			case 'go_add_edit_area_screen.contacts': return 'संपर्क';
			case 'go_add_edit_area_screen.churches': return 'चर्च';
			case 'go_add_edit_area_screen.ministries': return 'मंत्रालय';
			case 'go_add_edit_area_screen.areas': return 'क्षेत्र';
			case 'go_add_edit_area_screen.streets': return 'सड़कें';
			case 'go_add_edit_area_screen.zones': return 'ज़ोन';
			case 'go_add_edit_church_screen.delete_church': return 'चर्च हटाएँ';
			case 'go_add_edit_church_screen.delete_church_confirmation': return 'क्या आप वाकई {churchName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
			case 'go_add_edit_church_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_church_screen.delete': return 'हटाएँ';
			case 'go_add_edit_church_screen.church_deleted': return 'चर्च {churchName} हटाया गया';
			case 'go_add_edit_church_screen.church_details': return 'चर्च विवरण';
			case 'go_add_edit_church_screen.add_church': return 'चर्च जोड़ें';
			case 'go_add_edit_church_screen.add_note': return 'नोट जोड़ें';
			case 'go_add_edit_church_screen.edit_details': return 'विवरण संपादित करें';
			case 'go_add_edit_church_screen.church_information': return 'चर्च जानकारी';
			case 'go_add_edit_church_screen.church_name': return 'चर्च का नाम';
			case 'go_add_edit_church_screen.pastor_name': return 'पादरी का नाम';
			case 'go_add_edit_church_screen.address': return 'पता';
			case 'go_add_edit_church_screen.phone': return 'फोन';
			case 'go_add_edit_church_screen.email': return 'ईमेल';
			case 'go_add_edit_church_screen.not_specified': return 'निर्दिष्ट नहीं';
			case 'go_add_edit_church_screen.financial_status': return 'वित्तीय स्थिति';
			case 'go_add_edit_church_screen.status': return 'स्थिति';
			case 'go_add_edit_church_screen.map_information': return 'मानचित्र जानकारी';
			case 'go_add_edit_church_screen.latitude': return 'अक्षांश';
			case 'go_add_edit_church_screen.longitude': return 'देशांतर';
			case 'go_add_edit_church_screen.notes': return 'नोट्स';
			case 'go_add_edit_church_screen.created': return 'निर्मित';
			case 'go_add_edit_church_screen.pastor_name_optional': return 'पादरी का नाम (वैकल्पिक)';
			case 'go_add_edit_church_screen.please_enter_church_name': return 'कृपया चर्च का नाम दर्ज करें';
			case 'go_add_edit_church_screen.please_enter_address': return 'कृपया पता दर्ज करें';
			case 'go_add_edit_church_screen.phone_optional': return 'फोन (वैकल्पिक)';
			case 'go_add_edit_church_screen.email_optional': return 'ईमेल (वैकल्पिक)';
			case 'go_add_edit_church_screen.please_enter_valid_email': return 'कृपया मान्य ईमेल दर्ज करें';
			case 'go_add_edit_church_screen.supporting': return 'समर्थन कर रहे हैं';
			case 'go_add_edit_church_screen.not_supporting': return 'समर्थन नहीं कर रहे हैं';
			case 'go_add_edit_church_screen.undecided': return 'अनिर्णीत';
			case 'go_add_edit_church_screen.church_added': return 'चर्च जोड़ा गया!';
			case 'go_add_edit_church_screen.please_enter_latitude': return 'कृपया अक्षांश दर्ज करें';
			case 'go_add_edit_church_screen.please_enter_longitude': return 'कृपया देशांतर दर्ज करें';
			case 'go_add_edit_church_screen.please_enter_valid_number': return 'कृपया मान्य संख्या दर्ज करें';
			case 'go_add_edit_contact_screen.delete_contact': return 'संपर्क हटाएँ';
			case 'go_add_edit_contact_screen.delete_contact_confirmation': return 'क्या आप वाकई {fullName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
			case 'go_add_edit_contact_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_contact_screen.delete': return 'हटाएँ';
			case 'go_add_edit_contact_screen.contact_deleted': return 'संपर्क {fullName} हटाया गया';
			case 'go_add_edit_contact_screen.contact_details': return 'संपर्क विवरण';
			case 'go_add_edit_contact_screen.add_contact': return 'संपर्क जोड़ें';
			case 'go_add_edit_contact_screen.add_note': return 'नोट जोड़ें';
			case 'go_add_edit_contact_screen.edit_details': return 'विवरण संपादित करें';
			case 'go_add_edit_contact_screen.personal_information': return 'व्यक्तिगत जानकारी';
			case 'go_add_edit_contact_screen.full_name': return 'पूरा नाम';
			case 'go_add_edit_contact_screen.address': return 'पता';
			case 'go_add_edit_contact_screen.birthday': return 'जन्मदिन';
			case 'go_add_edit_contact_screen.phone': return 'फोन';
			case 'go_add_edit_contact_screen.email': return 'ईमेल';
			case 'go_add_edit_contact_screen.not_specified': return 'निर्दिष्ट नहीं';
			case 'go_add_edit_contact_screen.eternal_status': return 'अनंत स्थिति';
			case 'go_add_edit_contact_screen.status': return 'स्थिति';
			case 'go_add_edit_contact_screen.map_information': return 'मानचित्र जानकारी';
			case 'go_add_edit_contact_screen.latitude': return 'अक्षांश';
			case 'go_add_edit_contact_screen.longitude': return 'देशांतर';
			case 'go_add_edit_contact_screen.notes': return 'नोट्स';
			case 'go_add_edit_contact_screen.created': return 'निर्मित';
			case 'go_add_edit_contact_screen.please_enter_full_name': return 'कृपया पूरा नाम दर्ज करें';
			case 'go_add_edit_contact_screen.please_enter_address': return 'कृपया पता दर्ज करें';
			case 'go_add_edit_contact_screen.birthday_optional': return 'जन्मदिन (वैकल्पिक)';
			case 'go_add_edit_contact_screen.phone_optional': return 'फोन (वैकल्पिक)';
			case 'go_add_edit_contact_screen.email_optional': return 'ईमेल (वैकल्पिक)';
			case 'go_add_edit_contact_screen.please_enter_valid_email': return 'कृपया मान्य ईमेल दर्ज करें';
			case 'go_add_edit_contact_screen.saved': return 'सहेजा गया';
			case 'go_add_edit_contact_screen.lost': return 'खो गया';
			case 'go_add_edit_contact_screen.seed_planted': return 'बीज बोया गया';
			case 'go_add_edit_contact_screen.contact_added': return 'संपर्क जोड़ा गया!';
			case 'go_add_edit_contact_screen.save_contact': return 'संपर्क सहेजें';
			case 'go_add_edit_contact_screen.edit_note': return 'नोट संपादित करें';
			case 'go_add_edit_contact_screen.contact_updated': return 'संपर्क अपडेट किया गया!';
			case 'go_add_edit_contact_screen.edit_contact_details': return 'संपर्क विवरण संपादित करें';
			case 'go_add_edit_ministry_screen.delete_ministry': return 'मंत्रालय हटाएँ';
			case 'go_add_edit_ministry_screen.delete_ministry_confirmation': return 'क्या आप वाकई {ministryName} को हटाना चाहते हैं? इससे सभी संबंधित नोट्स हट जाएंगे।';
			case 'go_add_edit_ministry_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_ministry_screen.delete': return 'हटाएँ';
			case 'go_add_edit_ministry_screen.ministry_deleted': return 'मंत्रालय {ministryName} हटाया गया';
			case 'go_add_edit_ministry_screen.ministry_details': return 'मंत्रालय विवरण';
			case 'go_add_edit_ministry_screen.add_ministry': return 'मंत्रालय जोड़ें';
			case 'go_add_edit_ministry_screen.add_note': return 'नोट जोड़ें';
			case 'go_add_edit_ministry_screen.edit_details': return 'विवरण संपादित करें';
			case 'go_add_edit_ministry_screen.ministry_information': return 'मंत्रालय जानकारी';
			case 'go_add_edit_ministry_screen.ministry_name': return 'मंत्रालय का नाम';
			case 'go_add_edit_ministry_screen.contact_name': return 'संपर्क नाम';
			case 'go_add_edit_ministry_screen.address': return 'पता';
			case 'go_add_edit_ministry_screen.phone': return 'फोन';
			case 'go_add_edit_ministry_screen.email': return 'ईमेल';
			case 'go_add_edit_ministry_screen.not_specified': return 'निर्दिष्ट नहीं';
			case 'go_add_edit_ministry_screen.partner_status': return 'साझेदार स्थिति';
			case 'go_add_edit_ministry_screen.status': return 'स्थिति';
			case 'go_add_edit_ministry_screen.map_information': return 'मानचित्र जानकारी';
			case 'go_add_edit_ministry_screen.latitude': return 'अक्षांश';
			case 'go_add_edit_ministry_screen.longitude': return 'देशांतर';
			case 'go_add_edit_ministry_screen.notes': return 'नोट्स';
			case 'go_add_edit_ministry_screen.created': return 'निर्मित';
			case 'go_add_edit_ministry_screen.please_enter_ministry_name': return 'कृपया मंत्रालय का नाम दर्ज करें';
			case 'go_add_edit_ministry_screen.please_enter_address': return 'कृपया पता दर्ज करें';
			case 'go_add_edit_ministry_screen.phone_optional': return 'फोन (वैकल्पिक)';
			case 'go_add_edit_ministry_screen.email_optional': return 'ईमेल (वैकल्पिक)';
			case 'go_add_edit_ministry_screen.please_enter_valid_email': return 'कृपया मान्य ईमेल दर्ज करें';
			case 'go_add_edit_ministry_screen.confirmed': return 'पुष्टि की गई';
			case 'go_add_edit_ministry_screen.not_confirmed': return 'पुष्टि नहीं की गई';
			case 'go_add_edit_ministry_screen.undecided': return 'अनिर्णीत';
			case 'go_add_edit_ministry_screen.ministry_added': return 'मंत्रालय जोड़ा गया!';
			case 'go_add_edit_ministry_screen.please_enter_latitude': return 'कृपया अक्षांश दर्ज करें';
			case 'go_add_edit_ministry_screen.please_enter_longitude': return 'कृपया देशांतर दर्ज करें';
			case 'go_add_edit_ministry_screen.please_enter_valid_number': return 'कृपया मान्य संख्या दर्ज करें';
			case 'go_add_edit_street_screen.tap_to_add_points': return 'बिंदु जोड़ने के लिए मानचित्र पर टैप करें।';
			case 'go_add_edit_street_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_street_screen.cancel_creation': return 'निर्माण रद्द करें';
			case 'go_add_edit_street_screen.discard_changes': return 'क्या आप इस रूट में किए गए परिवर्तन हटाना चाहते हैं?';
			case 'go_add_edit_street_screen.keep_editing': return 'संपादन जारी रखें';
			case 'go_add_edit_street_screen.discard': return 'हटाएँ';
			case 'go_add_edit_street_screen.add_at_least_2_points': return 'रूट बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
			case 'go_add_edit_street_screen.enter_name': return 'नाम दर्ज करें';
			case 'go_add_edit_street_screen.name': return 'नाम';
			case 'go_add_edit_street_screen.name_cannot_be_empty': return 'नाम खाली नहीं हो सकता।';
			case 'go_add_edit_street_screen.save': return 'सहेजें';
			case 'go_add_edit_street_screen.edit': return 'संपादित करें';
			case 'go_add_edit_street_screen.route_saved_successfully': return 'रूट सफलतापूर्वक सहेजा गया।';
			case 'go_add_edit_street_screen.error_saving_route': return 'रूट सहेजने में त्रुटि: {error}';
			case 'go_add_edit_street_screen.contacts': return 'संपर्क';
			case 'go_add_edit_street_screen.churches': return 'चर्च';
			case 'go_add_edit_street_screen.ministries': return 'मंत्रालय';
			case 'go_add_edit_street_screen.areas': return 'क्षेत्र';
			case 'go_add_edit_street_screen.streets': return 'सड़कें';
			case 'go_add_edit_street_screen.zones': return 'ज़ोन';
			case 'go_add_edit_street_screen.view': return 'देखें';
			case 'go_add_edit_street_screen.add': return 'जोड़ें';
			case 'go_add_edit_street_screen.hide_options': return 'विकल्प छुपाएँ';
			case 'go_add_edit_street_screen.zoom_in': return 'ज़ूम इन';
			case 'go_add_edit_street_screen.zoom_out': return 'ज़ूम आउट';
			case 'go_add_edit_street_screen.add_point': return 'बिंदु जोड़ें';
			case 'go_add_edit_street_screen.remove_point': return 'बिंदु हटाएँ';
			case 'go_add_edit_street_screen.street': return 'सड़क';
			case 'go_add_edit_street_screen.river': return 'नदी';
			case 'go_add_edit_street_screen.path': return 'पथ';
			case 'go_add_edit_street_screen.view_street_title': return 'सड़क देखें';
			case 'go_add_edit_street_screen.edit_street_title': return 'सड़क संपादित करें';
			case 'go_add_edit_street_screen.add_street_title': return 'सड़क जोड़ें';
			case 'go_add_edit_street_screen.save_street': return 'सड़क सहेजें';
			case 'go_add_edit_zone_screen.tap_to_set_center': return 'ज़ोन केंद्र सेट करने के लिए मानचित्र पर टैप करें।';
			case 'go_add_edit_zone_screen.cancel': return 'रद्द करें';
			case 'go_add_edit_zone_screen.cancel_zone_creation': return 'ज़ोन निर्माण रद्द करें';
			case 'go_add_edit_zone_screen.discard_changes': return 'क्या आप इस ज़ोन में किए गए परिवर्तन हटाना चाहते हैं?';
			case 'go_add_edit_zone_screen.keep_editing': return 'संपादन जारी रखें';
			case 'go_add_edit_zone_screen.discard': return 'हटाएँ';
			case 'go_add_edit_zone_screen.enter_name': return 'नाम दर्ज करें';
			case 'go_add_edit_zone_screen.name': return 'नाम';
			case 'go_add_edit_zone_screen.name_cannot_be_empty': return 'नाम खाली नहीं हो सकता।';
			case 'go_add_edit_zone_screen.save': return 'सहेजें';
			case 'go_add_edit_zone_screen.edit': return 'संपादित करें';
			case 'go_add_edit_zone_screen.zone_saved_successfully': return 'ज़ोन सफलतापूर्वक सहेजा गया।';
			case 'go_add_edit_zone_screen.error_saving_zone': return 'ज़ोन सहेजने में त्रुटि: {error}';
			case 'go_add_edit_zone_screen.contacts': return 'संपर्क';
			case 'go_add_edit_zone_screen.churches': return 'चर्च';
			case 'go_add_edit_zone_screen.ministries': return 'मंत्रालय';
			case 'go_add_edit_zone_screen.areas': return 'क्षेत्र';
			case 'go_add_edit_zone_screen.streets': return 'सड़कें';
			case 'go_add_edit_zone_screen.zones': return 'ज़ोन';
			case 'go_add_edit_zone_screen.view': return 'देखें';
			case 'go_add_edit_zone_screen.add': return 'जोड़ें';
			case 'go_add_edit_zone_screen.hide_options': return 'विकल्प छुपाएँ';
			case 'go_add_edit_zone_screen.zoom_in': return 'ज़ूम इन';
			case 'go_add_edit_zone_screen.zoom_out': return 'ज़ूम आउट';
			case 'go_add_edit_zone_screen.increase_radius': return 'त्रिज्या बढ़ाएँ';
			case 'go_add_edit_zone_screen.decrease_radius': return 'त्रिज्या घटाएँ';
			case 'go_add_edit_zone_screen.set_center': return 'केंद्र सेट करें';
			case 'go_add_edit_zone_screen.view_zone_title': return 'क्षेत्र देखें';
			case 'go_add_edit_zone_screen.edit_zone_title': return 'क्षेत्र संपादित करें';
			case 'go_add_edit_zone_screen.add_zone_title': return 'क्षेत्र जोड़ें';
			case 'go_add_edit_zone_screen.save_zone': return 'क्षेत्र सहेजें';
			case 'go_churches_screen.title': return 'गो चर्च';
			case 'go_churches_screen.add_church': return 'चर्च जोड़ें';
			case 'go_churches_screen.delete_church': return 'चर्च हटाएँ';
			case 'go_churches_screen.delete_church_confirmation': return 'क्या आप वाकई {churchName} को हटाना चाहते हैं?';
			case 'go_churches_screen.cancel': return 'रद्द करें';
			case 'go_churches_screen.delete': return 'हटाएँ';
			case 'go_churches_screen.church_deleted': return 'चर्च {churchName} हटाया गया';
			case 'go_churches_screen.no_churches': return 'अभी तक कोई चर्च नहीं जोड़ा गया है।';
			case 'go_churches_screen.pastor': return 'पादरी: {pastorName}';
			case 'go_churches_screen.phone': return 'फोन: {phone}';
			case 'go_churches_screen.email': return 'ईमेल: {email}';
			case 'go_churches_screen.address': return 'पता: {address}';
			case 'go_churches_screen.financial_status': return 'वित्तीय स्थिति: {status}';
			case 'go_churches_screen.notes': return 'नोट्स:';
			case 'go_churches_screen.created': return 'निर्मित: {date}';
			case 'go_churches_screen.edit': return 'संपादित करें';
			case 'go_contacts_screen.title': return 'गो संपर्क';
			case 'go_contacts_screen.add_contact': return 'संपर्क जोड़ें';
			case 'go_contacts_screen.delete_contact': return 'संपर्क हटाएँ';
			case 'go_contacts_screen.delete_contact_confirmation': return 'क्या आप वाकई {fullName} को हटाना चाहते हैं?';
			case 'go_contacts_screen.cancel': return 'रद्द करें';
			case 'go_contacts_screen.delete': return 'हटाएँ';
			case 'go_contacts_screen.contact_deleted': return 'संपर्क {fullName} हटाया गया';
			case 'go_contacts_screen.no_contacts': return 'अभी तक कोई संपर्क नहीं जोड़ा गया है।';
			case 'go_contacts_screen.full_name': return 'पूरा नाम';
			case 'go_contacts_screen.phone': return 'फोन: {phone}';
			case 'go_contacts_screen.email': return 'ईमेल: {email}';
			case 'go_contacts_screen.address': return 'पता: {address}';
			case 'go_contacts_screen.eternal_status': return 'अनंत स्थिति: {status}';
			case 'go_contacts_screen.birthday': return 'जन्मदिन: {birthday}';
			case 'go_contacts_screen.notes': return 'नोट्स:';
			case 'go_contacts_screen.created': return 'निर्मित: {date}';
			case 'go_contacts_screen.edit': return 'संपादित करें';
			case 'go_export_import_screen.title': return 'निर्यात/आयात';
			case 'go_export_import_screen.export_data': return 'डेटा निर्यात करें';
			case 'go_export_import_screen.import_data': return 'डेटा आयात करें';
			case 'go_export_import_screen.churches': return 'चर्च';
			case 'go_export_import_screen.contacts': return 'संपर्क';
			case 'go_export_import_screen.ministries': return 'मंत्रालय';
			case 'go_export_import_screen.areas': return 'क्षेत्र';
			case 'go_export_import_screen.streets': return 'सड़कें';
			case 'go_export_import_screen.zones': return 'ज़ोन';
			case 'go_export_import_screen.all': return 'सभी';
			case 'go_export_import_screen.no_churches': return 'कोई चर्च उपलब्ध नहीं है';
			case 'go_export_import_screen.no_contacts': return 'कोई संपर्क उपलब्ध नहीं है';
			case 'go_export_import_screen.no_ministries': return 'कोई मंत्रालय उपलब्ध नहीं है';
			case 'go_export_import_screen.no_areas': return 'कोई क्षेत्र उपलब्ध नहीं है';
			case 'go_export_import_screen.no_streets': return 'कोई सड़क उपलब्ध नहीं है';
			case 'go_export_import_screen.no_zones': return 'कोई ज़ोन उपलब्ध नहीं है';
			case 'go_export_import_screen.save_json': return '{type} JSON सहेजें';
			case 'go_export_import_screen.select_json': return '{type} JSON चुनें';
			case 'go_export_import_screen.export_success': return '{type} सफलतापूर्वक निर्यात किया गया';
			case 'go_export_import_screen.import_success': return '{type} सफलतापूर्वक आयात किया गया';
			case 'go_export_import_screen.error_export': return '{type} निर्यात करने में त्रुटि: {error}';
			case 'go_export_import_screen.error_import': return '{type} आयात करने में त्रुटि: {error}';
			case 'go_export_import_screen.invalid_file': return 'अमान्य फ़ाइल: अपेक्षित {type} डेटा';
			case 'go_export_import_screen.all_export_success': return 'सभी डेटा सफलतापूर्वक निर्यात किए गए';
			case 'go_export_import_screen.all_import_success': return 'सभी डेटा सफलतापूर्वक आयात किए गए';
			case 'go_export_import_screen.error_export_all': return 'सभी डेटा निर्यात करने में त्रुटि: {error}';
			case 'go_export_import_screen.error_import_all': return 'सभी डेटा आयात करने में त्रुटि: {error}';
			case 'go_ministries_screen.title': return 'गो मंत्रालय';
			case 'go_ministries_screen.add_ministry': return 'मंत्रालय जोड़ें';
			case 'go_ministries_screen.delete_ministry': return 'मंत्रालय हटाएँ';
			case 'go_ministries_screen.delete_ministry_confirmation': return 'क्या आप वाकई {ministryName} को हटाना चाहते हैं?';
			case 'go_ministries_screen.cancel': return 'रद्द करें';
			case 'go_ministries_screen.delete': return 'हटाएँ';
			case 'go_ministries_screen.ministry_deleted': return 'मंत्रालय {ministryName} हटाया गया';
			case 'go_ministries_screen.no_ministries': return 'अभी तक कोई मंत्रालय नहीं जोड़ा गया है।';
			case 'go_ministries_screen.contact': return 'संपर्क: {contactName}';
			case 'go_ministries_screen.phone': return 'फोन: {phone}';
			case 'go_ministries_screen.email': return 'ईमेल: {email}';
			case 'go_ministries_screen.address': return 'पता: {address}';
			case 'go_ministries_screen.partner_status': return 'साझेदार स्थिति: {status}';
			case 'go_ministries_screen.notes': return 'नोट्स:';
			case 'go_ministries_screen.created': return 'निर्मित: {date}';
			case 'go_ministries_screen.edit': return 'संपादित करें';
			case 'go_offline_maps_screen.title': return 'ऑफ़लाइन मानचित्र';
			case 'go_offline_maps_screen.select_your_own_map': return 'अपना स्वयं का मानचित्र चुनें';
			case 'go_offline_maps_screen.downloaded_maps': return 'डाउनलोड किए गए मानचित्र';
			case 'go_offline_maps_screen.no_maps_downloaded': return 'अभी तक कोई मानचित्र डाउनलोड नहीं किया गया है।';
			case 'go_offline_maps_screen.max_maps_warning': return 'आप केवल 5 मानचित्र (डिफ़ॉल्ट वर्ल्ड मानचित्र सहित) रख सकते हैं। कृपया नया मानचित्र डाउनलोड करने से पहले एक मानचित्र हटाएँ।';
			case 'go_offline_maps_screen.failed_to_delete_map': return 'मानचित्र हटाने में विफल ({mapName}): {error}';
			case 'go_offline_maps_screen.rename_map': return 'मानचित्र का नाम बदलें';
			case 'go_offline_maps_screen.enter_new_map_name': return 'नया मानचित्र नाम दर्ज करें';
			case 'go_offline_maps_screen.cancel': return 'रद्द करें';
			case 'go_offline_maps_screen.save': return 'सहेजें';
			case 'go_offline_maps_screen.failed_to_rename_map': return 'मानचित्र का नाम बदलने में विफल: {error}';
			case 'go_offline_maps_screen.view': return 'देखें';
			case 'go_offline_maps_screen.update': return 'अपडेट करें';
			case 'go_offline_maps_screen.rename': return 'नाम बदलें';
			case 'go_offline_maps_screen.delete': return 'हटाएँ';
			case 'go_offline_maps_screen.world': return 'विश्व';
			case 'go_offline_maps_screen.map_updated_successfully': return 'मानचित्र "{mapName}" सफलतापूर्वक अपडेट किया गया';
			case 'go_offline_maps_screen.failed_to_update_map': return 'मानचित्र अपडेट करने में विफल: {error}';
			case 'go_route_planner_screen.title': return 'रूट प्लानर';
			case 'go_route_planner_screen.areas': return 'क्षेत्र';
			case 'go_route_planner_screen.streets': return 'सड़कें';
			case 'go_route_planner_screen.zones': return 'ज़ोन';
			case 'go_route_planner_screen.no_areas': return 'अभी तक कोई क्षेत्र नहीं जोड़ा गया है।';
			case 'go_route_planner_screen.no_streets': return 'अभी तक कोई सड़क नहीं जोड़ी गई है।';
			case 'go_route_planner_screen.no_zones': return 'अभी तक कोई ज़ोन नहीं जोड़ा गया है।';
			case 'go_route_planner_screen.edit': return 'संपादित करें';
			case 'go_route_planner_screen.rename': return 'नाम बदलें';
			case 'go_route_planner_screen.delete': return 'हटाएँ';
			case 'go_route_planner_screen.view': return 'देखें';
			case 'go_route_planner_screen.add': return 'जोड़ें';
			case 'go_route_planner_screen.lat': return 'अक्षांश: {lat}';
			case 'go_route_planner_screen.lon': return 'देशांतर: {lon}';
			case 'go_route_planner_screen.no_coordinates': return 'कोई निर्देशांक नहीं';
			case 'go_route_planner_screen.failed_to_delete': return '{type} हटाने में विफल: {error}';
			case 'go_route_planner_screen.failed_to_rename': return '{type} का नाम बदलने में विफल: {error}';
			case 'go_route_planner_screen.rename_type': return '{type} का नाम बदलें';
			case 'go_route_planner_screen.enter_new_name': return 'नया नाम दर्ज करें';
			case 'go_route_planner_screen.cancel': return 'रद्द करें';
			case 'go_route_planner_screen.save': return 'सहेजें';
			case 'go_search_screen.title': return 'पता खोजें';
			case 'go_search_screen.enter_address': return 'पता दर्ज करें';
			case 'go_search_screen.please_enter_address': return 'कृपया पता दर्ज करें।';
			case 'go_search_screen.address_not_found': return 'पता नहीं मिला।';
			case 'go_search_screen.found': return 'मिला: {displayName}';
			case 'go_search_screen.latitude': return 'अक्षांश: {lat}';
			case 'go_search_screen.longitude': return 'देशांतर: {lon}';
			case 'go_search_screen.error_searching_address': return 'पता खोजने में त्रुटि: {error}';
			case 'go_search_screen.search': return 'खोजें';
			case 'go_select_map_area_screen.title': return 'मानचित्र क्षेत्र चुनें';
			case 'go_select_map_area_screen.download_limit_exceeded': return 'डाउनलोड सीमा पार हो गई';
			case 'go_select_map_area_screen.download_limit_message': return 'चयनित क्षेत्र अधिकतम सीमा (12,000 टाइल्स या 155.55 MB) से अधिक है। कृपया छोटा क्षेत्र चुनें।';
			case 'go_select_map_area_screen.ok': return 'ठीक है';
			case 'go_select_map_area_screen.download_map': return 'मानचित्र डाउनलोड करें';
			case 'go_select_map_area_screen.download_map_question': return 'क्या आप इस क्षेत्र का मानचित्र डाउनलोड करना चाहते हैं? अनुमानित टाइल्स: {tiles}, लगभग {size} MB।';
			case 'go_select_map_area_screen.close': return 'बंद करें';
			case 'go_select_map_area_screen.name_your_map': return 'अपने मानचित्र का नाम दें';
			case 'go_select_map_area_screen.enter_map_name': return 'मानचित्र नाम दर्ज करें';
			case 'go_select_map_area_screen.cancel': return 'रद्द करें';
			case 'go_select_map_area_screen.download': return 'डाउनलोड करें';
			case 'go_select_map_routes_screen.title': return 'मानचित्र रूट चुनें';
			case 'go_select_map_routes_screen.select': return 'चुनें';
			case 'go_select_map_routes_screen.edit': return 'संपादित करें';
			case 'go_select_map_routes_screen.view': return 'देखें';
			case 'go_select_map_routes_screen.area': return 'क्षेत्र';
			case 'go_select_map_routes_screen.street': return 'सड़क';
			case 'go_select_map_routes_screen.tag': return 'टैग';
			case 'go_select_map_routes_screen.add_at_least_3_points': return 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
			case 'go_select_map_routes_screen.add_at_least_2_points': return 'सड़क बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
			case 'go_select_map_routes_screen.add_a_tag': return 'सहेजने के लिए टैग जोड़ें।';
			case 'go_select_map_routes_screen.enter_name': return 'नाम दर्ज करें';
			case 'go_select_map_routes_screen.name': return 'नाम';
			case 'go_select_map_routes_screen.name_cannot_be_empty': return 'नाम खाली नहीं हो सकता।';
			case 'go_select_map_routes_screen.save': return 'सहेजें';
			case 'go_select_map_routes_screen.cancel': return 'रद्द करें';
			case 'go_select_map_routes_screen.tag_text': return 'टैग पाठ';
			case 'go_select_map_routes_screen.enter_tag_text': return 'टैग पाठ दर्ज करें';
			case 'go_select_map_routes_screen.error_loading_item': return 'आइटम लोड करने में त्रुटि: {error}';
			case 'go_select_map_routes_screen.error_adding_point': return 'बिंदु जोड़ने में त्रुटि: {error}';
			case 'go_select_map_routes_screen.error_saving_item': return 'आइटम सहेजने में त्रुटि: {error}';
			case 'go_select_map_routes_screen.zoom_in': return 'ज़ूम इन';
			case 'go_select_map_routes_screen.zoom_out': return 'ज़ूम आउट';
			case 'go_settings_screen.title': return 'सेटिंग्स';
			case 'go_settings_screen.text_settings': return 'पाठ सेटिंग्स';
			case 'go_settings_screen.font_family': return 'फ़ॉन्ट परिवार';
			case 'go_settings_screen.font_size': return 'फ़ॉन्ट आकार:';
			case 'go_settings_screen.preview': return 'पूर्वावलोकन:';
			case 'go_settings_screen.back': return 'वापस';
			case 'go_settings_screen.load': return 'लोड करें';
			case 'go_settings_screen.sample_text': return 'और उसने उनसे कहा, सारी दुनिया में जाकर सब प्राणी को सुसमाचार प्रचार करो।';
			case 'go_share_screen.title': return 'साझा करें';
			case 'go_share_screen.churches': return 'चर्च';
			case 'go_share_screen.contacts': return 'संपर्क';
			case 'go_share_screen.ministries': return 'मंत्रालय';
			case 'go_share_screen.areas': return 'क्षेत्र';
			case 'go_share_screen.streets': return 'सड़कें';
			case 'go_share_screen.zones': return 'ज़ोन';
			case 'go_share_screen.all': return 'सभी';
			case 'go_share_screen.no_churches': return 'कोई चर्च उपलब्ध नहीं है';
			case 'go_share_screen.no_contacts': return 'कोई संपर्क उपलब्ध नहीं है';
			case 'go_share_screen.no_ministries': return 'कोई मंत्रालय उपलब्ध नहीं है';
			case 'go_share_screen.no_areas': return 'कोई क्षेत्र उपलब्ध नहीं है';
			case 'go_share_screen.no_streets': return 'कोई सड़क उपलब्ध नहीं है';
			case 'go_share_screen.no_zones': return 'कोई ज़ोन उपलब्ध नहीं है';
			case 'go_share_screen.share_all_data': return 'सभी डेटा साझा करें';
			case 'go_share_screen.all_by_faith_data': return 'सभी बाय फेथ डेटा';
			case 'go_share_screen.could_not_launch_email': return 'ईमेल क्लाइंट लॉन्च नहीं कर सके';
			case 'go_tab_screen.markers_in_zone': return 'ज़ोन में मार्कर';
			case 'go_tab_screen.close': return 'बंद करें';
			case 'go_tab_screen.add_area': return 'क्षेत्र जोड़ें';
			case 'go_tab_screen.add_street': return 'सड़क जोड़ें';
			case 'go_tab_screen.add_zone': return 'ज़ोन जोड़ें';
			case 'go_tab_screen.add_contact': return 'संपर्क जोड़ें';
			case 'go_tab_screen.add_church': return 'चर्च जोड़ें';
			case 'go_tab_screen.add_ministry': return 'मंत्रालय जोड़ें';
			case 'go_tab_screen.offline_maps': return 'ऑफ़लाइन मानचित्र';
			case 'go_tab_screen.route_planner': return 'रूट प्लानर';
			case 'go_tab_screen.churches': return 'चर्च';
			case 'go_tab_screen.contacts': return 'संपर्क';
			case 'go_tab_screen.ministries': return 'मंत्रालय';
			case 'go_tab_screen.menu': return 'गो मेनू';
			case 'go_tab_screen.search_address': return 'पता खोजें';
			case 'go_tab_screen.save_route': return 'रूट सहेजें';
			case 'go_tab_screen.hide_options': return 'विकल्प छुपाएँ';
			case 'go_tab_screen.open_menu': return 'मेनू खोलें';
			case 'go_tab_screen.tap_to_add_marker': return 'मानचित्र पर मार्कर जोड़ने के लिए टैप करें।';
			case 'go_tab_screen.route_creation_cancelled': return 'रूट निर्माण रद्द किया गया।';
			case 'go_tab_screen.add_at_least_3_points': return 'क्षेत्र बनाने के लिए कम से कम 3 बिंदु जोड़ें।';
			case 'go_tab_screen.add_at_least_2_points': return 'सड़क बनाने के लिए कम से कम 2 बिंदु जोड़ें।';
			case 'go_tab_screen.enter_name': return 'नाम दर्ज करें';
			case 'go_tab_screen.name': return 'नाम';
			case 'go_tab_screen.cancel': return 'रद्द करें';
			case 'go_tab_screen.save': return 'सहेजें';
			case 'go_tab_screen.search': return 'खोजें';
			case 'go_tab_screen.address_not_found': return 'पता नहीं मिला।';
			case 'go_tab_screen.error_searching_address': return 'पता खोजने में त्रुटि: {error}';
			case 'go_tab_screen.downloading': return 'डाउनलोड हो रहा है {mapName}';
			case 'go_tab_screen.starting_download': return 'डाउनलोड शुरू हो रहा है...';
			case 'go_tab_screen.downloaded_tiles': return '{attempted} में से {max} टाइल्स डाउनलोड हुईं ({percent}%)';
			case 'go_tab_screen.failed_to_download_map': return 'मानचित्र डाउनलोड करने में विफल ({mapName}): {error}';
			case 'go_tab_screen.tap_to_place_the_zone': return 'ज़ोन रखने के लिए टैप करें।';
			case 'go_tab_screen.select_area_or_street_from_the_route_planner': return 'रूट प्लानर से क्षेत्र या सड़क चुनें।';
			case 'go_tab_screen.areas': return 'क्षेत्र';
			case 'go_tab_screen.streets': return 'सड़कें';
			case 'go_tab_screen.zones': return 'ज़ोन';
			case 'go_tab_screen.enter_address': return 'पता दर्ज करें';
			case 'go_tab_screen.world': return 'विश्व';
			case 'go_tab_screen.go_menu': return 'गो मेनू';
			case 'go_tab_screen.tap_on_the_map_to_add_a_marker': return 'मानचित्र पर मार्कर जोड़ने के लिए टैप करें।';
			case 'study_tab_screen.title': return 'अध्ययन';
			case 'study_tab_screen.study_menu': return 'अध्ययन मेनू';
			case 'study_settings_screen.title': return 'सेटिंग्स';
			case 'study_settings_screen.text_settings': return 'पाठ सेटिंग्स';
			case 'study_settings_screen.font_family': return 'फ़ॉन्ट परिवार';
			case 'study_settings_screen.font_size': return 'फ़ॉन्ट आकार:';
			case 'study_settings_screen.preview': return 'पूर्वावलोकन:';
			case 'study_settings_screen.back': return 'वापस';
			case 'study_settings_screen.load': return 'लोड करें';
			case 'study_settings_screen.sample_text': return 'अपने आप को परमेश्वर के सामने स्वीकार्य बनाने के लिए अध्ययन करो, ताकि तुम एक ऐसे काम करने वाले बनो जिसे लज्जित न होना पड़े, और जो सत्य के वचन को ठीक प्रकार से प्रस्तुत करता है।';
			default: return null;
		}
	}
}

