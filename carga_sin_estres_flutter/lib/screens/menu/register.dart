import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/widgets/date_of_birth_input.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
                    _buildFormInput(inputWidth, 'Nombres', Icons.person),
                    const SizedBox(height: 10),
                    _buildFormInput(
                        inputWidth, 'Número de celular', Icons.phone),
                    const SizedBox(height: 10),
                    DateOfBirthInput(
                        inputWidth: inputWidth,
                        labelText: 'Fecha de nacimiento'),
                    const SizedBox(height: 10),
                    _buildFormInput(
                        inputWidth, 'Correo electrónico', Icons.email),
                    const SizedBox(height: 35),
                    _buildPasswordInput(inputWidth, 'Contraseña'),
                    const SizedBox(height: 45),
                    SizedBox(
                      width: inputWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
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

  Widget _buildFormInput(double inputWidth, String labelText, IconData icon) {
    return SizedBox(
      width: inputWidth,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppTheme.secondaryGray,
          ),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  Widget _buildPasswordInput(double inputWidth, String labelText) {
    return SizedBox(
      width: inputWidth,
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppTheme.secondaryGray,
          ),
          suffixIcon: _passwordController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppTheme.secondaryGray,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
