import 'package:carga_sin_estres_flutter/data/models/services.dart';

class Company {
  final int id;
  final String name;
  final String tic;
  final String address;
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
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.description,
    required this.logo,
    required this.services,
    required this.averageRating,
    required this.hasMembership,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      tic: json['tic'],
      address: json['address'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      logo: json['logo'],
      services: json['services'],
      averageRating: json['averageRating'],
      hasMembership: json['hasMembership'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tic': tic,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'logo': logo,
      'services': services,
      'averageRating': averageRating,
      'hasMembership': hasMembership
    };
  }
}
