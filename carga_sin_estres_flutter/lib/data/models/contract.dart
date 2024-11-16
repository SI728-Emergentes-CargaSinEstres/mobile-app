class Contract {
  final int id;
  final int reservationId;
  final String hashCodeValue;
  final String registeredDate;
  final String registeredTime;

  Contract({
    required this.id,
    required this.reservationId,
    required this.hashCodeValue,
    required this.registeredDate,
    required this.registeredTime,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      reservationId: json['reservationId'],
      hashCodeValue: json['hashCodeValue'],
      registeredDate: json['registeredDate'],
      registeredTime: json['registeredTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservationId': reservationId,
      'hashCodeValue': hashCodeValue,
      'registeredDate': registeredDate,
      'registeredTime': registeredTime,
    };
  }
}
