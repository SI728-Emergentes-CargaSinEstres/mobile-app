class Reservation {
  final int ubigeoOrigin;
  final String originAddress;
  final int ubigeoDestination;
  final String destinationAddress;
  final String startDate;
  final String startTime;
  final String services;

  Reservation({
    required this.ubigeoOrigin,
    required this.originAddress,
    required this.ubigeoDestination,
    required this.destinationAddress,
    required this.startDate,
    required this.startTime,
    this.services = "Transporte", // Por defecto a "Transporte"
  });

  Map<String, dynamic> toJson() {
    return {
      'ubigeoOrigin': ubigeoOrigin,
      'originAddress': originAddress,
      'ubigeoDestination': ubigeoDestination,
      'destinationAddress': destinationAddress,
      'startDate': startDate,
      'startTime': startTime,
      'services': services,
    };
  }
}
