import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import '../../../core/models/user_preferences_model.dart';
import '../../../objectbox.dart';

class HomeSettingsFontProvider with ChangeNotifier {
  late Box<UserPreferences> _userPreferencesBox;
  late UserPreferences _userPreferences;

  String _fontFamily = 'Roboto';
  double _fontSize = 16.0;

  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;

  HomeSettingsFontProvider() {
    _userPreferencesBox = store.box<UserPreferences>();
    _loadPreferences();
  }

  void _loadPreferences() {
    _userPreferences = _userPreferencesBox.getAll().isNotEmpty
        ? _userPreferencesBox.getAll().first
        : UserPreferences();
    _fontFamily = _userPreferences.fontFamily ?? 'Roboto';
    _fontSize = _userPreferences.fontSize ?? 16.0;
    notifyListeners();
  }

  void setFontFamily(String newFontFamily) {
    if (_fontFamily != newFontFamily) {
      _fontFamily = newFontFamily;
      _userPreferences.fontFamily = newFontFamily;
      _userPreferencesBox.put(_userPreferences);
      notifyListeners();
    }
  }

  void setFontSize(double newFontSize) {
    if (_fontSize != newFontSize) {
      _fontSize = newFontSize;
      _userPreferences.fontSize = newFontSize;
      _userPreferencesBox.put(_userPreferences);
      notifyListeners();
    }
  }
}