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
	@override late final _TranslationsGoSettingsScreenEs go_settings_screen = _TranslationsGoSettingsScreenEs._(_root);
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
			case 'go_settings_screen.title': return 'Ajustes';
			case 'go_settings_screen.text_settings': return 'Ajustes de Texto';
			case 'go_settings_screen.font_family': return 'Familia de Fuente';
			case 'go_settings_screen.font_size': return 'Tamaño de Fuente:';
			case 'go_settings_screen.preview': return 'Vista Previa:';
			case 'go_settings_screen.back': return 'Atrás';
			case 'go_settings_screen.load': return 'Cargar';
			case 'go_settings_screen.sample_text': return 'Y les dijo: Id por todo el mundo y predicad el evangelio a toda criatura.';
			default: return null;
		}
	}
}

