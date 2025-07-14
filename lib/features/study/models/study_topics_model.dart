import 'package:objectbox/objectbox.dart';

@Entity()
class CreatedTopicsEn {
  @Id()
  int id = 0;

  String title;
  List<String> verses; // Stores verse references (e.g., "Exod.20.1-Exod.20.26")

  CreatedTopicsEn({
    required this.title,
    this.verses = const [],
  });
}

@Entity()
class GeneratedTopicsEn {
  @Id()
  int id = 0;

  String title;
  List<String> verses; // Stores verse references (e.g., "Exod.20.1-Exod.20.26")

  GeneratedTopicsEn({
    required this.title,
    this.verses = const [],
  });
}