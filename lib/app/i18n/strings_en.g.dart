///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsHomeTabScreenEn home_tab_screen = TranslationsHomeTabScreenEn._(_root);
	late final TranslationsHomeSettingsScreenEn home_settings_screen = TranslationsHomeSettingsScreenEn._(_root);
	late final TranslationsGoAddEditAreaScreenEn go_add_edit_area_screen = TranslationsGoAddEditAreaScreenEn._(_root);
	late final TranslationsGoSettingsScreenEn go_settings_screen = TranslationsGoSettingsScreenEn._(_root);
}

// Path: home_tab_screen
class TranslationsHomeTabScreenEn {
	TranslationsHomeTabScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get menu => 'Home Menu';
	String get info => 'Info';
	String get support => 'Support';
	String get profile => 'Profile';
	String get calendar => 'Calendar';
	String get settings => 'Settings';
	String get content => 'Home Tab Content';
}

// Path: home_settings_screen
class TranslationsHomeSettingsScreenEn {
	TranslationsHomeSettingsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get language => 'Language';
	String get english => 'English';
	String get spanish => 'Spanish';
	String get text_settings => 'Text Settings';
	String get font_family => 'Font Family';
	String get font_size => 'Font Size:';
	String get preview => 'Preview:';
	String get global_settings => 'Global Settings';
	String get language_settings => 'Language Settings';
	String get app_language => 'App Language';
	String get back => 'Back';
	String get load => 'Load';
}

// Path: go_add_edit_area_screen
class TranslationsGoAddEditAreaScreenEn {
	TranslationsGoAddEditAreaScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tap_to_add_points => 'Tap on the map to add points for Area.';
	String get cancel => 'Cancel';
	String get cancel_area_creation => 'Cancel Area Creation';
	String get discard_changes_to_area => 'Discard changes to this area?';
	String get keep_editing => 'Keep Editing';
	String get discard => 'Discard';
	String get add_at_least_3_points => 'Add at least 3 points to create an area.';
	String get edit_area => 'Edit Area';
	String get save_area => 'Save Area';
	String get hide_options => 'Hide Options';
	String get enter_name => 'Enter name';
	String get name => 'Name';
	String get name_cannot_be_empty => 'Name cannot be empty.';
	String get area_saved_successfully => 'Area saved successfully.';
	String get error_saving_area => 'Error saving Area: ';
}

// Path: go_settings_screen
class TranslationsGoSettingsScreenEn {
	TranslationsGoSettingsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get text_settings => 'Text Settings';
	String get font_family => 'Font Family';
	String get font_size => 'Font Size:';
	String get preview => 'Preview:';
	String get back => 'Back';
	String get load => 'Load';
	String get sample_text => 'And he said unto them, Go ye into all the world, and preach the gospel to every creature.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'home_tab_screen.title': return 'Home';
			case 'home_tab_screen.menu': return 'Home Menu';
			case 'home_tab_screen.info': return 'Info';
			case 'home_tab_screen.support': return 'Support';
			case 'home_tab_screen.profile': return 'Profile';
			case 'home_tab_screen.calendar': return 'Calendar';
			case 'home_tab_screen.settings': return 'Settings';
			case 'home_tab_screen.content': return 'Home Tab Content';
			case 'home_settings_screen.title': return 'Settings';
			case 'home_settings_screen.language': return 'Language';
			case 'home_settings_screen.english': return 'English';
			case 'home_settings_screen.spanish': return 'Spanish';
			case 'home_settings_screen.text_settings': return 'Text Settings';
			case 'home_settings_screen.font_family': return 'Font Family';
			case 'home_settings_screen.font_size': return 'Font Size:';
			case 'home_settings_screen.preview': return 'Preview:';
			case 'home_settings_screen.global_settings': return 'Global Settings';
			case 'home_settings_screen.language_settings': return 'Language Settings';
			case 'home_settings_screen.app_language': return 'App Language';
			case 'home_settings_screen.back': return 'Back';
			case 'home_settings_screen.load': return 'Load';
			case 'go_add_edit_area_screen.tap_to_add_points': return 'Tap on the map to add points for Area.';
			case 'go_add_edit_area_screen.cancel': return 'Cancel';
			case 'go_add_edit_area_screen.cancel_area_creation': return 'Cancel Area Creation';
			case 'go_add_edit_area_screen.discard_changes_to_area': return 'Discard changes to this area?';
			case 'go_add_edit_area_screen.keep_editing': return 'Keep Editing';
			case 'go_add_edit_area_screen.discard': return 'Discard';
			case 'go_add_edit_area_screen.add_at_least_3_points': return 'Add at least 3 points to create an area.';
			case 'go_add_edit_area_screen.edit_area': return 'Edit Area';
			case 'go_add_edit_area_screen.save_area': return 'Save Area';
			case 'go_add_edit_area_screen.hide_options': return 'Hide Options';
			case 'go_add_edit_area_screen.enter_name': return 'Enter name';
			case 'go_add_edit_area_screen.name': return 'Name';
			case 'go_add_edit_area_screen.name_cannot_be_empty': return 'Name cannot be empty.';
			case 'go_add_edit_area_screen.area_saved_successfully': return 'Area saved successfully.';
			case 'go_add_edit_area_screen.error_saving_area': return 'Error saving Area: ';
			case 'go_settings_screen.title': return 'Settings';
			case 'go_settings_screen.text_settings': return 'Text Settings';
			case 'go_settings_screen.font_family': return 'Font Family';
			case 'go_settings_screen.font_size': return 'Font Size:';
			case 'go_settings_screen.preview': return 'Preview:';
			case 'go_settings_screen.back': return 'Back';
			case 'go_settings_screen.load': return 'Load';
			case 'go_settings_screen.sample_text': return 'And he said unto them, Go ye into all the world, and preach the gospel to every creature.';
			default: return null;
		}
	}
}

