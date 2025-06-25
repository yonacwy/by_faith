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
class TranslationsEs implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsHomeTabScreenEs home_tab_screen = _TranslationsHomeTabScreenEs._(_root);
	@override late final _TranslationsHomeSettingsScreenEs home_settings_screen = _TranslationsHomeSettingsScreenEs._(_root);
	@override late final _TranslationsGoAddEditAreaScreenEs go_add_edit_area_screen = _TranslationsGoAddEditAreaScreenEs._(_root);
	@override late final _TranslationsGoAddEditChurchScreenEs go_add_edit_church_screen = _TranslationsGoAddEditChurchScreenEs._(_root);
	@override late final _TranslationsGoSettingsScreenEs go_settings_screen = _TranslationsGoSettingsScreenEs._(_root);
	@override late final _TranslationsGoAddEditContactScreenEs go_add_edit_contact_screen = _TranslationsGoAddEditContactScreenEs._(_root);
	@override late final _TranslationsGoAddEditMinistryScreenEs go_add_edit_ministry_screen = _TranslationsGoAddEditMinistryScreenEs._(_root);
	@override late final _TranslationsGoAddEditStreetScreenEs go_add_edit_street_screen = _TranslationsGoAddEditStreetScreenEs._(_root);
	@override late final _TranslationsGoAddEditZoneScreenEs go_add_edit_zone_screen = _TranslationsGoAddEditZoneScreenEs._(_root);
	@override late final _TranslationsGoChurchesScreenEs go_churches_screen = _TranslationsGoChurchesScreenEs._(_root);
	@override late final _TranslationsGoContactsScreenEs go_contacts_screen = _TranslationsGoContactsScreenEs._(_root);
	@override late final _TranslationsGoExportImportScreenEs go_export_import_screen = _TranslationsGoExportImportScreenEs._(_root);
	@override late final _TranslationsGoMinistriesScreenEs go_ministries_screen = _TranslationsGoMinistriesScreenEs._(_root);
	@override late final _TranslationsGoOfflineMapsScreenEs go_offline_maps_screen = _TranslationsGoOfflineMapsScreenEs._(_root);
	@override late final _TranslationsGoRoutePlannerScreenEs go_route_planner_screen = _TranslationsGoRoutePlannerScreenEs._(_root);
	@override late final _TranslationsGoSearchScreenEs go_search_screen = _TranslationsGoSearchScreenEs._(_root);
	@override late final _TranslationsGoSelectMapAreaScreenEs go_select_map_area_screen = _TranslationsGoSelectMapAreaScreenEs._(_root);
	@override late final _TranslationsGoSelectMapRoutesScreenEs go_select_map_routes_screen = _TranslationsGoSelectMapRoutesScreenEs._(_root);
	@override late final _TranslationsGoShareScreenEs go_share_screen = _TranslationsGoShareScreenEs._(_root);
	@override late final _TranslationsGoTabScreenEs go_tab_screen = _TranslationsGoTabScreenEs._(_root);
}

// Path: home_tab_screen
class _TranslationsHomeTabScreenEs implements TranslationsHomeTabScreenEn {
	_TranslationsHomeTabScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio';
	@override String get menu => 'Menú de Inicio';
	@override String get info => 'Información';
	@override String get support => 'Soporte';
	@override String get profile => 'Perfil';
	@override String get calendar => 'Calendario';
	@override String get settings => 'Ajustes';
	@override String get content => 'Contenido de la Pestaña de Inicio';
}

// Path: home_settings_screen
class _TranslationsHomeSettingsScreenEs implements TranslationsHomeSettingsScreenEn {
	_TranslationsHomeSettingsScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes';
	@override String get language => 'Idioma';
	@override String get english => 'Inglés';
	@override String get spanish => 'Español';
	@override String get hindi => 'Hindi';
	@override String get text_settings => 'Ajustes de Texto';
	@override String get font_family => 'Familia de Fuente';
	@override String get font_size => 'Tamaño de Fuente:';
	@override String get preview => 'Vista Previa:';
	@override String get global_settings => 'Ajustes Globales';
	@override String get language_settings => 'Ajustes de Idioma';
	@override String get app_language => 'Idioma de la Aplicación';
	@override String get back => 'Atrás';
	@override String get load => 'Cargar';
}

// Path: go_add_edit_area_screen
class _TranslationsGoAddEditAreaScreenEs implements TranslationsGoAddEditAreaScreenEn {
	_TranslationsGoAddEditAreaScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tap_to_add_points => 'Toca el mapa para añadir puntos para el Área.';
	@override String get cancel => 'Cancelar';
	@override String get cancel_area_creation => 'Cancelar Creación de Área';
	@override String get discard_changes_to_area => '¿Descartar cambios en esta área?';
	@override String get keep_editing => 'Seguir Editando';
	@override String get discard => 'Descartar';
	@override String get add_at_least_3_points => 'Añade al menos 3 puntos para crear un área.';
	@override String get edit_area => 'Editar Área';
	@override String get save_area => 'Guardar Área';
	@override String get hide_options => 'Ocultar Opciones';
	@override String get enter_name => 'Introduce un nombre';
	@override String get name => 'Nombre';
	@override String get name_cannot_be_empty => 'El nombre no puede estar vacío.';
	@override String get area_saved_successfully => 'Área guardada exitosamente.';
	@override String get error_saving_area => 'Error al guardar el Área: ';
	@override String get add_area_title => 'Añadir Área';
	@override String get edit_area_title => 'Editar Área';
	@override String get view_area_title => 'Ver Área';
	@override String get contacts => 'Contactos';
	@override String get churches => 'Iglesias';
	@override String get ministries => 'Ministerios';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
}

// Path: go_add_edit_church_screen
class _TranslationsGoAddEditChurchScreenEs implements TranslationsGoAddEditChurchScreenEn {
	_TranslationsGoAddEditChurchScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get delete_church => 'Eliminar Iglesia';
	@override String get delete_church_confirmation => '¿Estás seguro de que quieres eliminar {churchName}? Esto eliminará todas las notas asociadas.';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get church_deleted => 'Iglesia {churchName} eliminada';
	@override String get church_details => 'Detalles de la Iglesia';
	@override String get add_church => 'Añadir Iglesia';
	@override String get add_note => 'Añadir Nota';
	@override String get edit_details => 'Editar Detalles';
	@override String get church_information => 'Información de la Iglesia';
	@override String get church_name => 'Nombre de la Iglesia';
	@override String get pastor_name => 'Nombre del Pastor';
	@override String get address => 'Dirección';
	@override String get phone => 'Teléfono';
	@override String get email => 'Correo Electrónico';
	@override String get not_specified => 'No especificado';
	@override String get financial_status => 'Estado Financiero';
	@override String get status => 'Estado';
	@override String get map_information => 'Información del Mapa';
	@override String get latitude => 'Latitud';
	@override String get longitude => 'Longitud';
	@override String get notes => 'Notas';
	@override String get created => 'Creado';
	@override String get pastor_name_optional => 'Nombre del Pastor (Opcional)';
	@override String get please_enter_church_name => 'Por favor, introduce un nombre de iglesia';
	@override String get please_enter_address => 'Por favor, introduce una dirección';
	@override String get phone_optional => 'Teléfono (Opcional)';
	@override String get email_optional => 'Correo Electrónico (Opcional)';
	@override String get please_enter_valid_email => 'Por favor, introduce un correo electrónico válido';
	@override String get supporting => 'Apoyando';
	@override String get not_supporting => 'No Apoyando';
	@override String get undecided => 'Indeciso';
	@override String get church_added => '¡Iglesia añadida!';
	@override String get please_enter_latitude => 'Por favor, introduce una latitud';
	@override String get please_enter_longitude => 'Por favor, introduce una longitud';
	@override String get please_enter_valid_number => 'Por favor, introduce un número válido';
}

