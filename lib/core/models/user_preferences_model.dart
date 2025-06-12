import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferences {
  @Id()
  int id = 0;

  String? currentMap;

  UserPreferences({this.id = 0, this.currentMap});
}

// Added a comment to trigger potential rebuild