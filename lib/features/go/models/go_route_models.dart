// lib/features/go/models/go_route_models.dart
import 'package:objectbox/objectbox.dart';
import 'package:latlong2/latlong.dart';

@Entity()
class GoArea {
  @Id()
  int id = 0;
  String name;
  List<double> latitudes; // List of latitudes for polygon points
  List<double> longitudes; // List of longitudes for polygon points

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
  List<double> latitudes; // List of latitudes for polyline points
  List<double> longitudes; // List of longitudes for polyline points

  GoStreet({
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
class GoTag {
  @Id()
  int id = 0;
  String name;
  String text;
  double latitude; // Center of the tag
  double longitude;
  double widthInMeters; // Width of the widget
  double heightInMeters; // Height of the widget

  GoTag({
    this.id = 0,
    required this.name,
    required this.text,
    required this.latitude,
    required this.longitude,
    required this.widthInMeters,
    required this.heightInMeters,
  });

  LatLng get center => LatLng(latitude, longitude);
}