// Path: go_settings_screen
class _TranslationsGoSettingsScreenEs implements TranslationsGoSettingsScreenEn {
	_TranslationsGoSettingsScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes';
	@override String get text_settings => 'Ajustes de Texto';
	@override String get font_family => 'Familia de Fuente';
	@override String get font_size => 'Tamaño de Fuente:';
	@override String get preview => 'Vista Previa:';
	@override String get back => 'Atrás';
	@override String get load => 'Cargar';
	@override String get sample_text => 'Y les dijo: Id por todo el mundo y predicad el evangelio a toda criatura.';
}

// Path: go_add_edit_contact_screen
class _TranslationsGoAddEditContactScreenEs implements TranslationsGoAddEditContactScreenEn {
	_TranslationsGoAddEditContactScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get delete_contact => 'Eliminar Contacto';
	@override String get delete_contact_confirmation => '¿Estás seguro de que quieres eliminar a {fullName}? Esto eliminará todas las notas asociadas.';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get contact_deleted => 'Contacto {fullName} eliminado';
	@override String get contact_details => 'Detalles del Contacto';
	@override String get add_contact => 'Añadir Contacto';
	@override String get add_note => 'Añadir Nota';
	@override String get edit_details => 'Editar Detalles';
	@override String get personal_information => 'Información Personal';
	@override String get full_name => 'Nombre Completo';
	@override String get address => 'Dirección';
	@override String get birthday => 'Cumpleaños';
	@override String get phone => 'Teléfono';
	@override String get email => 'Correo Electrónico';
	@override String get not_specified => 'No especificado';
	@override String get eternal_status => 'Estado Eterno';
	@override String get status => 'Estado';
	@override String get map_information => 'Información del Mapa';
	@override String get latitude => 'Latitud';
	@override String get longitude => 'Longitud';
	@override String get notes => 'Notas';
	@override String get created => 'Creado';
	@override String get please_enter_full_name => 'Por favor, introduce un nombre completo';
	@override String get please_enter_address => 'Por favor, introduce una dirección';
	@override String get birthday_optional => 'Cumpleaños (Opcional)';
	@override String get phone_optional => 'Teléfono (Opcional)';
	@override String get email_optional => 'Correo Electrónico (Opcional)';
	@override String get please_enter_valid_email => 'Por favor, introduce un correo electrónico válido';
	@override String get saved => 'Salvado';
	@override String get lost => 'Perdido';
	@override String get seed_planted => 'Semilla Plantada';
	@override String get contact_added => '¡Contacto añadido!';
	@override String get save_contact => 'Guardar Contacto';
	@override String get edit_note => 'Editar Nota';
	@override String get contact_updated => '¡Contacto actualizado!';
	@override String get edit_contact_details => 'Editar Detalles del Contacto';
}

// Path: go_add_edit_ministry_screen
class _TranslationsGoAddEditMinistryScreenEs implements TranslationsGoAddEditMinistryScreenEn {
	_TranslationsGoAddEditMinistryScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get delete_ministry => 'Eliminar Ministerio';
	@override String get delete_ministry_confirmation => '¿Estás seguro de que quieres eliminar {ministryName}? Esto eliminará todas las notas asociadas.';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get ministry_deleted => 'Ministerio {ministryName} eliminado';
	@override String get ministry_details => 'Detalles del Ministerio';
	@override String get add_ministry => 'Añadir Ministerio';
	@override String get add_note => 'Añadir Nota';
	@override String get edit_details => 'Editar Detalles';
	@override String get ministry_information => 'Información del Ministerio';
	@override String get ministry_name => 'Nombre del Ministerio';
	@override String get contact_name => 'Nombre de Contacto';
	@override String get address => 'Dirección';
	@override String get phone => 'Teléfono';
	@override String get email => 'Correo Electrónico';
	@override String get not_specified => 'No especificado';
	@override String get partner_status => 'Estado de Colaboración';
	@override String get status => 'Estado';
	@override String get map_information => 'Información del Mapa';
	@override String get latitude => 'Latitud';
	@override String get longitude => 'Longitud';
	@override String get notes => 'Notas';
	@override String get created => 'Creado';
	@override String get please_enter_ministry_name => 'Por favor, introduce un nombre de ministerio';
	@override String get please_enter_address => 'Por favor, introduce una dirección';
	@override String get phone_optional => 'Teléfono (Opcional)';
	@override String get email_optional => 'Correo Electrónico (Opcional)';
	@override String get please_enter_valid_email => 'Por favor, introduce un correo electrónico válido';
	@override String get confirmed => 'Confirmado';
	@override String get not_confirmed => 'No Confirmado';
	@override String get undecided => 'Indeciso';
	@override String get ministry_added => '¡Ministerio añadido!';
	@override String get please_enter_latitude => 'Por favor, introduce una latitud';
	@override String get please_enter_longitude => 'Por favor, introduce una longitud';
	@override String get please_enter_valid_number => 'Por favor, introduce un número válido';
}

// Path: go_add_edit_street_screen
class _TranslationsGoAddEditStreetScreenEs implements TranslationsGoAddEditStreetScreenEn {
	_TranslationsGoAddEditStreetScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tap_to_add_points => 'Toca el mapa para añadir puntos.';
	@override String get cancel => 'Cancelar';
	@override String get cancel_creation => 'Cancelar Creación';
	@override String get discard_changes => '¿Descartar los cambios en esta ruta?';
	@override String get keep_editing => 'Seguir Editando';
	@override String get discard => 'Descartar';
	@override String get add_at_least_2_points => 'Añade al menos 2 puntos para crear una ruta.';
	@override String get enter_name => 'Introduce un nombre';
	@override String get name => 'Nombre';
	@override String get name_cannot_be_empty => 'El nombre no puede estar vacío.';
	@override String get save => 'Guardar';
	@override String get edit => 'Editar';
	@override String get route_saved_successfully => 'Ruta guardada exitosamente.';
	@override String get error_saving_route => 'Error al guardar la ruta: {error}';
	@override String get contacts => 'Contactos';
	@override String get churches => 'Iglesias';
	@override String get ministries => 'Ministerios';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get view => 'Ver';
	@override String get add => 'Añadir';
	@override String get hide_options => 'Ocultar Opciones';
	@override String get zoom_in => 'Acercar';
	@override String get zoom_out => 'Alejar';
	@override String get add_point => 'Añadir Punto';
	@override String get remove_point => 'Eliminar Punto';
	@override String get street => 'Calle';
	@override String get river => 'Río';
	@override String get path => 'Sendero';
}

// Path: go_add_edit_zone_screen
class _TranslationsGoAddEditZoneScreenEs implements TranslationsGoAddEditZoneScreenEn {
	_TranslationsGoAddEditZoneScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tap_to_set_center => 'Toca el mapa para establecer el centro de la zona.';
	@override String get cancel => 'Cancelar';
	@override String get cancel_zone_creation => 'Cancelar Creación de Zona';
	@override String get discard_changes => '¿Descartar los cambios en esta zona?';
	@override String get keep_editing => 'Seguir Editando';
	@override String get discard => 'Descartar';
	@override String get enter_name => 'Introduce un nombre';
	@override String get name => 'Nombre';
	@override String get name_cannot_be_empty => 'El nombre no puede estar vacío.';
	@override String get save => 'Guardar';
	@override String get edit => 'Editar';
	@override String get zone_saved_successfully => 'Zona guardada exitosamente.';
	@override String get error_saving_zone => 'Error al guardar la zona: {error}';
	@override String get contacts => 'Contactos';
	@override String get churches => 'Iglesias';
	@override String get ministries => 'Ministerios';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get view => 'Ver';
	@override String get add => 'Añadir';
	@override String get hide_options => 'Ocultar Opciones';
	@override String get zoom_in => 'Acercar';
	@override String get zoom_out => 'Alejar';
	@override String get increase_radius => 'Aumentar Radio';
	@override String get decrease_radius => 'Disminuir Radio';
	@override String get set_center => 'Establecer Centro';
}

