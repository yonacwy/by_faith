// lib/core/models/user_preferences_model.dart
import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferences {
  @Id()
  int id = 0;

  String? currentMap;
  String? fontFamily; // Added for font family
  double? fontSize;   // Added for font size

  UserPreferences({
    this.id = 0,
    this.currentMap,
    this.fontFamily = 'Roboto', // Default font
    this.fontSize = 16.0,      // Default size
  });
}