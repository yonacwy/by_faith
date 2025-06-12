import 'package:objectbox/objectbox.dart';

@Entity()
class GoMapInfo {
  @Id()
  int id = 1;

  String name;
  String? filePath;
  String? downloadUrl;
  bool? isTemporary;
  double? latitude;
  double? longitude;
  int? zoomLevel;

  GoMapInfo({
    this.id = 1,
    required this.name,
    required this.filePath,
    required this.downloadUrl,
    required this.isTemporary,
    required this.latitude,
    required this.longitude,
    required this.zoomLevel,
  });
}