// Path: go_churches_screen
class _TranslationsGoChurchesScreenEs implements TranslationsGoChurchesScreenEn {
	_TranslationsGoChurchesScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iglesias';
	@override String get add_church => 'Añadir Iglesia';
	@override String get delete_church => 'Eliminar Iglesia';
	@override String get delete_church_confirmation => '¿Estás seguro de que quieres eliminar {churchName}?';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get church_deleted => 'Iglesia {churchName} eliminada';
	@override String get no_churches => 'No hay iglesias añadidas todavía.';
	@override String get pastor => 'Pastor: {pastorName}';
	@override String get phone => 'Teléfono: {phone}';
	@override String get email => 'Correo electrónico: {email}';
	@override String get address => 'Dirección: {address}';
	@override String get financial_status => 'Estado financiero: {status}';
	@override String get notes => 'Notas:';
	@override String get created => 'Creado: {date}';
	@override String get edit => 'Editar';
}

// Path: go_contacts_screen
class _TranslationsGoContactsScreenEs implements TranslationsGoContactsScreenEn {
	_TranslationsGoContactsScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Contactos';
	@override String get add_contact => 'Añadir Contacto';
	@override String get delete_contact => 'Eliminar Contacto';
	@override String get delete_contact_confirmation => '¿Estás seguro de que quieres eliminar a {fullName}?';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get contact_deleted => 'Contacto {fullName} eliminado';
	@override String get no_contacts => 'No hay contactos añadidos todavía.';
	@override String get full_name => 'Nombre Completo';
	@override String get phone => 'Teléfono: {phone}';
	@override String get email => 'Correo electrónico: {email}';
	@override String get address => 'Dirección: {address}';
	@override String get eternal_status => 'Estado Eterno: {status}';
	@override String get birthday => 'Cumpleaños: {birthday}';
	@override String get notes => 'Notas:';
	@override String get created => 'Creado: {date}';
	@override String get edit => 'Editar';
}

// Path: go_export_import_screen
class _TranslationsGoExportImportScreenEs implements TranslationsGoExportImportScreenEn {
	_TranslationsGoExportImportScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exportar/Importar';
	@override String get export_data => 'Exportar Datos';
	@override String get import_data => 'Importar Datos';
	@override String get churches => 'Iglesias';
	@override String get contacts => 'Contactos';
	@override String get ministries => 'Ministerios';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get all => 'Todo';
	@override String get no_churches => 'No hay iglesias disponibles';
	@override String get no_contacts => 'No hay contactos disponibles';
	@override String get no_ministries => 'No hay ministerios disponibles';
	@override String get no_areas => 'No hay áreas disponibles';
	@override String get no_streets => 'No hay calles disponibles';
	@override String get no_zones => 'No hay zonas disponibles';
	@override String get save_json => 'Guardar JSON de {type}';
	@override String get select_json => 'Seleccionar JSON de {type}';
	@override String get export_success => '{type} exportado exitosamente';
	@override String get import_success => '{type} importado exitosamente';
	@override String get error_export => 'Error al exportar {type}: {error}';
	@override String get error_import => 'Error al importar {type}: {error}';
	@override String get invalid_file => 'Archivo inválido: Se esperaba datos de {type}';
	@override String get all_export_success => 'Todos los datos exportados exitosamente';
	@override String get all_import_success => 'Todos los datos importados exitosamente';
	@override String get error_export_all => 'Error al exportar todos los datos: {error}';
	@override String get error_import_all => 'Error al importar todos los datos: {error}';
}

// Path: go_ministries_screen
class _TranslationsGoMinistriesScreenEs implements TranslationsGoMinistriesScreenEn {
	_TranslationsGoMinistriesScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ministerios';
	@override String get add_ministry => 'Añadir Ministerio';
	@override String get delete_ministry => 'Eliminar Ministerio';
	@override String get delete_ministry_confirmation => '¿Estás seguro de que quieres eliminar {ministryName}?';
	@override String get cancel => 'Cancelar';
	@override String get delete => 'Eliminar';
	@override String get ministry_deleted => 'Ministerio {ministryName} eliminado';
	@override String get no_ministries => 'No hay ministerios añadidos todavía.';
	@override String get contact => 'Contacto: {contactName}';
	@override String get phone => 'Teléfono: {phone}';
	@override String get email => 'Correo electrónico: {email}';
	@override String get address => 'Dirección: {address}';
	@override String get partner_status => 'Estado de Colaboración: {status}';
	@override String get notes => 'Notas:';
	@override String get created => 'Creado: {date}';
	@override String get edit => 'Editar';
}

// Path: go_offline_maps_screen
class _TranslationsGoOfflineMapsScreenEs implements TranslationsGoOfflineMapsScreenEn {
	_TranslationsGoOfflineMapsScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mapas sin conexión';
	@override String get select_your_own_map => 'Selecciona tu propio mapa';
	@override String get downloaded_maps => 'Mapas Descargados';
	@override String get no_maps_downloaded => 'No hay mapas descargados todavía.';
	@override String get max_maps_warning => 'Solo puedes tener hasta 5 mapas (incluyendo el mapa mundial por defecto). Por favor elimina un mapa antes de descargar uno nuevo.';
	@override String get failed_to_delete_map => 'No se pudo eliminar el mapa ({mapName}): {error}';
	@override String get rename_map => 'Renombrar Mapa';
	@override String get enter_new_map_name => 'Introduce un nuevo nombre para el mapa';
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
	@override String get failed_to_rename_map => 'No se pudo renombrar el mapa: {error}';
	@override String get view => 'Ver';
	@override String get update => 'Actualizar';
	@override String get rename => 'Renombrar';
	@override String get delete => 'Eliminar';
	@override String get map_updated_successfully => 'Mapa "{mapName}" actualizado exitosamente';
	@override String get failed_to_update_map => 'No se pudo actualizar el mapa: {error}';
}

// Path: go_route_planner_screen
class _TranslationsGoRoutePlannerScreenEs implements TranslationsGoRoutePlannerScreenEn {
	_TranslationsGoRoutePlannerScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Planificador de Rutas';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get no_areas => 'No hay áreas añadidas todavía.';
	@override String get no_streets => 'No hay calles añadidas todavía.';
	@override String get no_zones => 'No hay zonas añadidas todavía.';
	@override String get edit => 'Editar';
	@override String get rename => 'Renombrar';
	@override String get delete => 'Eliminar';
	@override String get view => 'Ver';
	@override String get add => 'Añadir';
	@override String get lat => 'Lat: {lat}';
	@override String get lon => 'Lon: {lon}';
	@override String get no_coordinates => 'Sin coordenadas';
	@override String get failed_to_delete => 'No se pudo eliminar {type}: {error}';
	@override String get failed_to_rename => 'No se pudo renombrar {type}: {error}';
	@override String get rename_type => 'Renombrar {type}';
	@override String get enter_new_name => 'Introduce un nuevo nombre';
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
}

// Path: go_search_screen
class _TranslationsGoSearchScreenEs implements TranslationsGoSearchScreenEn {
	_TranslationsGoSearchScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Buscar Dirección';
	@override String get enter_address => 'Introduce una dirección';
	@override String get please_enter_address => 'Por favor, introduce una dirección.';
	@override String get address_not_found => 'Dirección no encontrada.';
	@override String get found => 'Encontrado: {displayName}';
	@override String get latitude => 'Latitud: {lat}';
	@override String get longitude => 'Longitud: {lon}';
	@override String get error_searching_address => 'Error al buscar la dirección: {error}';
	@override String get search => 'Buscar';
}

// Path: go_select_map_area_screen
class _TranslationsGoSelectMapAreaScreenEs implements TranslationsGoSelectMapAreaScreenEn {
	_TranslationsGoSelectMapAreaScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar Área del Mapa';
	@override String get download_limit_exceeded => 'Límite de Descarga Excedido';
	@override String get download_limit_message => 'El área seleccionada excede el máximo permitido: 12,000 teselas o 155.55 MB. Por favor selecciona un área más pequeña.';
	@override String get ok => 'OK';
	@override String get download_map => 'Descargar Mapa';
	@override String get download_map_question => '¿Descargar el mapa de esta área? Teselas estimadas: {tiles}, aproximadamente {size} MB.';
	@override String get close => 'Cerrar';
	@override String get name_your_map => 'Nombra tu Mapa';
	@override String get enter_map_name => 'Introduce el nombre del mapa';
	@override String get cancel => 'Cancelar';
	@override String get download => 'Descargar';
}

