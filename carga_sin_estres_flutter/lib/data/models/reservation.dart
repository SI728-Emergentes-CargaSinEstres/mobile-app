import 'package:carga_sin_estres_flutter/data/models/customer.dart';

class Reservation {
  final int id;
  final DateTime startDate;
  final String startTime;
  final int ubigeoOrigin;
  final String originAddress;
  final int ubigeoDestination;
  final String destinationAddress;
  final DateTime? endDate;
  final String? endTime;
  final double price;
  final String status;
  final String services;
  final int chatId;
  final Customer customer;
  final String companyName;

  Reservation({
    required this.id,
    required this.startDate,
    required this.startTime,
    required this.ubigeoOrigin,
    required this.originAddress,
    required this.ubigeoDestination,
    required this.destinationAddress,
    this.endDate,
    this.endTime,
    required this.price,
    required this.status,
    required this.services,
    required this.chatId,
    required this.customer,
    required this.companyName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      startDate: DateTime.parse(json['startDate']),
      startTime: json['startTime'],
      ubigeoOrigin: json['ubigeoOrigin'],
      originAddress: json['originAddress'],
      ubigeoDestination: json['ubigeoDestination'],
      destinationAddress: json['destinationAddress'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      endTime: json['endTime'],
      price: json['price'].toDouble(),
      status: json['status'],
      services: json['services'],
      chatId: json['chatId'],
      customer: Customer.fromJson(json['customer']),
      companyName: json['companyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'startTime': startTime,
      'ubigeoOrigin': ubigeoOrigin,
      'originAddress': originAddress,
      'ubigeoDestination': ubigeoDestination,
      'destinationAddress': destinationAddress,
      'endDate': endDate?.toIso8601String(),
      'endTime': endTime,
      'price': price,
      'status': status,
      'services': services,
      'chatId': chatId,
      'customer': customer.toJson(),
      'companyName': companyName,
    };
  }

  @override
  String toString() {
    return 'Reservation(id: $id, startDate: $startDate, startTime: $startTime, '
        'ubigeoOrigin: $ubigeoOrigin, originAddress: $originAddress, '
        'ubigeoDestination: $ubigeoDestination, destinationAddress: $destinationAddress, '
        'endDate: $endDate, endTime: $endTime, price: $price, '
        'status: $status, services: $services, chatId: $chatId, '
        'companyName: $companyName)';
  }
}
