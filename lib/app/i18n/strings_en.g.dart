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
	late final TranslationsGoAddEditChurchScreenEn go_add_edit_church_screen = TranslationsGoAddEditChurchScreenEn._(_root);
	late final TranslationsGoSettingsScreenEn go_settings_screen = TranslationsGoSettingsScreenEn._(_root);
	late final TranslationsGoAddEditContactScreenEn go_add_edit_contact_screen = TranslationsGoAddEditContactScreenEn._(_root);
	late final TranslationsGoAddEditMinistryScreenEn go_add_edit_ministry_screen = TranslationsGoAddEditMinistryScreenEn._(_root);
	late final TranslationsGoAddEditStreetScreenEn go_add_edit_street_screen = TranslationsGoAddEditStreetScreenEn._(_root);
	late final TranslationsGoAddEditZoneScreenEn go_add_edit_zone_screen = TranslationsGoAddEditZoneScreenEn._(_root);
	late final TranslationsGoChurchesScreenEn go_churches_screen = TranslationsGoChurchesScreenEn._(_root);
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
	String get add_area_title => 'Add Area';
	String get edit_area_title => 'Edit Area';
	String get view_area_title => 'View Area';
	String get contacts => 'Contacts';
	String get churches => 'Churches';
	String get ministries => 'Ministries';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
}