// Path: go_select_map_routes_screen
class _TranslationsGoSelectMapRoutesScreenEs implements TranslationsGoSelectMapRoutesScreenEn {
	_TranslationsGoSelectMapRoutesScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seleccionar Ruta del Mapa';
	@override String get select => 'Seleccionar';
	@override String get edit => 'Editar';
	@override String get view => 'Ver';
	@override String get area => 'Área';
	@override String get street => 'Calle';
	@override String get tag => 'Etiqueta';
	@override String get add_at_least_3_points => 'Añade al menos 3 puntos para crear un área.';
	@override String get add_at_least_2_points => 'Añade al menos 2 puntos para crear una calle.';
	@override String get add_a_tag => 'Añade una etiqueta para guardar.';
	@override String get enter_name => 'Introduce un nombre';
	@override String get name => 'Nombre';
	@override String get name_cannot_be_empty => 'El nombre no puede estar vacío.';
	@override String get save => 'Guardar';
	@override String get cancel => 'Cancelar';
	@override String get tag_text => 'Texto de la Etiqueta';
	@override String get enter_tag_text => 'Introduce el texto de la etiqueta';
	@override String get error_loading_item => 'Error al cargar el elemento: {error}';
	@override String get error_adding_point => 'Error al añadir el punto: {error}';
	@override String get error_saving_item => 'Error al guardar el elemento: {error}';
	@override String get zoom_in => 'Acercar';
	@override String get zoom_out => 'Alejar';
}

// Path: go_share_screen
class _TranslationsGoShareScreenEs implements TranslationsGoShareScreenEn {
	_TranslationsGoShareScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Compartir';
	@override String get churches => 'Iglesias';
	@override String get contacts => 'Contactos';
	@override String get ministries => 'Ministerios';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get all => 'Todo';
	@override String get no_churches => 'No hay iglesias disponibles';
	@override String get no_contacts => 'No hay contactos disponibles';
	@override String get no_ministries => 'No hay ministerios disponibles';
	@override String get no_areas => 'No hay áreas disponibles';
	@override String get no_streets => 'No hay calles disponibles';
	@override String get no_zones => 'No hay zonas disponibles';
	@override String get share_all_data => 'Compartir Todos los Datos';
	@override String get all_by_faith_data => 'Todos los Datos de By Faith';
	@override String get could_not_launch_email => 'No se pudo abrir el cliente de correo';
}

