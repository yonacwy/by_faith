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

  GoContact({
    required this.fullName,
    this.latitude,
    this.longitude,
    this.address,
    this.birthday,
    this.phone,
    this.email,
    this.notes,
  });
}