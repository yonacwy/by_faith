import 'package:objectbox/objectbox.dart';

@Entity()
class GoNote {
  @Id()
  int id = 0;

  String content;
  @Property(type: PropertyType.date)
  DateTime createdAt;
  @Property(type: PropertyType.date)
  DateTime? updatedAt;

  GoNote({
    this.id = 0,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });
}

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
  bool isVisited;
  String? eternalStatus;
  final notes = ToMany<GoNote>();

  GoContact({
    this.id = 0,
    required this.fullName,
    this.latitude,
    this.longitude,
    this.address,
    this.birthday,
    this.phone,
    this.email,
    this.isVisited = false,
    this.eternalStatus,
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
  String? financialStatus;

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
    this.financialStatus,
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
  String? partnerStatus;

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
    this.partnerStatus,
  });
}