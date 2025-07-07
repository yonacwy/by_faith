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
	late final TranslationsMainEn main = TranslationsMainEn._(_root);
	late final TranslationsHomeBuilderScreenEn home_builder_screen = TranslationsHomeBuilderScreenEn._(_root);
	late final TranslationsHomeJournalScreenEn home_journal_screen = TranslationsHomeJournalScreenEn._(_root);
	late final TranslationsHomeLibraryScreenEn home_library_screen = TranslationsHomeLibraryScreenEn._(_root);
	late final TranslationsHomeSearchScreenEn home_search_screen = TranslationsHomeSearchScreenEn._(_root);
	late final TranslationsHomeSettingsScreenEn home_settings_screen = TranslationsHomeSettingsScreenEn._(_root);
	late final TranslationsHomeTabScreenEn home_tab_screen = TranslationsHomeTabScreenEn._(_root);
	late final TranslationsGoAddEditAreaScreenEn go_add_edit_area_screen = TranslationsGoAddEditAreaScreenEn._(_root);
	late final TranslationsGoAddEditChurchScreenEn go_add_edit_church_screen = TranslationsGoAddEditChurchScreenEn._(_root);
	late final TranslationsGoAddEditContactScreenEn go_add_edit_contact_screen = TranslationsGoAddEditContactScreenEn._(_root);
	late final TranslationsGoAddEditMinistryScreenEn go_add_edit_ministry_screen = TranslationsGoAddEditMinistryScreenEn._(_root);
	late final TranslationsGoAddEditStreetScreenEn go_add_edit_street_screen = TranslationsGoAddEditStreetScreenEn._(_root);
	late final TranslationsGoAddEditZoneScreenEn go_add_edit_zone_screen = TranslationsGoAddEditZoneScreenEn._(_root);
	late final TranslationsGoChurchesScreenEn go_churches_screen = TranslationsGoChurchesScreenEn._(_root);
	late final TranslationsGoContactsScreenEn go_contacts_screen = TranslationsGoContactsScreenEn._(_root);
	late final TranslationsGoExportImportScreenEn go_export_import_screen = TranslationsGoExportImportScreenEn._(_root);
	late final TranslationsGoMinistriesScreenEn go_ministries_screen = TranslationsGoMinistriesScreenEn._(_root);
	late final TranslationsGoOfflineMapsScreenEn go_offline_maps_screen = TranslationsGoOfflineMapsScreenEn._(_root);
	late final TranslationsGoRoutePlannerScreenEn go_route_planner_screen = TranslationsGoRoutePlannerScreenEn._(_root);
	late final TranslationsGoSearchScreenEn go_search_screen = TranslationsGoSearchScreenEn._(_root);
	late final TranslationsGoSelectMapAreaScreenEn go_select_map_area_screen = TranslationsGoSelectMapAreaScreenEn._(_root);
	late final TranslationsGoSelectMapRoutesScreenEn go_select_map_routes_screen = TranslationsGoSelectMapRoutesScreenEn._(_root);
	late final TranslationsGoSettingsScreenEn go_settings_screen = TranslationsGoSettingsScreenEn._(_root);
	late final TranslationsGoShareScreenEn go_share_screen = TranslationsGoShareScreenEn._(_root);
	late final TranslationsGoTabScreenEn go_tab_screen = TranslationsGoTabScreenEn._(_root);
	late final TranslationsStudyPlansScreenEn study_plans_screen = TranslationsStudyPlansScreenEn._(_root);
	late final TranslationsStudySettingsScreenEn study_settings_screen = TranslationsStudySettingsScreenEn._(_root);
	late final TranslationsStudyTabScreenEn study_tab_screen = TranslationsStudyTabScreenEn._(_root);
}

// Path: main
class TranslationsMainEn {
	TranslationsMainEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'By Faith';
	String get home => 'Home';
	String get pray => 'Pray';
	String get read => 'Read';
	String get study => 'Study';
	String get go => 'Go';
}

// Path: home_builder_screen
class TranslationsHomeBuilderScreenEn {
	TranslationsHomeBuilderScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Builder';
	String get content => 'Content';
}

// Path: home_journal_screen
class TranslationsHomeJournalScreenEn {
	TranslationsHomeJournalScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Journal';
	String get content => 'Content';
}

// Path: home_library_screen
class TranslationsHomeLibraryScreenEn {
	TranslationsHomeLibraryScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Library';
	String get content => 'Content';
}

