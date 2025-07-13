import 'package:objectbox/objectbox.dart';

@Entity()
class BiblesDownload {
  int id;
  String name;
  String shortTitle; // Added shortTitle
  String url;

  BiblesDownload({
    this.id = 0,
    required this.name,
    required this.shortTitle,
    required this.url,
  });
}