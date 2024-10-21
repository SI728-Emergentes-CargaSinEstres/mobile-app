// ignore_for_file: use_build_context_synchronously

import 'package:carga_sin_estres_flutter/data/models/sign_up.dart';
import 'package:carga_sin_estres_flutter/data/services/auth_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/date_of_birth_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/form_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/password_input.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  void _signUp() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _dateOfBirthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final signUp = SignUp(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      email: _emailController.text,
      password: _passwordController.text,
      dateOfBirth: DateTime.parse(_dateOfBirthController.text),
    );

    try {
      await _authService.signUp(signUp);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign up: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/background/wave_up_2.png',
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Registrarse'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Nombres',
                        icon: Icons.person,
                        controller: _firstNameController),
                    const SizedBox(height: 10),
                    FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Apellidos',
                        icon: Icons.person,
                        controller: _lastNameController),
                    const SizedBox(height: 10),
                    FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Número de celular',
                        icon: Icons.phone,
                        controller: _phoneNumberController),
                    const SizedBox(height: 10),
                    DateOfBirthInput(
                        inputWidth: inputWidth,
                        labelText: 'Fecha de nacimiento',
                        controller: _dateOfBirthController),
                    const SizedBox(height: 10),
                    FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Correo electrónico',
                        icon: Icons.email,
                        controller: _emailController),
                    const SizedBox(height: 10),
                    PasswordInput(
                        inputWidth: inputWidth,
                        labelText: 'Contraseña',
                        controller: _passwordController),
                    const SizedBox(height: 45),
                    SizedBox(
                      width: inputWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          _signUp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5757),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Completar Registro',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes una cuenta?"),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "¡Inicia Sesión!",
                            style: TextStyle(
                              color: Color(0xFFFFA726),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
