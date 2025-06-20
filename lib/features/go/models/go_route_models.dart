import 'package:objectbox/objectbox.dart';
import 'package:latlong2/latlong.dart';

@Entity()
class GoArea {
  @Id()
  int id = 0;
  String name;
  List<double> latitudes;
  List<double> longitudes;

  GoArea({
    this.id = 0,
    required this.name,
    required this.latitudes,
    required this.longitudes,
  });

  List<LatLng> get points => List.generate(
        latitudes.length,
        (index) => LatLng(latitudes[index], longitudes[index]),
      );
}

@Entity()
class GoStreet {
  @Id()
  int id = 0;
  String name;
  List<double> latitudes;
  List<double> longitudes;
  String? type; // Store line type (street, river, path)

  GoStreet({
    this.id = 0,
    required this.name,
    required this.latitudes,
    required this.longitudes,
    this.type,
  });

  List<LatLng> get points => List.generate(
        latitudes.length,
        (index) => LatLng(latitudes[index], longitudes[index]),
      );
}

@Entity()
class GoZone {
  @Id()
  int id = 0;

  String name;
  double latitude;
  double longitude;
  double widthInMeters;
  double heightInMeters;

  GoZone({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.widthInMeters,
    required this.heightInMeters,
  });

  LatLng get center => LatLng(latitude, longitude);
}