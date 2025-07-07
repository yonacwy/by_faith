// lib/core/models/user_preferences_model.dart
import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferences {
  @Id()
  int id = 0;

  String? currentMap;
  String? fontFamily; // Added for font family
  double? fontSize;   // Added for font size
  String? languageCode; // Added for language preference
  int? currentBibleVersionId; // Added for current Bible version

  UserPreferences({
    this.id = 0,
    this.currentMap,
    this.fontFamily = 'Roboto', // Default font
    this.fontSize = 16.0,      // Default size
    this.languageCode = 'en',  // Default language
    this.currentBibleVersionId, // Default to null
  });
}

/// Gets the current user preferences, or creates default if not found.
UserPreferences getUserPreferences(Box<UserPreferences> box) {
  final prefs = box.getAll();
  if (prefs.isNotEmpty) {
    return prefs.first;
  } else {
    final defaultPrefs = UserPreferences();
    box.put(defaultPrefs);
    return defaultPrefs;
  }
}

/// Updates and saves the language preference.
void setLanguagePreference(Box<UserPreferences> box, String languageCode) {
  final prefs = getUserPreferences(box);
  prefs.languageCode = languageCode;
  box.put(prefs);
}