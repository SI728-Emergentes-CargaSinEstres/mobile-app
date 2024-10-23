import 'package:carga_sin_estres_flutter/data/models/services.dart';

class Company {
  final int id;
  final String name;
  final String tic;
  final String direction;
  final String email;
  final String phoneNumber;
  final String description;
  final String logo;
  final List<Services> services;
  final int averageRating;
  final bool hasMembership;

  Company({
    required this.id,
    required this.name,
    required this.tic,
    required this.direction,
    this.email = '',
    this.phoneNumber = '',
    this.description = '',
    required this.logo,
    required this.services,
    required this.averageRating,
    required this.hasMembership,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'] ?? 'Unknown Company',
      tic: json['tic'] ?? '',
      direction: json['direction'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? 'default_logo.png',
      services: (json['servicios'] as List<dynamic>?)
              ?.map((service) => Services.fromJson(service))
              .toList() ??
          [],
      averageRating: (json['averageRating'] as num?)?.toInt() ?? 0,
      hasMembership: json['hasMembership'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Company{id: $id, name: $name, direction: $direction, email: $email, '
        'phoneNumber: $phoneNumber, description: $description, '
        'logo: $logo, servicios: $services, averageRating: $averageRating, '
        'hasMembership: $hasMembership, tic: $tic}';
  }
}
