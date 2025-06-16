import 'package:objectbox/objectbox.dart';

@Entity()
class GoContact {
  @Id()
  int id = 0;

  String fullName;
  double? latitude;
  double? longitude;
  String? address;
  String? birthday;
  String? phone;
  String? email;
  String? notes;
  bool isVisited;
  String? eternalStatus; // Added eternalStatus field

  GoContact({
    this.id = 0,
    required this.fullName,
    this.latitude,
    this.longitude,
    this.address,
    this.birthday,
    this.phone,
    this.email,
    this.notes,
    this.isVisited = false,
    this.eternalStatus, // Added eternalStatus to constructor
  });
}

@Entity()
class GoChurch {
  @Id()
  int id = 0;

  String churchName;
  String? pastorName;
  String? address;
  String? phone;
  String? email;
  double? latitude;
  double? longitude;
  String? notes;

  GoChurch({
    this.id = 0,
    required this.churchName,
    this.pastorName,
    this.address,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.notes,
  });
}

@Entity()
class GoMinistry {
  @Id()
  int id = 0;

  String ministryName;
  String? contactName;
  String? address;
  String? phone;
  String? email;
  double? latitude;
  double? longitude;
  String? notes;

  GoMinistry({
    this.id = 0,
    required this.ministryName,
    this.contactName,
    this.address,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.notes,
  });
}