// Path: home_search_screen
class TranslationsHomeSearchScreenEn {
	TranslationsHomeSearchScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Search';
	String get content => 'Content';
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
	String get hindi => 'Hindi';
	String get text_settings => 'Text Settings';
	String get font_family => 'Font Family';
	String get font_size => 'Font Size:';
	String get preview => 'Preview:';
	String get global_settings => 'Global Settings';
	String get language_settings => 'Language Settings';
	String get app_language => 'App Language';
	String get back => 'Back';
	String get load => 'Load';
	String get bible_settings => 'Bible Settings';
	String get bible_install => 'Bible Install';
	String get uploaded_file => 'Uploaded File';
	String get upload_bible => 'Upload Bible';
	String get install_bible => 'Install Bible';
	String get bible_download => 'Bible Download';
	String get download_instructions => 'Download instructions will appear here.';
	String get bibles_installed => 'Bibles Installed';
	String get file_not_selected => 'No file selected.';
	String get file_not_found => 'File not found.';
	String get not_a_zip_file => 'Please select a valid ZIP file.';
	String get upload_success => 'Bible uploaded and extracted successfully!';
	String get upload_failed => 'Upload failed';
	String get no_xml_found => 'No XML Bible file found in the ZIP.';
	String get bible_already_exists => 'Bible version \'{name}\' already exists.';
	String get invalid_bible_xml => 'Invalid Bible XML file: No <usfx> element found.';
	String get no_bibles_installed => 'No Bibles installed.';
	String get delete_bible => 'Delete Bible';
	String get confirm_delete_title => 'Delete Bible?';
	String get confirm_delete_message => 'Are you sure you want to delete {name}? This will remove all associated data.';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get bible_deleted => 'Bible \'{name}\' deleted.';
	String get preparing_upload => 'Preparing upload...';
	String get deleting_bible => 'Deleting Bible \'{name}\'...';
	String get extracting_and_parsing => 'Extracting and parsing Bible data...';
	String get saving_to_database => 'Saving to database...';
	String get delete_failed => 'Deletion failed';
	String get file_selected => 'File selected.';
	String get file_selected_success => 'File \'{name}\' selected successfully.';
	String get no_file_to_install => 'No file selected for installation.';
	String get install_failed => 'Installation failed';
	String get install_success => 'Bible installed successfully!';
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
	String get builder => 'Builder';
	String get calendar => 'Calendar';
	String get journal => 'Journal';
	String get library => 'Library';
	String get search => 'Search';
	String get settings => 'Settings';
	String get content => 'Home Tab Content';
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
	String get view_street_title => 'View Street';
	String get edit_street_title => 'Edit Street';
	String get add_street_title => 'Add Street';
	String get save_street => 'Save Street';
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
	String get view_zone_title => 'View Zone';
	String get edit_zone_title => 'Edit Zone';
	String get add_zone_title => 'Add Zone';
	String get save_zone => 'Save Zone';
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

// Path: go_contacts_screen
class TranslationsGoContactsScreenEn {
	TranslationsGoContactsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Go Contacts';
	String get add_contact => 'Add Contact';
	String get delete_contact => 'Delete Contact';
	String get delete_contact_confirmation => 'Are you sure you want to delete {fullName}?';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get contact_deleted => 'Contact {fullName} deleted';
	String get no_contacts => 'No contacts added yet.';
	String get full_name => 'Full Name';
	String get phone => 'Phone: {phone}';
	String get email => 'Email: {email}';
	String get address => 'Address: {address}';
	String get eternal_status => 'Eternal Status: {status}';
	String get birthday => 'Birthday: {birthday}';
	String get notes => 'Notes:';
	String get created => 'Created: {date}';
	String get edit => 'Edit';
}

// Path: go_export_import_screen
class TranslationsGoExportImportScreenEn {
	TranslationsGoExportImportScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Export/Import';
	String get export_data => 'Export Data';
	String get import_data => 'Import Data';
	String get churches => 'Churches';
	String get contacts => 'Contacts';
	String get ministries => 'Ministries';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get all => 'All';
	String get no_churches => 'No churches available';
	String get no_contacts => 'No contacts available';
	String get no_ministries => 'No ministries available';
	String get no_areas => 'No areas available';
	String get no_streets => 'No streets available';
	String get no_zones => 'No zones available';
	String get save_json => 'Save {type} JSON';
	String get select_json => 'Select {type} JSON';
	String get export_success => '{type} exported successfully';
	String get import_success => '{type} imported successfully';
	String get error_export => 'Error exporting {type}: {error}';
	String get error_import => 'Error importing {type}: {error}';
	String get invalid_file => 'Invalid file: Expected {type} data';
	String get all_export_success => 'All data exported successfully';
	String get all_import_success => 'All data imported successfully';
	String get error_export_all => 'Error exporting all data: {error}';
	String get error_import_all => 'Error importing all data: {error}';
}

// Path: go_ministries_screen
class TranslationsGoMinistriesScreenEn {
	TranslationsGoMinistriesScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Go Ministries';
	String get add_ministry => 'Add Ministry';
	String get delete_ministry => 'Delete Ministry';
	String get delete_ministry_confirmation => 'Are you sure you want to delete {ministryName}?';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get ministry_deleted => 'Ministry {ministryName} deleted';
	String get no_ministries => 'No ministries added yet.';
	String get contact => 'Contact: {contactName}';
	String get phone => 'Phone: {phone}';
	String get email => 'Email: {email}';
	String get address => 'Address: {address}';
	String get partner_status => 'Partner Status: {status}';
	String get notes => 'Notes:';
	String get created => 'Created: {date}';
	String get edit => 'Edit';
}

// Path: go_offline_maps_screen
class TranslationsGoOfflineMapsScreenEn {
	TranslationsGoOfflineMapsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Offline Maps';
	String get select_your_own_map => 'Select your own map';
	String get downloaded_maps => 'Downloaded Maps';
	String get no_maps_downloaded => 'No maps downloaded yet.';
	String get max_maps_warning => 'You can only have up to 5 maps (including the default World map). Please delete a map before downloading a new one.';
	String get failed_to_delete_map => 'Failed to delete map ({mapName}): {error}';
	String get rename_map => 'Rename Map';
	String get enter_new_map_name => 'Enter new map name';
	String get cancel => 'Cancel';
	String get save => 'Save';
	String get failed_to_rename_map => 'Failed to rename map: {error}';
	String get view => 'View';
	String get update => 'Update';
	String get rename => 'Rename';
	String get delete => 'Delete';
	String get world => 'World';
	String get map_updated_successfully => 'Map "{mapName}" updated successfully';
	String get failed_to_update_map => 'Failed to update map: {error}';
}

// Path: go_route_planner_screen
class TranslationsGoRoutePlannerScreenEn {
	TranslationsGoRoutePlannerScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Route Planner';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get no_areas => 'No areas added yet.';
	String get no_streets => 'No streets added yet.';
	String get no_zones => 'No zones added yet.';
	String get edit => 'Edit';
	String get rename => 'Rename';
	String get delete => 'Delete';
	String get view => 'View';
	String get add => 'Add';
	String get lat => 'Lat: {lat}';
	String get lon => 'Lon: {lon}';
	String get no_coordinates => 'No coordinates';
	String get failed_to_delete => 'Failed to delete {type}: {error}';
	String get failed_to_rename => 'Failed to rename {type}: {error}';
	String get rename_type => 'Rename {type}';
	String get enter_new_name => 'Enter new name';
	String get cancel => 'Cancel';
	String get save => 'Save';
}

// Path: go_search_screen
class TranslationsGoSearchScreenEn {
	TranslationsGoSearchScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Search Address';
	String get enter_address => 'Enter address';
	String get please_enter_address => 'Please enter an address.';
	String get address_not_found => 'Address not found.';
	String get found => 'Found: {displayName}';
	String get latitude => 'Latitude: {lat}';
	String get longitude => 'Longitude: {lon}';
	String get error_searching_address => 'Error searching address: {error}';
	String get search => 'Search';
}

// Path: go_select_map_area_screen
class TranslationsGoSelectMapAreaScreenEn {
	TranslationsGoSelectMapAreaScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select Map Area';
	String get download_limit_exceeded => 'Download Limit Exceeded';
	String get download_limit_message => 'The selected area exceeds the maximum allowed: 12,000 tiles or 155.55 MB. Please select a smaller area.';
	String get ok => 'OK';
	String get download_map => 'Download Map';
	String get download_map_question => 'Download map of this area? Estimated tiles: {tiles}, approximately {size} MB.';
	String get close => 'Close';
	String get name_your_map => 'Name Your Map';
	String get enter_map_name => 'Enter map name';
	String get cancel => 'Cancel';
	String get download => 'Download';
}

// Path: go_select_map_routes_screen
class TranslationsGoSelectMapRoutesScreenEn {
	TranslationsGoSelectMapRoutesScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Select Map Route';
	String get select => 'Select';
	String get edit => 'Edit';
	String get view => 'View';
	String get area => 'Area';
	String get street => 'Street';
	String get tag => 'Tag';
	String get add_at_least_3_points => 'Add at least 3 points to create an area.';
	String get add_at_least_2_points => 'Add at least 2 points to create a street.';
	String get add_a_tag => 'Add a tag to save.';
	String get enter_name => 'Enter name';
	String get name => 'Name';
	String get name_cannot_be_empty => 'Name cannot be empty.';
	String get save => 'Save';
	String get cancel => 'Cancel';
	String get tag_text => 'Tag Text';
	String get enter_tag_text => 'Enter tag text';
	String get error_loading_item => 'Error loading item: {error}';
	String get error_adding_point => 'Error adding point: {error}';
	String get error_saving_item => 'Error saving item: {error}';
	String get zoom_in => 'Zoom In';
	String get zoom_out => 'Zoom Out';
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

// Path: go_share_screen
class TranslationsGoShareScreenEn {
	TranslationsGoShareScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Share';
	String get churches => 'Churches';
	String get contacts => 'Contacts';
	String get ministries => 'Ministries';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get all => 'All';
	String get no_churches => 'No churches available';
	String get no_contacts => 'No contacts available';
	String get no_ministries => 'No ministries available';
	String get no_areas => 'No areas available';
	String get no_streets => 'No streets available';
	String get no_zones => 'No zones available';
	String get share_all_data => 'Share All Data';
	String get all_by_faith_data => 'All By Faith Data';
	String get could_not_launch_email => 'Could not launch email client';
}

// Path: go_tab_screen
class TranslationsGoTabScreenEn {
	TranslationsGoTabScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get markers_in_zone => 'Markers in Zone';
	String get close => 'Close';
	String get add_area => 'Add Area';
	String get add_street => 'Add Street';
	String get add_zone => 'Add Zone';
	String get add_contact => 'Add Contact';
	String get add_church => 'Add Church';
	String get add_ministry => 'Add Ministry';
	String get offline_maps => 'Offline Maps';
	String get route_planner => 'Route Planner';
	String get churches => 'Churches';
	String get contacts => 'Contacts';
	String get ministries => 'Ministries';
	String get menu => 'Go Menu';
	String get search_address => 'Search Address';
	String get save_route => 'Save Route';
	String get hide_options => 'Hide Options';
	String get open_menu => 'Open Menu';
	String get tap_to_add_marker => 'Tap on the map to add a marker.';
	String get route_creation_cancelled => 'Route creation cancelled.';
	String get add_at_least_3_points => 'Add at least 3 points to create an area.';
	String get add_at_least_2_points => 'Add at least 2 points to create a street.';
	String get enter_name => 'Enter name';
	String get name => 'Name';
	String get cancel => 'Cancel';
	String get save => 'Save';
	String get search => 'Search';
	String get address_not_found => 'Address not found.';
	String get error_searching_address => 'Error searching address: {error}';
	String get downloading => 'Downloading {mapName}';
	String get starting_download => 'Starting download...';
	String get downloaded_tiles => 'Downloaded {attempted} of {max} tiles ({percent}%)';
	String get failed_to_download_map => 'Failed to download map ({mapName}): {error}';
	String get tap_to_place_the_zone => 'Tap to place the zone.';
	String get select_area_or_street_from_the_route_planner => 'Select area or street from the route planner.';
	String get areas => 'Areas';
	String get streets => 'Streets';
	String get zones => 'Zones';
	String get enter_address => 'Enter address';
	String get world => 'World';
	String get go_menu => 'Go Menu';
}

// Path: study_plans_screen
class TranslationsStudyPlansScreenEn {
	TranslationsStudyPlansScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Study Plans';
	String get content => 'Study Plans Content';
}

// Path: study_settings_screen
class TranslationsStudySettingsScreenEn {
	TranslationsStudySettingsScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get text_settings => 'Text Settings';
	String get font_family => 'Font Family';
	String get font_size => 'Font Size:';
	String get preview => 'Preview:';
	String get back => 'Back';
	String get load => 'Load';
	String get sample_text => 'Study to shew thyself approved unto God, a workman that needeth not to be ashamed, rightly dividing the word of truth.';
}

// Path: study_tab_screen
class TranslationsStudyTabScreenEn {
	TranslationsStudyTabScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Study';
	String get study_menu => 'Study Menu';
	String get bibles => 'Bibles';
	String get no_bibles_installed => 'No Bibles installed yet.';
	String get select_bible_version => 'Select Bible Version';
	String get select_book => 'Select Book';
	String get select_chapter => 'Select Chapter';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'main.title': return 'By Faith';
			case 'main.home': return 'Home';
			case 'main.pray': return 'Pray';
			case 'main.read': return 'Read';
			case 'main.study': return 'Study';
			case 'main.go': return 'Go';
			case 'home_builder_screen.title': return 'Builder';
			case 'home_builder_screen.content': return 'Content';
			case 'home_journal_screen.title': return 'Journal';
			case 'home_journal_screen.content': return 'Content';
			case 'home_library_screen.title': return 'Library';
			case 'home_library_screen.content': return 'Content';
			case 'home_search_screen.title': return 'Search';
			case 'home_search_screen.content': return 'Content';
			case 'home_settings_screen.title': return 'Settings';
			case 'home_settings_screen.language': return 'Language';
			case 'home_settings_screen.english': return 'English';
			case 'home_settings_screen.spanish': return 'Spanish';
			case 'home_settings_screen.hindi': return 'Hindi';
			case 'home_settings_screen.text_settings': return 'Text Settings';
			case 'home_settings_screen.font_family': return 'Font Family';
			case 'home_settings_screen.font_size': return 'Font Size:';
			case 'home_settings_screen.preview': return 'Preview:';
			case 'home_settings_screen.global_settings': return 'Global Settings';
			case 'home_settings_screen.language_settings': return 'Language Settings';
			case 'home_settings_screen.app_language': return 'App Language';
			case 'home_settings_screen.back': return 'Back';
			case 'home_settings_screen.load': return 'Load';
			case 'home_settings_screen.bible_settings': return 'Bible Settings';
			case 'home_settings_screen.bible_install': return 'Bible Install';
			case 'home_settings_screen.uploaded_file': return 'Uploaded File';
			case 'home_settings_screen.upload_bible': return 'Upload Bible';
			case 'home_settings_screen.install_bible': return 'Install Bible';
			case 'home_settings_screen.bible_download': return 'Bible Download';
			case 'home_settings_screen.download_instructions': return 'Download instructions will appear here.';
			case 'home_settings_screen.bibles_installed': return 'Bibles Installed';
			case 'home_settings_screen.file_not_selected': return 'No file selected.';
			case 'home_settings_screen.file_not_found': return 'File not found.';
			case 'home_settings_screen.not_a_zip_file': return 'Please select a valid ZIP file.';
			case 'home_settings_screen.upload_success': return 'Bible uploaded and extracted successfully!';
			case 'home_settings_screen.upload_failed': return 'Upload failed';
			case 'home_settings_screen.no_xml_found': return 'No XML Bible file found in the ZIP.';
			case 'home_settings_screen.bible_already_exists': return 'Bible version \'{name}\' already exists.';
			case 'home_settings_screen.invalid_bible_xml': return 'Invalid Bible XML file: No <usfx> element found.';
			case 'home_settings_screen.no_bibles_installed': return 'No Bibles installed.';
			case 'home_settings_screen.delete_bible': return 'Delete Bible';
			case 'home_settings_screen.confirm_delete_title': return 'Delete Bible?';
			case 'home_settings_screen.confirm_delete_message': return 'Are you sure you want to delete {name}? This will remove all associated data.';
			case 'home_settings_screen.cancel': return 'Cancel';
			case 'home_settings_screen.delete': return 'Delete';
			case 'home_settings_screen.bible_deleted': return 'Bible \'{name}\' deleted.';
			case 'home_settings_screen.preparing_upload': return 'Preparing upload...';
			case 'home_settings_screen.deleting_bible': return 'Deleting Bible \'{name}\'...';
			case 'home_settings_screen.extracting_and_parsing': return 'Extracting and parsing Bible data...';
			case 'home_settings_screen.saving_to_database': return 'Saving to database...';
			case 'home_settings_screen.delete_failed': return 'Deletion failed';
			case 'home_settings_screen.file_selected': return 'File selected.';
			case 'home_settings_screen.file_selected_success': return 'File \'{name}\' selected successfully.';
			case 'home_settings_screen.no_file_to_install': return 'No file selected for installation.';
			case 'home_settings_screen.install_failed': return 'Installation failed';
			case 'home_settings_screen.install_success': return 'Bible installed successfully!';
			case 'home_tab_screen.title': return 'Home';
			case 'home_tab_screen.menu': return 'Home Menu';
			case 'home_tab_screen.info': return 'Info';
			case 'home_tab_screen.support': return 'Support';
			case 'home_tab_screen.profile': return 'Profile';
			case 'home_tab_screen.builder': return 'Builder';
			case 'home_tab_screen.calendar': return 'Calendar';
			case 'home_tab_screen.journal': return 'Journal';
			case 'home_tab_screen.library': return 'Library';
			case 'home_tab_screen.search': return 'Search';
			case 'home_tab_screen.settings': return 'Settings';
			case 'home_tab_screen.content': return 'Home Tab Content';
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
			case 'go_add_edit_street_screen.view_street_title': return 'View Street';
			case 'go_add_edit_street_screen.edit_street_title': return 'Edit Street';
			case 'go_add_edit_street_screen.add_street_title': return 'Add Street';
			case 'go_add_edit_street_screen.save_street': return 'Save Street';
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
			case 'go_add_edit_zone_screen.view_zone_title': return 'View Zone';
			case 'go_add_edit_zone_screen.edit_zone_title': return 'Edit Zone';
			case 'go_add_edit_zone_screen.add_zone_title': return 'Add Zone';
			case 'go_add_edit_zone_screen.save_zone': return 'Save Zone';
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
			case 'go_contacts_screen.title': return 'Go Contacts';
			case 'go_contacts_screen.add_contact': return 'Add Contact';
			case 'go_contacts_screen.delete_contact': return 'Delete Contact';
			case 'go_contacts_screen.delete_contact_confirmation': return 'Are you sure you want to delete {fullName}?';
			case 'go_contacts_screen.cancel': return 'Cancel';
			case 'go_contacts_screen.delete': return 'Delete';
			case 'go_contacts_screen.contact_deleted': return 'Contact {fullName} deleted';
			case 'go_contacts_screen.no_contacts': return 'No contacts added yet.';
			case 'go_contacts_screen.full_name': return 'Full Name';
			case 'go_contacts_screen.phone': return 'Phone: {phone}';
			case 'go_contacts_screen.email': return 'Email: {email}';
			case 'go_contacts_screen.address': return 'Address: {address}';
			case 'go_contacts_screen.eternal_status': return 'Eternal Status: {status}';
			case 'go_contacts_screen.birthday': return 'Birthday: {birthday}';
			case 'go_contacts_screen.notes': return 'Notes:';
			case 'go_contacts_screen.created': return 'Created: {date}';
			case 'go_contacts_screen.edit': return 'Edit';
			case 'go_export_import_screen.title': return 'Export/Import';
			case 'go_export_import_screen.export_data': return 'Export Data';
			case 'go_export_import_screen.import_data': return 'Import Data';
			case 'go_export_import_screen.churches': return 'Churches';
			case 'go_export_import_screen.contacts': return 'Contacts';
			case 'go_export_import_screen.ministries': return 'Ministries';
			case 'go_export_import_screen.areas': return 'Areas';
			case 'go_export_import_screen.streets': return 'Streets';
			case 'go_export_import_screen.zones': return 'Zones';
			case 'go_export_import_screen.all': return 'All';
			case 'go_export_import_screen.no_churches': return 'No churches available';
			case 'go_export_import_screen.no_contacts': return 'No contacts available';
			case 'go_export_import_screen.no_ministries': return 'No ministries available';
			case 'go_export_import_screen.no_areas': return 'No areas available';
			case 'go_export_import_screen.no_streets': return 'No streets available';
			case 'go_export_import_screen.no_zones': return 'No zones available';
			case 'go_export_import_screen.save_json': return 'Save {type} JSON';
			case 'go_export_import_screen.select_json': return 'Select {type} JSON';
			case 'go_export_import_screen.export_success': return '{type} exported successfully';
			case 'go_export_import_screen.import_success': return '{type} imported successfully';
			case 'go_export_import_screen.error_export': return 'Error exporting {type}: {error}';
			case 'go_export_import_screen.error_import': return 'Error importing {type}: {error}';
			case 'go_export_import_screen.invalid_file': return 'Invalid file: Expected {type} data';
			case 'go_export_import_screen.all_export_success': return 'All data exported successfully';
			case 'go_export_import_screen.all_import_success': return 'All data imported successfully';
			case 'go_export_import_screen.error_export_all': return 'Error exporting all data: {error}';
			case 'go_export_import_screen.error_import_all': return 'Error importing all data: {error}';
			case 'go_ministries_screen.title': return 'Go Ministries';
			case 'go_ministries_screen.add_ministry': return 'Add Ministry';
			case 'go_ministries_screen.delete_ministry': return 'Delete Ministry';
			case 'go_ministries_screen.delete_ministry_confirmation': return 'Are you sure you want to delete {ministryName}?';
			case 'go_ministries_screen.cancel': return 'Cancel';
			case 'go_ministries_screen.delete': return 'Delete';
			case 'go_ministries_screen.ministry_deleted': return 'Ministry {ministryName} deleted';
			case 'go_ministries_screen.no_ministries': return 'No ministries added yet.';
			case 'go_ministries_screen.contact': return 'Contact: {contactName}';
			case 'go_ministries_screen.phone': return 'Phone: {phone}';
			case 'go_ministries_screen.email': return 'Email: {email}';
			case 'go_ministries_screen.address': return 'Address: {address}';
			case 'go_ministries_screen.partner_status': return 'Partner Status: {status}';
			case 'go_ministries_screen.notes': return 'Notes:';
			case 'go_ministries_screen.created': return 'Created: {date}';
			case 'go_ministries_screen.edit': return 'Edit';
			case 'go_offline_maps_screen.title': return 'Offline Maps';
			case 'go_offline_maps_screen.select_your_own_map': return 'Select your own map';
			case 'go_offline_maps_screen.downloaded_maps': return 'Downloaded Maps';
			case 'go_offline_maps_screen.no_maps_downloaded': return 'No maps downloaded yet.';
			case 'go_offline_maps_screen.max_maps_warning': return 'You can only have up to 5 maps (including the default World map). Please delete a map before downloading a new one.';
			case 'go_offline_maps_screen.failed_to_delete_map': return 'Failed to delete map ({mapName}): {error}';
			case 'go_offline_maps_screen.rename_map': return 'Rename Map';
			case 'go_offline_maps_screen.enter_new_map_name': return 'Enter new map name';
			case 'go_offline_maps_screen.cancel': return 'Cancel';
			case 'go_offline_maps_screen.save': return 'Save';
			case 'go_offline_maps_screen.failed_to_rename_map': return 'Failed to rename map: {error}';
			case 'go_offline_maps_screen.view': return 'View';
			case 'go_offline_maps_screen.update': return 'Update';
			case 'go_offline_maps_screen.rename': return 'Rename';
			case 'go_offline_maps_screen.delete': return 'Delete';
			case 'go_offline_maps_screen.world': return 'World';
			case 'go_offline_maps_screen.map_updated_successfully': return 'Map "{mapName}" updated successfully';
			case 'go_offline_maps_screen.failed_to_update_map': return 'Failed to update map: {error}';
			case 'go_route_planner_screen.title': return 'Route Planner';
			case 'go_route_planner_screen.areas': return 'Areas';
			case 'go_route_planner_screen.streets': return 'Streets';
			case 'go_route_planner_screen.zones': return 'Zones';
			case 'go_route_planner_screen.no_areas': return 'No areas added yet.';
			case 'go_route_planner_screen.no_streets': return 'No streets added yet.';
			case 'go_route_planner_screen.no_zones': return 'No zones added yet.';
			case 'go_route_planner_screen.edit': return 'Edit';
			case 'go_route_planner_screen.rename': return 'Rename';
			case 'go_route_planner_screen.delete': return 'Delete';
			case 'go_route_planner_screen.view': return 'View';
			case 'go_route_planner_screen.add': return 'Add';
			case 'go_route_planner_screen.lat': return 'Lat: {lat}';
			case 'go_route_planner_screen.lon': return 'Lon: {lon}';
			case 'go_route_planner_screen.no_coordinates': return 'No coordinates';
			case 'go_route_planner_screen.failed_to_delete': return 'Failed to delete {type}: {error}';
			case 'go_route_planner_screen.failed_to_rename': return 'Failed to rename {type}: {error}';
			case 'go_route_planner_screen.rename_type': return 'Rename {type}';
			case 'go_route_planner_screen.enter_new_name': return 'Enter new name';
			case 'go_route_planner_screen.cancel': return 'Cancel';
			case 'go_route_planner_screen.save': return 'Save';
			case 'go_search_screen.title': return 'Search Address';
			case 'go_search_screen.enter_address': return 'Enter address';
			case 'go_search_screen.please_enter_address': return 'Please enter an address.';
			case 'go_search_screen.address_not_found': return 'Address not found.';
			case 'go_search_screen.found': return 'Found: {displayName}';
			case 'go_search_screen.latitude': return 'Latitude: {lat}';
			case 'go_search_screen.longitude': return 'Longitude: {lon}';
			case 'go_search_screen.error_searching_address': return 'Error searching address: {error}';
			case 'go_search_screen.search': return 'Search';
			case 'go_select_map_area_screen.title': return 'Select Map Area';
			case 'go_select_map_area_screen.download_limit_exceeded': return 'Download Limit Exceeded';
			case 'go_select_map_area_screen.download_limit_message': return 'The selected area exceeds the maximum allowed: 12,000 tiles or 155.55 MB. Please select a smaller area.';
			case 'go_select_map_area_screen.ok': return 'OK';
			case 'go_select_map_area_screen.download_map': return 'Download Map';
			case 'go_select_map_area_screen.download_map_question': return 'Download map of this area? Estimated tiles: {tiles}, approximately {size} MB.';
			case 'go_select_map_area_screen.close': return 'Close';
			case 'go_select_map_area_screen.name_your_map': return 'Name Your Map';
			case 'go_select_map_area_screen.enter_map_name': return 'Enter map name';
			case 'go_select_map_area_screen.cancel': return 'Cancel';
			case 'go_select_map_area_screen.download': return 'Download';
			case 'go_select_map_routes_screen.title': return 'Select Map Route';
			case 'go_select_map_routes_screen.select': return 'Select';
			case 'go_select_map_routes_screen.edit': return 'Edit';
			case 'go_select_map_routes_screen.view': return 'View';
			case 'go_select_map_routes_screen.area': return 'Area';
			case 'go_select_map_routes_screen.street': return 'Street';
			case 'go_select_map_routes_screen.tag': return 'Tag';
			case 'go_select_map_routes_screen.add_at_least_3_points': return 'Add at least 3 points to create an area.';
			case 'go_select_map_routes_screen.add_at_least_2_points': return 'Add at least 2 points to create a street.';
			case 'go_select_map_routes_screen.add_a_tag': return 'Add a tag to save.';
			case 'go_select_map_routes_screen.enter_name': return 'Enter name';
			case 'go_select_map_routes_screen.name': return 'Name';
			case 'go_select_map_routes_screen.name_cannot_be_empty': return 'Name cannot be empty.';
			case 'go_select_map_routes_screen.save': return 'Save';
			case 'go_select_map_routes_screen.cancel': return 'Cancel';
			case 'go_select_map_routes_screen.tag_text': return 'Tag Text';
			case 'go_select_map_routes_screen.enter_tag_text': return 'Enter tag text';
			case 'go_select_map_routes_screen.error_loading_item': return 'Error loading item: {error}';
			case 'go_select_map_routes_screen.error_adding_point': return 'Error adding point: {error}';
			case 'go_select_map_routes_screen.error_saving_item': return 'Error saving item: {error}';
			case 'go_select_map_routes_screen.zoom_in': return 'Zoom In';
			case 'go_select_map_routes_screen.zoom_out': return 'Zoom Out';
			case 'go_settings_screen.title': return 'Settings';
			case 'go_settings_screen.text_settings': return 'Text Settings';
			case 'go_settings_screen.font_family': return 'Font Family';
			case 'go_settings_screen.font_size': return 'Font Size:';
			case 'go_settings_screen.preview': return 'Preview:';
			case 'go_settings_screen.back': return 'Back';
			case 'go_settings_screen.load': return 'Load';
			case 'go_settings_screen.sample_text': return 'And he said unto them, Go ye into all the world, and preach the gospel to every creature.';
			case 'go_share_screen.title': return 'Share';
			case 'go_share_screen.churches': return 'Churches';
			case 'go_share_screen.contacts': return 'Contacts';
			case 'go_share_screen.ministries': return 'Ministries';
			case 'go_share_screen.areas': return 'Areas';
			case 'go_share_screen.streets': return 'Streets';
			case 'go_share_screen.zones': return 'Zones';
			case 'go_share_screen.all': return 'All';
			case 'go_share_screen.no_churches': return 'No churches available';
			case 'go_share_screen.no_contacts': return 'No contacts available';
			case 'go_share_screen.no_ministries': return 'No ministries available';
			case 'go_share_screen.no_areas': return 'No areas available';
			case 'go_share_screen.no_streets': return 'No streets available';
			case 'go_share_screen.no_zones': return 'No zones available';
			case 'go_share_screen.share_all_data': return 'Share All Data';
			case 'go_share_screen.all_by_faith_data': return 'All By Faith Data';
			case 'go_share_screen.could_not_launch_email': return 'Could not launch email client';
			case 'go_tab_screen.markers_in_zone': return 'Markers in Zone';
			case 'go_tab_screen.close': return 'Close';
			case 'go_tab_screen.add_area': return 'Add Area';
			case 'go_tab_screen.add_street': return 'Add Street';
			case 'go_tab_screen.add_zone': return 'Add Zone';
			case 'go_tab_screen.add_contact': return 'Add Contact';
			case 'go_tab_screen.add_church': return 'Add Church';
			case 'go_tab_screen.add_ministry': return 'Add Ministry';
			case 'go_tab_screen.offline_maps': return 'Offline Maps';
			case 'go_tab_screen.route_planner': return 'Route Planner';
			case 'go_tab_screen.churches': return 'Churches';
			case 'go_tab_screen.contacts': return 'Contacts';
			case 'go_tab_screen.ministries': return 'Ministries';
			case 'go_tab_screen.menu': return 'Go Menu';
			case 'go_tab_screen.search_address': return 'Search Address';
			case 'go_tab_screen.save_route': return 'Save Route';
			case 'go_tab_screen.hide_options': return 'Hide Options';
			case 'go_tab_screen.open_menu': return 'Open Menu';
			case 'go_tab_screen.tap_to_add_marker': return 'Tap on the map to add a marker.';
			case 'go_tab_screen.route_creation_cancelled': return 'Route creation cancelled.';
			case 'go_tab_screen.add_at_least_3_points': return 'Add at least 3 points to create an area.';
			case 'go_tab_screen.add_at_least_2_points': return 'Add at least 2 points to create a street.';
			case 'go_tab_screen.enter_name': return 'Enter name';
			case 'go_tab_screen.name': return 'Name';
			case 'go_tab_screen.cancel': return 'Cancel';
			case 'go_tab_screen.save': return 'Save';
			case 'go_tab_screen.search': return 'Search';
			case 'go_tab_screen.address_not_found': return 'Address not found.';
			case 'go_tab_screen.error_searching_address': return 'Error searching address: {error}';
			case 'go_tab_screen.downloading': return 'Downloading {mapName}';
			case 'go_tab_screen.starting_download': return 'Starting download...';
			case 'go_tab_screen.downloaded_tiles': return 'Downloaded {attempted} of {max} tiles ({percent}%)';
			case 'go_tab_screen.failed_to_download_map': return 'Failed to download map ({mapName}): {error}';
			case 'go_tab_screen.tap_to_place_the_zone': return 'Tap to place the zone.';
			case 'go_tab_screen.select_area_or_street_from_the_route_planner': return 'Select area or street from the route planner.';
			case 'go_tab_screen.areas': return 'Areas';
			case 'go_tab_screen.streets': return 'Streets';
			case 'go_tab_screen.zones': return 'Zones';
			case 'go_tab_screen.enter_address': return 'Enter address';
			case 'go_tab_screen.world': return 'World';
			case 'go_tab_screen.go_menu': return 'Go Menu';
			case 'study_plans_screen.title': return 'Study Plans';
			case 'study_plans_screen.content': return 'Study Plans Content';
			case 'study_settings_screen.title': return 'Settings';
			case 'study_settings_screen.text_settings': return 'Text Settings';
			case 'study_settings_screen.font_family': return 'Font Family';
			case 'study_settings_screen.font_size': return 'Font Size:';
			case 'study_settings_screen.preview': return 'Preview:';
			case 'study_settings_screen.back': return 'Back';
			case 'study_settings_screen.load': return 'Load';
			case 'study_settings_screen.sample_text': return 'Study to shew thyself approved unto God, a workman that needeth not to be ashamed, rightly dividing the word of truth.';
			case 'study_tab_screen.title': return 'Study';
			case 'study_tab_screen.study_menu': return 'Study Menu';
			case 'study_tab_screen.bibles': return 'Bibles';
			case 'study_tab_screen.no_bibles_installed': return 'No Bibles installed yet.';
			case 'study_tab_screen.select_bible_version': return 'Select Bible Version';
			case 'study_tab_screen.select_book': return 'Select Book';
			case 'study_tab_screen.select_chapter': return 'Select Chapter';
			default: return null;
		}
	}
}

