import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/date_of_birth_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/form_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/password_input.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Center(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Color(0xFFECECEC),
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: AppTheme.secondaryGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FormInput(
                          inputWidth: inputWidth,
                          labelText: 'Nombres',
                          icon: Icons.person,
                          controller: _firstNameController),
                      const SizedBox(height: 20),
                      FormInput(
                          inputWidth: inputWidth,
                          labelText: 'Apellidos',
                          icon: Icons.person,
                          controller: _lastNameController),
                      const SizedBox(height: 20),
                      FormInput(
                          inputWidth: inputWidth,
                          labelText: 'Número de celular',
                          icon: Icons.phone,
                          controller: _phoneNumberController),
                      const SizedBox(height: 20),
                      DateOfBirthInput(
                          inputWidth: inputWidth,
                          labelText: 'Fecha de nacimiento',
                          controller: _dateOfBirthController),
                      const SizedBox(height: 20),
                      FormInput(
                          inputWidth: inputWidth,
                          labelText: 'Correo electrónico',
                          icon: Icons.email,
                          controller: _emailController),
                      const SizedBox(height: 20),
                      PasswordInput(
                          inputWidth: inputWidth,
                          labelText: 'Contraseña',
                          controller: _passwordController),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: inputWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5757),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Editar Perfil',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}