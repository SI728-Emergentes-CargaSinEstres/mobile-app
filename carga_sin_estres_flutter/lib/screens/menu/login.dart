import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // Controla la visibilidad de la contraseña
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // No se necesita un listener en este caso, manejaremos el estado directamente.
  }

  @override
  void dispose() {
    _passwordController.dispose(); // Liberar el controlador al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      resizeToAvoidBottomInset:
          true, // Asegura que el contenido se reajuste cuando el teclado aparece
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Imagen wave superior
              Image.asset(
                'assets/background/wave_up_1.png',
                width: screenWidth,
                fit: BoxFit.cover,
                height: screenWidth * 0.5,
              ),
              // Contenido principal centrado
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrando el contenido
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centrado horizontalmente
                  children: <Widget>[
                    Align(
                      alignment: Alignment
                          .centerLeft, // Alineación del texto a la izquierda
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Iniciar '),
                            TextSpan(
                              text: 'Sesión',
                              style: TextStyle(
                                color: Color(0xFFEBA50A), // Color para "Sesión"
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    SizedBox(
                      width: inputWidth,
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Colors.grey), // Solo el borde del ícono
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: inputWidth,
                      child: TextField(
                        controller: _passwordController,
                        obscureText:
                            !_isPasswordVisible, // Mostrar u ocultar contraseña
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          suffixIcon: _passwordController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                )
                              : null,
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Redibuja cuando el texto cambie para mostrar u ocultar el ícono
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 45),
                    SizedBox(
                      width: inputWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
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
                          'Iniciar Sesión',
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
                        const Text("¿No tienes una cuenta?"),
                        const SizedBox(width: 10), // Espacio entre textos
                        GestureDetector(
                          onTap: () {
                            // Navegación a la pantalla de registro
                          },
                          child: const Text(
                            "¡Regístrate!",
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
