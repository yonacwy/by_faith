import 'package:objectbox/objectbox.dart';

@Entity()
class CrossReference {
  @Id()
  int id = 0;

  String verse; // e.g., "Gen.1.1"
  String toVerse; // e.g., "Ps.90.2"

  CrossReference({required this.verse, required this.toVerse});
}