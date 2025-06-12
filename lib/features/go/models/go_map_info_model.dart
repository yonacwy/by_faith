import 'package:objectbox/objectbox.dart';

@Entity()
class GoMapInfo {
  @Id()
  int id = 0;

  String name;
  String? filePath;
  String? downloadUrl;
  bool? isTemporary;
  double? latitude;
  double? longitude;
  int? zoomLevel;

  GoMapInfo({
    this.id = 0,
    required this.name,
    required this.filePath,
    required this.downloadUrl,
    required this.isTemporary,
    required this.latitude,
    required this.longitude,
    required this.zoomLevel,
  });
}