class CustomerUpdate {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String? password; // Contraseña opcional para actualizar
  final DateTime dateOfBirth;

  CustomerUpdate({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      if (password != null && password!.isNotEmpty) 'password': password,
    };
  }
}
