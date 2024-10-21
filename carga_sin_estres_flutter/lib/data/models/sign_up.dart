class SignUp {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;
  final DateTime dateOfBirth;

  SignUp({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJsonSignUp() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCustomer() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonSignIn() {
    return {
      'username': email,
      'password': password,
    };
  }
}
