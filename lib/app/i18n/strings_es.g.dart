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
			default: return null;
		}
	}
}