// Path: go_tab_screen
class _TranslationsGoTabScreenEs implements TranslationsGoTabScreenEn {
	_TranslationsGoTabScreenEs._(this._root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get markers_in_zone => 'Marcadores en la Zona';
	@override String get close => 'Cerrar';
	@override String get add_area => 'Añadir Área';
	@override String get add_street => 'Añadir Calle';
	@override String get add_zone => 'Añadir Zona';
	@override String get add_contact => 'Añadir Contacto';
	@override String get add_church => 'Añadir Iglesia';
	@override String get add_ministry => 'Añadir Ministerio';
	@override String get offline_maps => 'Mapas sin conexión';
	@override String get route_planner => 'Planificador de Rutas';
	@override String get churches => 'Iglesias';
	@override String get contacts => 'Contactos';
	@override String get ministries => 'Ministerios';
	@override String get menu => 'Menú Go';
	@override String get search_address => 'Buscar Dirección';
	@override String get save_route => 'Guardar Ruta';
	@override String get hide_options => 'Ocultar Opciones';
	@override String get open_menu => 'Abrir Menú';
	@override String get tap_to_add_marker => 'Toca el mapa para añadir un marcador.';
	@override String get route_creation_cancelled => 'Creación de ruta cancelada.';
	@override String get add_at_least_3_points => 'Añade al menos 3 puntos para crear un área.';
	@override String get add_at_least_2_points => 'Añade al menos 2 puntos para crear una calle.';
	@override String get enter_name => 'Introduce un nombre';
	@override String get name => 'Nombre';
	@override String get cancel => 'Cancelar';
	@override String get save => 'Guardar';
	@override String get search => 'Buscar';
	@override String get address_not_found => 'Dirección no encontrada.';
	@override String get error_searching_address => 'Error al buscar la dirección: {error}';
	@override String get downloading => 'Descargando {mapName}';
	@override String get starting_download => 'Iniciando descarga...';
	@override String get downloaded_tiles => 'Descargadas {attempted} de {max} teselas ({percent}%)';
	@override String get failed_to_download_map => 'No se pudo descargar el mapa ({mapName}): {error}';
	@override String get tap_to_place_the_zone => 'Toca para colocar la zona.';
	@override String get select_area_or_street_from_the_route_planner => 'Selecciona área o calle desde el planificador de rutas.';
	@override String get areas => 'Áreas';
	@override String get streets => 'Calles';
	@override String get zones => 'Zonas';
	@override String get enter_address => 'Introduce una dirección';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'home_tab_screen.title': return 'Inicio';
			case 'home_tab_screen.menu': return 'Menú de Inicio';
			case 'home_tab_screen.info': return 'Información';
			case 'home_tab_screen.support': return 'Soporte';
			case 'home_tab_screen.profile': return 'Perfil';
			case 'home_tab_screen.calendar': return 'Calendario';
			case 'home_tab_screen.settings': return 'Ajustes';
			case 'home_tab_screen.content': return 'Contenido de la Pestaña de Inicio';
			case 'home_settings_screen.title': return 'Ajustes';
			case 'home_settings_screen.language': return 'Idioma';
			case 'home_settings_screen.english': return 'Inglés';
			case 'home_settings_screen.spanish': return 'Español';
			case 'home_settings_screen.hindi': return 'Hindi';
			case 'home_settings_screen.text_settings': return 'Ajustes de Texto';
			case 'home_settings_screen.font_family': return 'Familia de Fuente';
			case 'home_settings_screen.font_size': return 'Tamaño de Fuente:';
			case 'home_settings_screen.preview': return 'Vista Previa:';
			case 'home_settings_screen.global_settings': return 'Ajustes Globales';
			case 'home_settings_screen.language_settings': return 'Ajustes de Idioma';
			case 'home_settings_screen.app_language': return 'Idioma de la Aplicación';
			case 'home_settings_screen.back': return 'Atrás';
			case 'home_settings_screen.load': return 'Cargar';
			case 'go_add_edit_area_screen.tap_to_add_points': return 'Toca el mapa para añadir puntos para el Área.';
			case 'go_add_edit_area_screen.cancel': return 'Cancelar';
			case 'go_add_edit_area_screen.cancel_area_creation': return 'Cancelar Creación de Área';
			case 'go_add_edit_area_screen.discard_changes_to_area': return '¿Descartar cambios en esta área?';
			case 'go_add_edit_area_screen.keep_editing': return 'Seguir Editando';
			case 'go_add_edit_area_screen.discard': return 'Descartar';
			case 'go_add_edit_area_screen.add_at_least_3_points': return 'Añade al menos 3 puntos para crear un área.';
			case 'go_add_edit_area_screen.edit_area': return 'Editar Área';
			case 'go_add_edit_area_screen.save_area': return 'Guardar Área';
			case 'go_add_edit_area_screen.hide_options': return 'Ocultar Opciones';
			case 'go_add_edit_area_screen.enter_name': return 'Introduce un nombre';
			case 'go_add_edit_area_screen.name': return 'Nombre';
			case 'go_add_edit_area_screen.name_cannot_be_empty': return 'El nombre no puede estar vacío.';
			case 'go_add_edit_area_screen.area_saved_successfully': return 'Área guardada exitosamente.';
			case 'go_add_edit_area_screen.error_saving_area': return 'Error al guardar el Área: ';
			case 'go_add_edit_area_screen.add_area_title': return 'Añadir Área';
			case 'go_add_edit_area_screen.edit_area_title': return 'Editar Área';
			case 'go_add_edit_area_screen.view_area_title': return 'Ver Área';
			case 'go_add_edit_area_screen.contacts': return 'Contactos';
			case 'go_add_edit_area_screen.churches': return 'Iglesias';
			case 'go_add_edit_area_screen.ministries': return 'Ministerios';
			case 'go_add_edit_area_screen.areas': return 'Áreas';
			case 'go_add_edit_area_screen.streets': return 'Calles';
			case 'go_add_edit_area_screen.zones': return 'Zonas';
			case 'go_add_edit_church_screen.delete_church': return 'Eliminar Iglesia';
			case 'go_add_edit_church_screen.delete_church_confirmation': return '¿Estás seguro de que quieres eliminar {churchName}? Esto eliminará todas las notas asociadas.';
			case 'go_add_edit_church_screen.cancel': return 'Cancelar';
			case 'go_add_edit_church_screen.delete': return 'Eliminar';
			case 'go_add_edit_church_screen.church_deleted': return 'Iglesia {churchName} eliminada';
			case 'go_add_edit_church_screen.church_details': return 'Detalles de la Iglesia';
			case 'go_add_edit_church_screen.add_church': return 'Añadir Iglesia';
			case 'go_add_edit_church_screen.add_note': return 'Añadir Nota';
			case 'go_add_edit_church_screen.edit_details': return 'Editar Detalles';
			case 'go_add_edit_church_screen.church_information': return 'Información de la Iglesia';
			case 'go_add_edit_church_screen.church_name': return 'Nombre de la Iglesia';
			case 'go_add_edit_church_screen.pastor_name': return 'Nombre del Pastor';
			case 'go_add_edit_church_screen.address': return 'Dirección';
			case 'go_add_edit_church_screen.phone': return 'Teléfono';
			case 'go_add_edit_church_screen.email': return 'Correo Electrónico';
			case 'go_add_edit_church_screen.not_specified': return 'No especificado';
			case 'go_add_edit_church_screen.financial_status': return 'Estado Financiero';
			case 'go_add_edit_church_screen.status': return 'Estado';
			case 'go_add_edit_church_screen.map_information': return 'Información del Mapa';
			case 'go_add_edit_church_screen.latitude': return 'Latitud';
			case 'go_add_edit_church_screen.longitude': return 'Longitud';
			case 'go_add_edit_church_screen.notes': return 'Notas';
			case 'go_add_edit_church_screen.created': return 'Creado';
			case 'go_add_edit_church_screen.pastor_name_optional': return 'Nombre del Pastor (Opcional)';
			case 'go_add_edit_church_screen.please_enter_church_name': return 'Por favor, introduce un nombre de iglesia';
			case 'go_add_edit_church_screen.please_enter_address': return 'Por favor, introduce una dirección';
			case 'go_add_edit_church_screen.phone_optional': return 'Teléfono (Opcional)';
			case 'go_add_edit_church_screen.email_optional': return 'Correo Electrónico (Opcional)';
			case 'go_add_edit_church_screen.please_enter_valid_email': return 'Por favor, introduce un correo electrónico válido';
			case 'go_add_edit_church_screen.supporting': return 'Apoyando';
			case 'go_add_edit_church_screen.not_supporting': return 'No Apoyando';
			case 'go_add_edit_church_screen.undecided': return 'Indeciso';
			case 'go_add_edit_church_screen.church_added': return '¡Iglesia añadida!';
			case 'go_add_edit_church_screen.please_enter_latitude': return 'Por favor, introduce una latitud';
			case 'go_add_edit_church_screen.please_enter_longitude': return 'Por favor, introduce una longitud';
			case 'go_add_edit_church_screen.please_enter_valid_number': return 'Por favor, introduce un número válido';
			case 'go_settings_screen.title': return 'Ajustes';
			case 'go_settings_screen.text_settings': return 'Ajustes de Texto';
			case 'go_settings_screen.font_family': return 'Familia de Fuente';
			case 'go_settings_screen.font_size': return 'Tamaño de Fuente:';
			case 'go_settings_screen.preview': return 'Vista Previa:';
			case 'go_settings_screen.back': return 'Atrás';
			case 'go_settings_screen.load': return 'Cargar';
			case 'go_settings_screen.sample_text': return 'Y les dijo: Id por todo el mundo y predicad el evangelio a toda criatura.';
			case 'go_add_edit_contact_screen.delete_contact': return 'Eliminar Contacto';
			case 'go_add_edit_contact_screen.delete_contact_confirmation': return '¿Estás seguro de que quieres eliminar a {fullName}? Esto eliminará todas las notas asociadas.';
			case 'go_add_edit_contact_screen.cancel': return 'Cancelar';
			case 'go_add_edit_contact_screen.delete': return 'Eliminar';
			case 'go_add_edit_contact_screen.contact_deleted': return 'Contacto {fullName} eliminado';
			case 'go_add_edit_contact_screen.contact_details': return 'Detalles del Contacto';
			case 'go_add_edit_contact_screen.add_contact': return 'Añadir Contacto';
			case 'go_add_edit_contact_screen.add_note': return 'Añadir Nota';
			case 'go_add_edit_contact_screen.edit_details': return 'Editar Detalles';
			case 'go_add_edit_contact_screen.personal_information': return 'Información Personal';
			case 'go_add_edit_contact_screen.full_name': return 'Nombre Completo';
			case 'go_add_edit_contact_screen.address': return 'Dirección';
			case 'go_add_edit_contact_screen.birthday': return 'Cumpleaños';
			case 'go_add_edit_contact_screen.phone': return 'Teléfono';
			case 'go_add_edit_contact_screen.email': return 'Correo Electrónico';
			case 'go_add_edit_contact_screen.not_specified': return 'No especificado';
			case 'go_add_edit_contact_screen.eternal_status': return 'Estado Eterno';
			case 'go_add_edit_contact_screen.status': return 'Estado';
			case 'go_add_edit_contact_screen.map_information': return 'Información del Mapa';
			case 'go_add_edit_contact_screen.latitude': return 'Latitud';
			case 'go_add_edit_contact_screen.longitude': return 'Longitud';
			case 'go_add_edit_contact_screen.notes': return 'Notas';
			case 'go_add_edit_contact_screen.created': return 'Creado';
			case 'go_add_edit_contact_screen.please_enter_full_name': return 'Por favor, introduce un nombre completo';
			case 'go_add_edit_contact_screen.please_enter_address': return 'Por favor, introduce una dirección';
			case 'go_add_edit_contact_screen.birthday_optional': return 'Cumpleaños (Opcional)';
			case 'go_add_edit_contact_screen.phone_optional': return 'Teléfono (Opcional)';
			case 'go_add_edit_contact_screen.email_optional': return 'Correo Electrónico (Opcional)';
			case 'go_add_edit_contact_screen.please_enter_valid_email': return 'Por favor, introduce un correo electrónico válido';
			case 'go_add_edit_contact_screen.saved': return 'Salvado';
			case 'go_add_edit_contact_screen.lost': return 'Perdido';
			case 'go_add_edit_contact_screen.seed_planted': return 'Semilla Plantada';
			case 'go_add_edit_contact_screen.contact_added': return '¡Contacto añadido!';
			case 'go_add_edit_contact_screen.save_contact': return 'Guardar Contacto';
			case 'go_add_edit_contact_screen.edit_note': return 'Editar Nota';
			case 'go_add_edit_contact_screen.contact_updated': return '¡Contacto actualizado!';
			case 'go_add_edit_contact_screen.edit_contact_details': return 'Editar Detalles del Contacto';
			case 'go_add_edit_ministry_screen.delete_ministry': return 'Eliminar Ministerio';
			case 'go_add_edit_ministry_screen.delete_ministry_confirmation': return '¿Estás seguro de que quieres eliminar {ministryName}? Esto eliminará todas las notas asociadas.';
			case 'go_add_edit_ministry_screen.cancel': return 'Cancelar';
			case 'go_add_edit_ministry_screen.delete': return 'Eliminar';
			case 'go_add_edit_ministry_screen.ministry_deleted': return 'Ministerio {ministryName} eliminado';
			case 'go_add_edit_ministry_screen.ministry_details': return 'Detalles del Ministerio';
			case 'go_add_edit_ministry_screen.add_ministry': return 'Añadir Ministerio';
			case 'go_add_edit_ministry_screen.add_note': return 'Añadir Nota';
			case 'go_add_edit_ministry_screen.edit_details': return 'Editar Detalles';
			case 'go_add_edit_ministry_screen.ministry_information': return 'Información del Ministerio';
			case 'go_add_edit_ministry_screen.ministry_name': return 'Nombre del Ministerio';
			case 'go_add_edit_ministry_screen.contact_name': return 'Nombre de Contacto';
			case 'go_add_edit_ministry_screen.address': return 'Dirección';
			case 'go_add_edit_ministry_screen.phone': return 'Teléfono';
			case 'go_add_edit_ministry_screen.email': return 'Correo Electrónico';
			case 'go_add_edit_ministry_screen.not_specified': return 'No especificado';
			case 'go_add_edit_ministry_screen.partner_status': return 'Estado de Colaboración';
			case 'go_add_edit_ministry_screen.status': return 'Estado';
			case 'go_add_edit_ministry_screen.map_information': return 'Información del Mapa';
			case 'go_add_edit_ministry_screen.latitude': return 'Latitud';
			case 'go_add_edit_ministry_screen.longitude': return 'Longitud';
			case 'go_add_edit_ministry_screen.notes': return 'Notas';
			case 'go_add_edit_ministry_screen.created': return 'Creado';
			case 'go_add_edit_ministry_screen.please_enter_ministry_name': return 'Por favor, introduce un nombre de ministerio';
			case 'go_add_edit_ministry_screen.please_enter_address': return 'Por favor, introduce una dirección';
			case 'go_add_edit_ministry_screen.phone_optional': return 'Teléfono (Opcional)';
			case 'go_add_edit_ministry_screen.email_optional': return 'Correo Electrónico (Opcional)';
			case 'go_add_edit_ministry_screen.please_enter_valid_email': return 'Por favor, introduce un correo electrónico válido';
			case 'go_add_edit_ministry_screen.confirmed': return 'Confirmado';
			case 'go_add_edit_ministry_screen.not_confirmed': return 'No Confirmado';
			case 'go_add_edit_ministry_screen.undecided': return 'Indeciso';
			case 'go_add_edit_ministry_screen.ministry_added': return '¡Ministerio añadido!';
			case 'go_add_edit_ministry_screen.please_enter_latitude': return 'Por favor, introduce una latitud';
			case 'go_add_edit_ministry_screen.please_enter_longitude': return 'Por favor, introduce una longitud';
			case 'go_add_edit_ministry_screen.please_enter_valid_number': return 'Por favor, introduce un número válido';
			case 'go_add_edit_street_screen.tap_to_add_points': return 'Toca el mapa para añadir puntos.';
			case 'go_add_edit_street_screen.cancel': return 'Cancelar';
			case 'go_add_edit_street_screen.cancel_creation': return 'Cancelar Creación';
			case 'go_add_edit_street_screen.discard_changes': return '¿Descartar los cambios en esta ruta?';
			case 'go_add_edit_street_screen.keep_editing': return 'Seguir Editando';
			case 'go_add_edit_street_screen.discard': return 'Descartar';
			case 'go_add_edit_street_screen.add_at_least_2_points': return 'Añade al menos 2 puntos para crear una ruta.';
			case 'go_add_edit_street_screen.enter_name': return 'Introduce un nombre';
			case 'go_add_edit_street_screen.name': return 'Nombre';
			case 'go_add_edit_street_screen.name_cannot_be_empty': return 'El nombre no puede estar vacío.';
			case 'go_add_edit_street_screen.save': return 'Guardar';
			case 'go_add_edit_street_screen.edit': return 'Editar';
			case 'go_add_edit_street_screen.route_saved_successfully': return 'Ruta guardada exitosamente.';
			case 'go_add_edit_street_screen.error_saving_route': return 'Error al guardar la ruta: {error}';
			case 'go_add_edit_street_screen.contacts': return 'Contactos';
			case 'go_add_edit_street_screen.churches': return 'Iglesias';
			case 'go_add_edit_street_screen.ministries': return 'Ministerios';
			case 'go_add_edit_street_screen.areas': return 'Áreas';
			case 'go_add_edit_street_screen.streets': return 'Calles';
			case 'go_add_edit_street_screen.zones': return 'Zonas';
			case 'go_add_edit_street_screen.view': return 'Ver';
			case 'go_add_edit_street_screen.add': return 'Añadir';
			case 'go_add_edit_street_screen.hide_options': return 'Ocultar Opciones';
			case 'go_add_edit_street_screen.zoom_in': return 'Acercar';
			case 'go_add_edit_street_screen.zoom_out': return 'Alejar';
			case 'go_add_edit_street_screen.add_point': return 'Añadir Punto';
			case 'go_add_edit_street_screen.remove_point': return 'Eliminar Punto';
			case 'go_add_edit_street_screen.street': return 'Calle';
			case 'go_add_edit_street_screen.river': return 'Río';
			case 'go_add_edit_street_screen.path': return 'Sendero';
			case 'go_add_edit_zone_screen.tap_to_set_center': return 'Toca el mapa para establecer el centro de la zona.';
			case 'go_add_edit_zone_screen.cancel': return 'Cancelar';
			case 'go_add_edit_zone_screen.cancel_zone_creation': return 'Cancelar Creación de Zona';
			case 'go_add_edit_zone_screen.discard_changes': return '¿Descartar los cambios en esta zona?';
			case 'go_add_edit_zone_screen.keep_editing': return 'Seguir Editando';
			case 'go_add_edit_zone_screen.discard': return 'Descartar';
			case 'go_add_edit_zone_screen.enter_name': return 'Introduce un nombre';
			case 'go_add_edit_zone_screen.name': return 'Nombre';
			case 'go_add_edit_zone_screen.name_cannot_be_empty': return 'El nombre no puede estar vacío.';
			case 'go_add_edit_zone_screen.save': return 'Guardar';
			case 'go_add_edit_zone_screen.edit': return 'Editar';
			case 'go_add_edit_zone_screen.zone_saved_successfully': return 'Zona guardada exitosamente.';
			case 'go_add_edit_zone_screen.error_saving_zone': return 'Error al guardar la zona: {error}';
			case 'go_add_edit_zone_screen.contacts': return 'Contactos';
			case 'go_add_edit_zone_screen.churches': return 'Iglesias';
			case 'go_add_edit_zone_screen.ministries': return 'Ministerios';
			case 'go_add_edit_zone_screen.areas': return 'Áreas';
			case 'go_add_edit_zone_screen.streets': return 'Calles';
			case 'go_add_edit_zone_screen.zones': return 'Zonas';
			case 'go_add_edit_zone_screen.view': return 'Ver';
			case 'go_add_edit_zone_screen.add': return 'Añadir';
			case 'go_add_edit_zone_screen.hide_options': return 'Ocultar Opciones';
			case 'go_add_edit_zone_screen.zoom_in': return 'Acercar';
			case 'go_add_edit_zone_screen.zoom_out': return 'Alejar';
			case 'go_add_edit_zone_screen.increase_radius': return 'Aumentar Radio';
			case 'go_add_edit_zone_screen.decrease_radius': return 'Disminuir Radio';
			case 'go_add_edit_zone_screen.set_center': return 'Establecer Centro';
			case 'go_churches_screen.title': return 'Iglesias';
			case 'go_churches_screen.add_church': return 'Añadir Iglesia';
			case 'go_churches_screen.delete_church': return 'Eliminar Iglesia';
			case 'go_churches_screen.delete_church_confirmation': return '¿Estás seguro de que quieres eliminar {churchName}?';
			case 'go_churches_screen.cancel': return 'Cancelar';
			case 'go_churches_screen.delete': return 'Eliminar';
			case 'go_churches_screen.church_deleted': return 'Iglesia {churchName} eliminada';
			case 'go_churches_screen.no_churches': return 'No hay iglesias añadidas todavía.';
			case 'go_churches_screen.pastor': return 'Pastor: {pastorName}';
			case 'go_churches_screen.phone': return 'Teléfono: {phone}';
			case 'go_churches_screen.email': return 'Correo electrónico: {email}';
			case 'go_churches_screen.address': return 'Dirección: {address}';
			case 'go_churches_screen.financial_status': return 'Estado financiero: {status}';
			case 'go_churches_screen.notes': return 'Notas:';
			case 'go_churches_screen.created': return 'Creado: {date}';
			case 'go_churches_screen.edit': return 'Editar';
			case 'go_contacts_screen.title': return 'Contactos';
			case 'go_contacts_screen.add_contact': return 'Añadir Contacto';
			case 'go_contacts_screen.delete_contact': return 'Eliminar Contacto';
			case 'go_contacts_screen.delete_contact_confirmation': return '¿Estás seguro de que quieres eliminar a {fullName}?';
			case 'go_contacts_screen.cancel': return 'Cancelar';
			case 'go_contacts_screen.delete': return 'Eliminar';
			case 'go_contacts_screen.contact_deleted': return 'Contacto {fullName} eliminado';
			case 'go_contacts_screen.no_contacts': return 'No hay contactos añadidos todavía.';
			case 'go_contacts_screen.full_name': return 'Nombre Completo';
			case 'go_contacts_screen.phone': return 'Teléfono: {phone}';
			case 'go_contacts_screen.email': return 'Correo electrónico: {email}';
			case 'go_contacts_screen.address': return 'Dirección: {address}';
			case 'go_contacts_screen.eternal_status': return 'Estado Eterno: {status}';
			case 'go_contacts_screen.birthday': return 'Cumpleaños: {birthday}';
			case 'go_contacts_screen.notes': return 'Notas:';
			case 'go_contacts_screen.created': return 'Creado: {date}';
			case 'go_contacts_screen.edit': return 'Editar';
			case 'go_export_import_screen.title': return 'Exportar/Importar';
			case 'go_export_import_screen.export_data': return 'Exportar Datos';
			case 'go_export_import_screen.import_data': return 'Importar Datos';
			case 'go_export_import_screen.churches': return 'Iglesias';
			case 'go_export_import_screen.contacts': return 'Contactos';
			case 'go_export_import_screen.ministries': return 'Ministerios';
			case 'go_export_import_screen.areas': return 'Áreas';
			case 'go_export_import_screen.streets': return 'Calles';
			case 'go_export_import_screen.zones': return 'Zonas';
			case 'go_export_import_screen.all': return 'Todo';
			case 'go_export_import_screen.no_churches': return 'No hay iglesias disponibles';
			case 'go_export_import_screen.no_contacts': return 'No hay contactos disponibles';
			case 'go_export_import_screen.no_ministries': return 'No hay ministerios disponibles';
			case 'go_export_import_screen.no_areas': return 'No hay áreas disponibles';
			case 'go_export_import_screen.no_streets': return 'No hay calles disponibles';
			case 'go_export_import_screen.no_zones': return 'No hay zonas disponibles';
			case 'go_export_import_screen.save_json': return 'Guardar JSON de {type}';
			case 'go_export_import_screen.select_json': return 'Seleccionar JSON de {type}';
			case 'go_export_import_screen.export_success': return '{type} exportado exitosamente';
			case 'go_export_import_screen.import_success': return '{type} importado exitosamente';
			case 'go_export_import_screen.error_export': return 'Error al exportar {type}: {error}';
			case 'go_export_import_screen.error_import': return 'Error al importar {type}: {error}';
			case 'go_export_import_screen.invalid_file': return 'Archivo inválido: Se esperaba datos de {type}';
			case 'go_export_import_screen.all_export_success': return 'Todos los datos exportados exitosamente';
			case 'go_export_import_screen.all_import_success': return 'Todos los datos importados exitosamente';
			case 'go_export_import_screen.error_export_all': return 'Error al exportar todos los datos: {error}';
			case 'go_export_import_screen.error_import_all': return 'Error al importar todos los datos: {error}';
			case 'go_ministries_screen.title': return 'Ministerios';
			case 'go_ministries_screen.add_ministry': return 'Añadir Ministerio';
			case 'go_ministries_screen.delete_ministry': return 'Eliminar Ministerio';
			case 'go_ministries_screen.delete_ministry_confirmation': return '¿Estás seguro de que quieres eliminar {ministryName}?';
			case 'go_ministries_screen.cancel': return 'Cancelar';
			case 'go_ministries_screen.delete': return 'Eliminar';
			case 'go_ministries_screen.ministry_deleted': return 'Ministerio {ministryName} eliminado';
			case 'go_ministries_screen.no_ministries': return 'No hay ministerios añadidos todavía.';
			case 'go_ministries_screen.contact': return 'Contacto: {contactName}';
			case 'go_ministries_screen.phone': return 'Teléfono: {phone}';
			case 'go_ministries_screen.email': return 'Correo electrónico: {email}';
			case 'go_ministries_screen.address': return 'Dirección: {address}';
			case 'go_ministries_screen.partner_status': return 'Estado de Colaboración: {status}';
			case 'go_ministries_screen.notes': return 'Notas:';
			case 'go_ministries_screen.created': return 'Creado: {date}';
			case 'go_ministries_screen.edit': return 'Editar';
			case 'go_offline_maps_screen.title': return 'Mapas sin conexión';
			case 'go_offline_maps_screen.select_your_own_map': return 'Selecciona tu propio mapa';
			case 'go_offline_maps_screen.downloaded_maps': return 'Mapas Descargados';
			case 'go_offline_maps_screen.no_maps_downloaded': return 'No hay mapas descargados todavía.';
			case 'go_offline_maps_screen.max_maps_warning': return 'Solo puedes tener hasta 5 mapas (incluyendo el mapa mundial por defecto). Por favor elimina un mapa antes de descargar uno nuevo.';
			case 'go_offline_maps_screen.failed_to_delete_map': return 'No se pudo eliminar el mapa ({mapName}): {error}';
			case 'go_offline_maps_screen.rename_map': return 'Renombrar Mapa';
			case 'go_offline_maps_screen.enter_new_map_name': return 'Introduce un nuevo nombre para el mapa';
			case 'go_offline_maps_screen.cancel': return 'Cancelar';
			case 'go_offline_maps_screen.save': return 'Guardar';
			case 'go_offline_maps_screen.failed_to_rename_map': return 'No se pudo renombrar el mapa: {error}';
			case 'go_offline_maps_screen.view': return 'Ver';
			case 'go_offline_maps_screen.update': return 'Actualizar';
			case 'go_offline_maps_screen.rename': return 'Renombrar';
			case 'go_offline_maps_screen.delete': return 'Eliminar';
			case 'go_offline_maps_screen.map_updated_successfully': return 'Mapa "{mapName}" actualizado exitosamente';
			case 'go_offline_maps_screen.failed_to_update_map': return 'No se pudo actualizar el mapa: {error}';
			case 'go_route_planner_screen.title': return 'Planificador de Rutas';
			case 'go_route_planner_screen.areas': return 'Áreas';
			case 'go_route_planner_screen.streets': return 'Calles';
			case 'go_route_planner_screen.zones': return 'Zonas';
			case 'go_route_planner_screen.no_areas': return 'No hay áreas añadidas todavía.';
			case 'go_route_planner_screen.no_streets': return 'No hay calles añadidas todavía.';
			case 'go_route_planner_screen.no_zones': return 'No hay zonas añadidas todavía.';
			case 'go_route_planner_screen.edit': return 'Editar';
			case 'go_route_planner_screen.rename': return 'Renombrar';
			case 'go_route_planner_screen.delete': return 'Eliminar';
			case 'go_route_planner_screen.view': return 'Ver';
			case 'go_route_planner_screen.add': return 'Añadir';
			case 'go_route_planner_screen.lat': return 'Lat: {lat}';
			case 'go_route_planner_screen.lon': return 'Lon: {lon}';
			case 'go_route_planner_screen.no_coordinates': return 'Sin coordenadas';
			case 'go_route_planner_screen.failed_to_delete': return 'No se pudo eliminar {type}: {error}';
			case 'go_route_planner_screen.failed_to_rename': return 'No se pudo renombrar {type}: {error}';
			case 'go_route_planner_screen.rename_type': return 'Renombrar {type}';
			case 'go_route_planner_screen.enter_new_name': return 'Introduce un nuevo nombre';
			case 'go_route_planner_screen.cancel': return 'Cancelar';
			case 'go_route_planner_screen.save': return 'Guardar';
			case 'go_search_screen.title': return 'Buscar Dirección';
			case 'go_search_screen.enter_address': return 'Introduce una dirección';
			case 'go_search_screen.please_enter_address': return 'Por favor, introduce una dirección.';
			case 'go_search_screen.address_not_found': return 'Dirección no encontrada.';
			case 'go_search_screen.found': return 'Encontrado: {displayName}';
			case 'go_search_screen.latitude': return 'Latitud: {lat}';
			case 'go_search_screen.longitude': return 'Longitud: {lon}';
			case 'go_search_screen.error_searching_address': return 'Error al buscar la dirección: {error}';
			case 'go_search_screen.search': return 'Buscar';
			case 'go_select_map_area_screen.title': return 'Seleccionar Área del Mapa';
			case 'go_select_map_area_screen.download_limit_exceeded': return 'Límite de Descarga Excedido';
			case 'go_select_map_area_screen.download_limit_message': return 'El área seleccionada excede el máximo permitido: 12,000 teselas o 155.55 MB. Por favor selecciona un área más pequeña.';
			case 'go_select_map_area_screen.ok': return 'OK';
			case 'go_select_map_area_screen.download_map': return 'Descargar Mapa';
			case 'go_select_map_area_screen.download_map_question': return '¿Descargar el mapa de esta área? Teselas estimadas: {tiles}, aproximadamente {size} MB.';
			case 'go_select_map_area_screen.close': return 'Cerrar';
			case 'go_select_map_area_screen.name_your_map': return 'Nombra tu Mapa';
			case 'go_select_map_area_screen.enter_map_name': return 'Introduce el nombre del mapa';
			case 'go_select_map_area_screen.cancel': return 'Cancelar';
			case 'go_select_map_area_screen.download': return 'Descargar';
			case 'go_select_map_routes_screen.title': return 'Seleccionar Ruta del Mapa';
			case 'go_select_map_routes_screen.select': return 'Seleccionar';
			case 'go_select_map_routes_screen.edit': return 'Editar';
			case 'go_select_map_routes_screen.view': return 'Ver';
			case 'go_select_map_routes_screen.area': return 'Área';
			case 'go_select_map_routes_screen.street': return 'Calle';
			case 'go_select_map_routes_screen.tag': return 'Etiqueta';
			case 'go_select_map_routes_screen.add_at_least_3_points': return 'Añade al menos 3 puntos para crear un área.';
			case 'go_select_map_routes_screen.add_at_least_2_points': return 'Añade al menos 2 puntos para crear una calle.';
			case 'go_select_map_routes_screen.add_a_tag': return 'Añade una etiqueta para guardar.';
			case 'go_select_map_routes_screen.enter_name': return 'Introduce un nombre';
			case 'go_select_map_routes_screen.name': return 'Nombre';
			case 'go_select_map_routes_screen.name_cannot_be_empty': return 'El nombre no puede estar vacío.';
			case 'go_select_map_routes_screen.save': return 'Guardar';
			case 'go_select_map_routes_screen.cancel': return 'Cancelar';
			case 'go_select_map_routes_screen.tag_text': return 'Texto de la Etiqueta';
			case 'go_select_map_routes_screen.enter_tag_text': return 'Introduce el texto de la etiqueta';
			case 'go_select_map_routes_screen.error_loading_item': return 'Error al cargar el elemento: {error}';
			case 'go_select_map_routes_screen.error_adding_point': return 'Error al añadir el punto: {error}';
			case 'go_select_map_routes_screen.error_saving_item': return 'Error al guardar el elemento: {error}';
			case 'go_select_map_routes_screen.zoom_in': return 'Acercar';
			case 'go_select_map_routes_screen.zoom_out': return 'Alejar';
			case 'go_share_screen.title': return 'Compartir';
			case 'go_share_screen.churches': return 'Iglesias';
			case 'go_share_screen.contacts': return 'Contactos';
			case 'go_share_screen.ministries': return 'Ministerios';
			case 'go_share_screen.areas': return 'Áreas';
			case 'go_share_screen.streets': return 'Calles';
			case 'go_share_screen.zones': return 'Zonas';
			case 'go_share_screen.all': return 'Todo';
			case 'go_share_screen.no_churches': return 'No hay iglesias disponibles';
			case 'go_share_screen.no_contacts': return 'No hay contactos disponibles';
			case 'go_share_screen.no_ministries': return 'No hay ministerios disponibles';
			case 'go_share_screen.no_areas': return 'No hay áreas disponibles';
			case 'go_share_screen.no_streets': return 'No hay calles disponibles';
			case 'go_share_screen.no_zones': return 'No hay zonas disponibles';
			case 'go_share_screen.share_all_data': return 'Compartir Todos los Datos';
			case 'go_share_screen.all_by_faith_data': return 'Todos los Datos de By Faith';
			case 'go_share_screen.could_not_launch_email': return 'No se pudo abrir el cliente de correo';
			case 'go_tab_screen.markers_in_zone': return 'Marcadores en la Zona';
			case 'go_tab_screen.close': return 'Cerrar';
			case 'go_tab_screen.add_area': return 'Añadir Área';
			case 'go_tab_screen.add_street': return 'Añadir Calle';
			case 'go_tab_screen.add_zone': return 'Añadir Zona';
			case 'go_tab_screen.add_contact': return 'Añadir Contacto';
			case 'go_tab_screen.add_church': return 'Añadir Iglesia';
			case 'go_tab_screen.add_ministry': return 'Añadir Ministerio';
			case 'go_tab_screen.offline_maps': return 'Mapas sin conexión';
			case 'go_tab_screen.route_planner': return 'Planificador de Rutas';
			case 'go_tab_screen.churches': return 'Iglesias';
			case 'go_tab_screen.contacts': return 'Contactos';
			case 'go_tab_screen.ministries': return 'Ministerios';
			case 'go_tab_screen.menu': return 'Menú Go';
			case 'go_tab_screen.search_address': return 'Buscar Dirección';
			case 'go_tab_screen.save_route': return 'Guardar Ruta';
			case 'go_tab_screen.hide_options': return 'Ocultar Opciones';
			case 'go_tab_screen.open_menu': return 'Abrir Menú';
			case 'go_tab_screen.tap_to_add_marker': return 'Toca el mapa para añadir un marcador.';
			case 'go_tab_screen.route_creation_cancelled': return 'Creación de ruta cancelada.';
			case 'go_tab_screen.add_at_least_3_points': return 'Añade al menos 3 puntos para crear un área.';
			case 'go_tab_screen.add_at_least_2_points': return 'Añade al menos 2 puntos para crear una calle.';
			case 'go_tab_screen.enter_name': return 'Introduce un nombre';
			case 'go_tab_screen.name': return 'Nombre';
			case 'go_tab_screen.cancel': return 'Cancelar';
			case 'go_tab_screen.save': return 'Guardar';
			case 'go_tab_screen.search': return 'Buscar';
			case 'go_tab_screen.address_not_found': return 'Dirección no encontrada.';
			case 'go_tab_screen.error_searching_address': return 'Error al buscar la dirección: {error}';
			case 'go_tab_screen.downloading': return 'Descargando {mapName}';
			case 'go_tab_screen.starting_download': return 'Iniciando descarga...';
			case 'go_tab_screen.downloaded_tiles': return 'Descargadas {attempted} de {max} teselas ({percent}%)';
			case 'go_tab_screen.failed_to_download_map': return 'No se pudo descargar el mapa ({mapName}): {error}';
			case 'go_tab_screen.tap_to_place_the_zone': return 'Toca para colocar la zona.';
			case 'go_tab_screen.select_area_or_street_from_the_route_planner': return 'Selecciona área o calle desde el planificador de rutas.';
			case 'go_tab_screen.areas': return 'Áreas';
			case 'go_tab_screen.streets': return 'Calles';
			case 'go_tab_screen.zones': return 'Zonas';
			case 'go_tab_screen.enter_address': return 'Introduce una dirección';
			default: return null;
		}
	}
}