// Path: go_add_edit_church_screen
class TranslationsGoAddEditChurchScreenEn {
	TranslationsGoAddEditChurchScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delete_church => 'Delete Church';
	String get delete_church_confirmation => 'Are you sure you want to delete {churchName}? This will delete all associated notes.';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get church_deleted => 'Church {churchName} deleted';
	String get church_details => 'Church Details';
	String get add_church => 'Add Church';
	String get add_note => 'Add Note';
	String get edit_details => 'Edit Details';
	String get church_information => 'Church Information';
	String get church_name => 'Church Name';
	String get pastor_name => 'Pastor Name';
	String get address => 'Address';
	String get phone => 'Phone';
	String get email => 'Email';
	String get not_specified => 'Not specified';
	String get financial_status => 'Financial Status';
	String get status => 'Status';
	String get map_information => 'Map Information';
	String get latitude => 'Latitude';
	String get longitude => 'Longitude';
	String get notes => 'Notes';
	String get created => 'Created';
	String get pastor_name_optional => 'Pastor Name (Optional)';
	String get please_enter_church_name => 'Please enter a church name';
	String get please_enter_address => 'Please enter an address';
	String get phone_optional => 'Phone (Optional)';
	String get email_optional => 'Email (Optional)';
	String get please_enter_valid_email => 'Please enter a valid email';
	String get supporting => 'Supporting';
	String get not_supporting => 'Not-Supporting';
	String get undecided => 'Undecided';
	String get church_added => 'Church added!';
	String get please_enter_latitude => 'Please enter a latitude';
	String get please_enter_longitude => 'Please enter a longitude';
	String get please_enter_valid_number => 'Please enter a valid number';
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

// Path: go_add_edit_contact_screen
class TranslationsGoAddEditContactScreenEn {
	TranslationsGoAddEditContactScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delete_contact => 'Delete Contact';
	String get delete_contact_confirmation => 'Are you sure you want to delete {fullName}? This will delete all associated notes.';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get contact_deleted => 'Contact {fullName} deleted';
	String get contact_details => 'Contact Details';
	String get add_contact => 'Add Contact';
	String get add_note => 'Add Note';
	String get edit_details => 'Edit Details';
	String get personal_information => 'Personal Information';
	String get full_name => 'Full Name';
	String get address => 'Address';
	String get birthday => 'Birthday';
	String get phone => 'Phone';
	String get email => 'Email';
	String get not_specified => 'Not specified';
	String get eternal_status => 'Eternal Status';
	String get status => 'Status';
	String get map_information => 'Map Information';
	String get latitude => 'Latitude';
	String get longitude => 'Longitude';
	String get notes => 'Notes';
	String get created => 'Created';
	String get please_enter_full_name => 'Please enter a full name';
	String get please_enter_address => 'Please enter an address';
	String get birthday_optional => 'Birthday (Optional)';
	String get phone_optional => 'Phone (Optional)';
	String get email_optional => 'Email (Optional)';
	String get please_enter_valid_email => 'Please enter a valid email';
	String get saved => 'Saved';
	String get lost => 'Lost';
	String get seed_planted => 'Seed Planted';
	String get contact_added => 'Contact added!';
	String get save_contact => 'Save Contact';
	String get edit_note => 'Edit Note';
	String get contact_updated => 'Contact updated!';
	String get edit_contact_details => 'Edit Contact Details';
}

// Path: go_add_edit_ministry_screen
class TranslationsGoAddEditMinistryScreenEn {
	TranslationsGoAddEditMinistryScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delete_ministry => 'Delete Ministry';
	String get delete_ministry_confirmation => 'Are you sure you want to delete {ministryName}? This will delete all associated notes.';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get ministry_deleted => 'Ministry {ministryName} deleted';
	String get ministry_details => 'Ministry Details';
	String get add_ministry => 'Add Ministry';
	String get add_note => 'Add Note';
	String get edit_details => 'Edit Details';
	String get ministry_information => 'Ministry Information';
	String get ministry_name => 'Ministry Name';
	String get contact_name => 'Contact Name';
	String get address => 'Address';
	String get phone => 'Phone';
	String get email => 'Email';
	String get not_specified => 'Not specified';
	String get partner_status => 'Partner Status';
	String get status => 'Status';
	String get map_information => 'Map Information';
	String get latitude => 'Latitude';
	String get longitude => 'Longitude';
	String get notes => 'Notes';
	String get created => 'Created';
	String get please_enter_ministry_name => 'Please enter a ministry name';
	String get please_enter_address => 'Please enter an address';
	String get phone_optional => 'Phone (Optional)';
	String get email_optional => 'Email (Optional)';
	String get please_enter_valid_email => 'Please enter a valid email';
	String get confirmed => 'Confirmed';
	String get not_confirmed => 'Not-Confirmed';
	String get undecided => 'Undecided';
	String get ministry_added => 'Ministry added!';
	String get please_enter_latitude => 'Please enter a latitude';
	String get please_enter_longitude => 'Please enter a longitude';
	String get please_enter_valid_number => 'Please enter a valid number';
}

// Path: go_add_edit_street_screen
class TranslationsGoAddEditStreetScreenEn {
	TranslationsGoAddEditStreetScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tap_to_add_points => 'Tap on the map to add points.';
	String get cancel => 'Cancel';
	String get cancel_creation => 'Cancel Creation';
	String get discard_changes => 'Discard changes to this route?';
	String get keep_editing => 'Keep Editing';
	String get discard => 'Discard';
	String get add_at_least_2_points => 'Add at least 2 points to create a route.';
	String get enter_name => 'Enter name';
	String get name => 'Name';
	String get name_cannot_be_empty => 'Name cannot be empty.';
	String get save => 'Save';
	String get edit => 'Edit';
	String get route_saved_successfully => 'Route saved successfully.';
	String get error_saving_route => 'Error saving route: {error}';
	String get contacts => 'Contacts';
	String get churches => 'Churches';
	String get ministries => 'Ministries';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get view => 'View';
	String get add => 'Add';
	String get hide_options => 'Hide Options';
	String get zoom_in => 'Zoom In';
	String get zoom_out => 'Zoom Out';
	String get add_point => 'Add Point';
	String get remove_point => 'Remove Point';
	String get street => 'Street';
	String get river => 'River';
	String get path => 'Path';
}

// Path: go_add_edit_zone_screen
class TranslationsGoAddEditZoneScreenEn {
	TranslationsGoAddEditZoneScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tap_to_set_center => 'Tap on the map to set the zone center.';
	String get cancel => 'Cancel';
	String get cancel_zone_creation => 'Cancel Zone Creation';
	String get discard_changes => 'Discard changes to this zone?';
	String get keep_editing => 'Keep Editing';
	String get discard => 'Discard';
	String get enter_name => 'Enter name';
	String get name => 'Name';
	String get name_cannot_be_empty => 'Name cannot be empty.';
	String get save => 'Save';
	String get edit => 'Edit';
	String get zone_saved_successfully => 'Zone saved successfully.';
	String get error_saving_zone => 'Error saving Zone: {error}';
	String get contacts => 'Contacts';
	String get churches => 'Churches';
	String get ministries => 'Ministries';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get view => 'View';
	String get add => 'Add';
	String get hide_options => 'Hide Options';
	String get zoom_in => 'Zoom In';
	String get zoom_out => 'Zoom Out';
	String get increase_radius => 'Increase Radius';
	String get decrease_radius => 'Decrease Radius';
	String get set_center => 'Set Center';
}

// Path: go_churches_screen
class TranslationsGoChurchesScreenEn {
	TranslationsGoChurchesScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Go Churches';
	String get add_church => 'Add Church';
	String get delete_church => 'Delete Church';
	String get delete_church_confirmation => 'Are you sure you want to delete {churchName}?';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get church_deleted => 'Church {churchName} deleted';
	String get no_churches => 'No churches added yet.';
	String get pastor => 'Pastor: {pastorName}';
	String get phone => 'Phone: {phone}';
	String get email => 'Email: {email}';
	String get address => 'Address: {address}';
	String get financial_status => 'Financial Status: {status}';
	String get notes => 'Notes:';
	String get created => 'Created: {date}';
	String get edit => 'Edit';
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
			case 'go_add_edit_area_screen.add_area_title': return 'Add Area';
			case 'go_add_edit_area_screen.edit_area_title': return 'Edit Area';
			case 'go_add_edit_area_screen.view_area_title': return 'View Area';
			case 'go_add_edit_area_screen.contacts': return 'Contacts';
			case 'go_add_edit_area_screen.churches': return 'Churches';
			case 'go_add_edit_area_screen.ministries': return 'Ministries';
			case 'go_add_edit_area_screen.areas': return 'Areas';
			case 'go_add_edit_area_screen.streets': return 'Streets';
			case 'go_add_edit_area_screen.zones': return 'Zones';
			case 'go_add_edit_church_screen.delete_church': return 'Delete Church';
			case 'go_add_edit_church_screen.delete_church_confirmation': return 'Are you sure you want to delete {churchName}? This will delete all associated notes.';
			case 'go_add_edit_church_screen.cancel': return 'Cancel';
			case 'go_add_edit_church_screen.delete': return 'Delete';
			case 'go_add_edit_church_screen.church_deleted': return 'Church {churchName} deleted';
			case 'go_add_edit_church_screen.church_details': return 'Church Details';
			case 'go_add_edit_church_screen.add_church': return 'Add Church';
			case 'go_add_edit_church_screen.add_note': return 'Add Note';
			case 'go_add_edit_church_screen.edit_details': return 'Edit Details';
			case 'go_add_edit_church_screen.church_information': return 'Church Information';
			case 'go_add_edit_church_screen.church_name': return 'Church Name';
			case 'go_add_edit_church_screen.pastor_name': return 'Pastor Name';
			case 'go_add_edit_church_screen.address': return 'Address';
			case 'go_add_edit_church_screen.phone': return 'Phone';
			case 'go_add_edit_church_screen.email': return 'Email';
			case 'go_add_edit_church_screen.not_specified': return 'Not specified';
			case 'go_add_edit_church_screen.financial_status': return 'Financial Status';
			case 'go_add_edit_church_screen.status': return 'Status';
			case 'go_add_edit_church_screen.map_information': return 'Map Information';
			case 'go_add_edit_church_screen.latitude': return 'Latitude';
			case 'go_add_edit_church_screen.longitude': return 'Longitude';
			case 'go_add_edit_church_screen.notes': return 'Notes';
			case 'go_add_edit_church_screen.created': return 'Created';
			case 'go_add_edit_church_screen.pastor_name_optional': return 'Pastor Name (Optional)';
			case 'go_add_edit_church_screen.please_enter_church_name': return 'Please enter a church name';
			case 'go_add_edit_church_screen.please_enter_address': return 'Please enter an address';
			case 'go_add_edit_church_screen.phone_optional': return 'Phone (Optional)';
			case 'go_add_edit_church_screen.email_optional': return 'Email (Optional)';
			case 'go_add_edit_church_screen.please_enter_valid_email': return 'Please enter a valid email';
			case 'go_add_edit_church_screen.supporting': return 'Supporting';
			case 'go_add_edit_church_screen.not_supporting': return 'Not-Supporting';
			case 'go_add_edit_church_screen.undecided': return 'Undecided';
			case 'go_add_edit_church_screen.church_added': return 'Church added!';
			case 'go_add_edit_church_screen.please_enter_latitude': return 'Please enter a latitude';
			case 'go_add_edit_church_screen.please_enter_longitude': return 'Please enter a longitude';
			case 'go_add_edit_church_screen.please_enter_valid_number': return 'Please enter a valid number';
			case 'go_settings_screen.title': return 'Settings';
			case 'go_settings_screen.text_settings': return 'Text Settings';
			case 'go_settings_screen.font_family': return 'Font Family';
			case 'go_settings_screen.font_size': return 'Font Size:';
			case 'go_settings_screen.preview': return 'Preview:';
			case 'go_settings_screen.back': return 'Back';
			case 'go_settings_screen.load': return 'Load';
			case 'go_settings_screen.sample_text': return 'And he said unto them, Go ye into all the world, and preach the gospel to every creature.';
			case 'go_add_edit_contact_screen.delete_contact': return 'Delete Contact';
			case 'go_add_edit_contact_screen.delete_contact_confirmation': return 'Are you sure you want to delete {fullName}? This will delete all associated notes.';
			case 'go_add_edit_contact_screen.cancel': return 'Cancel';
			case 'go_add_edit_contact_screen.delete': return 'Delete';
			case 'go_add_edit_contact_screen.contact_deleted': return 'Contact {fullName} deleted';
			case 'go_add_edit_contact_screen.contact_details': return 'Contact Details';
			case 'go_add_edit_contact_screen.add_contact': return 'Add Contact';
			case 'go_add_edit_contact_screen.add_note': return 'Add Note';
			case 'go_add_edit_contact_screen.edit_details': return 'Edit Details';
			case 'go_add_edit_contact_screen.personal_information': return 'Personal Information';
			case 'go_add_edit_contact_screen.full_name': return 'Full Name';
			case 'go_add_edit_contact_screen.address': return 'Address';
			case 'go_add_edit_contact_screen.birthday': return 'Birthday';
			case 'go_add_edit_contact_screen.phone': return 'Phone';
			case 'go_add_edit_contact_screen.email': return 'Email';
			case 'go_add_edit_contact_screen.not_specified': return 'Not specified';
			case 'go_add_edit_contact_screen.eternal_status': return 'Eternal Status';
			case 'go_add_edit_contact_screen.status': return 'Status';
			case 'go_add_edit_contact_screen.map_information': return 'Map Information';
			case 'go_add_edit_contact_screen.latitude': return 'Latitude';
			case 'go_add_edit_contact_screen.longitude': return 'Longitude';
			case 'go_add_edit_contact_screen.notes': return 'Notes';
			case 'go_add_edit_contact_screen.created': return 'Created';
			case 'go_add_edit_contact_screen.please_enter_full_name': return 'Please enter a full name';
			case 'go_add_edit_contact_screen.please_enter_address': return 'Please enter an address';
			case 'go_add_edit_contact_screen.birthday_optional': return 'Birthday (Optional)';
			case 'go_add_edit_contact_screen.phone_optional': return 'Phone (Optional)';
			case 'go_add_edit_contact_screen.email_optional': return 'Email (Optional)';
			case 'go_add_edit_contact_screen.please_enter_valid_email': return 'Please enter a valid email';
			case 'go_add_edit_contact_screen.saved': return 'Saved';
			case 'go_add_edit_contact_screen.lost': return 'Lost';
			case 'go_add_edit_contact_screen.seed_planted': return 'Seed Planted';
			case 'go_add_edit_contact_screen.contact_added': return 'Contact added!';
			case 'go_add_edit_contact_screen.save_contact': return 'Save Contact';
			case 'go_add_edit_contact_screen.edit_note': return 'Edit Note';
			case 'go_add_edit_contact_screen.contact_updated': return 'Contact updated!';
			case 'go_add_edit_contact_screen.edit_contact_details': return 'Edit Contact Details';
			case 'go_add_edit_ministry_screen.delete_ministry': return 'Delete Ministry';
			case 'go_add_edit_ministry_screen.delete_ministry_confirmation': return 'Are you sure you want to delete {ministryName}? This will delete all associated notes.';
			case 'go_add_edit_ministry_screen.cancel': return 'Cancel';
			case 'go_add_edit_ministry_screen.delete': return 'Delete';
			case 'go_add_edit_ministry_screen.ministry_deleted': return 'Ministry {ministryName} deleted';
			case 'go_add_edit_ministry_screen.ministry_details': return 'Ministry Details';
			case 'go_add_edit_ministry_screen.add_ministry': return 'Add Ministry';
			case 'go_add_edit_ministry_screen.add_note': return 'Add Note';
			case 'go_add_edit_ministry_screen.edit_details': return 'Edit Details';
			case 'go_add_edit_ministry_screen.ministry_information': return 'Ministry Information';
			case 'go_add_edit_ministry_screen.ministry_name': return 'Ministry Name';
			case 'go_add_edit_ministry_screen.contact_name': return 'Contact Name';
			case 'go_add_edit_ministry_screen.address': return 'Address';
			case 'go_add_edit_ministry_screen.phone': return 'Phone';
			case 'go_add_edit_ministry_screen.email': return 'Email';
			case 'go_add_edit_ministry_screen.not_specified': return 'Not specified';
			case 'go_add_edit_ministry_screen.partner_status': return 'Partner Status';
			case 'go_add_edit_ministry_screen.status': return 'Status';
			case 'go_add_edit_ministry_screen.map_information': return 'Map Information';
			case 'go_add_edit_ministry_screen.latitude': return 'Latitude';
			case 'go_add_edit_ministry_screen.longitude': return 'Longitude';
			case 'go_add_edit_ministry_screen.notes': return 'Notes';
			case 'go_add_edit_ministry_screen.created': return 'Created';
			case 'go_add_edit_ministry_screen.please_enter_ministry_name': return 'Please enter a ministry name';
			case 'go_add_edit_ministry_screen.please_enter_address': return 'Please enter an address';
			case 'go_add_edit_ministry_screen.phone_optional': return 'Phone (Optional)';
			case 'go_add_edit_ministry_screen.email_optional': return 'Email (Optional)';
			case 'go_add_edit_ministry_screen.please_enter_valid_email': return 'Please enter a valid email';
			case 'go_add_edit_ministry_screen.confirmed': return 'Confirmed';
			case 'go_add_edit_ministry_screen.not_confirmed': return 'Not-Confirmed';
			case 'go_add_edit_ministry_screen.undecided': return 'Undecided';
			case 'go_add_edit_ministry_screen.ministry_added': return 'Ministry added!';
			case 'go_add_edit_ministry_screen.please_enter_latitude': return 'Please enter a latitude';
			case 'go_add_edit_ministry_screen.please_enter_longitude': return 'Please enter a longitude';
			case 'go_add_edit_ministry_screen.please_enter_valid_number': return 'Please enter a valid number';
			case 'go_add_edit_street_screen.tap_to_add_points': return 'Tap on the map to add points.';
			case 'go_add_edit_street_screen.cancel': return 'Cancel';
			case 'go_add_edit_street_screen.cancel_creation': return 'Cancel Creation';
			case 'go_add_edit_street_screen.discard_changes': return 'Discard changes to this route?';
			case 'go_add_edit_street_screen.keep_editing': return 'Keep Editing';
			case 'go_add_edit_street_screen.discard': return 'Discard';
			case 'go_add_edit_street_screen.add_at_least_2_points': return 'Add at least 2 points to create a route.';
			case 'go_add_edit_street_screen.enter_name': return 'Enter name';
			case 'go_add_edit_street_screen.name': return 'Name';
			case 'go_add_edit_street_screen.name_cannot_be_empty': return 'Name cannot be empty.';
			case 'go_add_edit_street_screen.save': return 'Save';
			case 'go_add_edit_street_screen.edit': return 'Edit';
			case 'go_add_edit_street_screen.route_saved_successfully': return 'Route saved successfully.';
			case 'go_add_edit_street_screen.error_saving_route': return 'Error saving route: {error}';
			case 'go_add_edit_street_screen.contacts': return 'Contacts';
			case 'go_add_edit_street_screen.churches': return 'Churches';
			case 'go_add_edit_street_screen.ministries': return 'Ministries';
			case 'go_add_edit_street_screen.areas': return 'Areas';
			case 'go_add_edit_street_screen.streets': return 'Streets';
			case 'go_add_edit_street_screen.zones': return 'Zones';
			case 'go_add_edit_street_screen.view': return 'View';
			case 'go_add_edit_street_screen.add': return 'Add';
			case 'go_add_edit_street_screen.hide_options': return 'Hide Options';
			case 'go_add_edit_street_screen.zoom_in': return 'Zoom In';
			case 'go_add_edit_street_screen.zoom_out': return 'Zoom Out';
			case 'go_add_edit_street_screen.add_point': return 'Add Point';
			case 'go_add_edit_street_screen.remove_point': return 'Remove Point';
			case 'go_add_edit_street_screen.street': return 'Street';
			case 'go_add_edit_street_screen.river': return 'River';
			case 'go_add_edit_street_screen.path': return 'Path';
			case 'go_add_edit_zone_screen.tap_to_set_center': return 'Tap on the map to set the zone center.';
			case 'go_add_edit_zone_screen.cancel': return 'Cancel';
			case 'go_add_edit_zone_screen.cancel_zone_creation': return 'Cancel Zone Creation';
			case 'go_add_edit_zone_screen.discard_changes': return 'Discard changes to this zone?';
			case 'go_add_edit_zone_screen.keep_editing': return 'Keep Editing';
			case 'go_add_edit_zone_screen.discard': return 'Discard';
			case 'go_add_edit_zone_screen.enter_name': return 'Enter name';
			case 'go_add_edit_zone_screen.name': return 'Name';
			case 'go_add_edit_zone_screen.name_cannot_be_empty': return 'Name cannot be empty.';
			case 'go_add_edit_zone_screen.save': return 'Save';
			case 'go_add_edit_zone_screen.edit': return 'Edit';
			case 'go_add_edit_zone_screen.zone_saved_successfully': return 'Zone saved successfully.';
			case 'go_add_edit_zone_screen.error_saving_zone': return 'Error saving Zone: {error}';
			case 'go_add_edit_zone_screen.contacts': return 'Contacts';
			case 'go_add_edit_zone_screen.churches': return 'Churches';
			case 'go_add_edit_zone_screen.ministries': return 'Ministries';
			case 'go_add_edit_zone_screen.areas': return 'Areas';
			case 'go_add_edit_zone_screen.streets': return 'Streets';
			case 'go_add_edit_zone_screen.zones': return 'Zones';
			case 'go_add_edit_zone_screen.view': return 'View';
			case 'go_add_edit_zone_screen.add': return 'Add';
			case 'go_add_edit_zone_screen.hide_options': return 'Hide Options';
			case 'go_add_edit_zone_screen.zoom_in': return 'Zoom In';
			case 'go_add_edit_zone_screen.zoom_out': return 'Zoom Out';
			case 'go_add_edit_zone_screen.increase_radius': return 'Increase Radius';
			case 'go_add_edit_zone_screen.decrease_radius': return 'Decrease Radius';
			case 'go_add_edit_zone_screen.set_center': return 'Set Center';
			case 'go_churches_screen.title': return 'Go Churches';
			case 'go_churches_screen.add_church': return 'Add Church';
			case 'go_churches_screen.delete_church': return 'Delete Church';
			case 'go_churches_screen.delete_church_confirmation': return 'Are you sure you want to delete {churchName}?';
			case 'go_churches_screen.cancel': return 'Cancel';
			case 'go_churches_screen.delete': return 'Delete';
			case 'go_churches_screen.church_deleted': return 'Church {churchName} deleted';
			case 'go_churches_screen.no_churches': return 'No churches added yet.';
			case 'go_churches_screen.pastor': return 'Pastor: {pastorName}';
			case 'go_churches_screen.phone': return 'Phone: {phone}';
			case 'go_churches_screen.email': return 'Email: {email}';
			case 'go_churches_screen.address': return 'Address: {address}';
			case 'go_churches_screen.financial_status': return 'Financial Status: {status}';
			case 'go_churches_screen.notes': return 'Notes:';
			case 'go_churches_screen.created': return 'Created: {date}';
			case 'go_churches_screen.edit': return 'Edit';
			default: return null;
		}
	}
}

