import 'package:carga_sin_estres_flutter/screens/menu/home.dart';
import 'package:carga_sin_estres_flutter/screens/menu/login.dart';
import 'package:carga_sin_estres_flutter/screens/menu/register.dart';
import 'package:carga_sin_estres_flutter/screens/menu/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carga Sin Estres',
      theme: ThemeData(
        fontFamily: 'Inter',
        splashColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => const SplashScreen();
            break;
          case '/login':
            builder = (BuildContext context) => const LoginScreen();
            break;
          case '/register':
            builder = (BuildContext context) => const RegisterScreen();
            break;
          case '/home':
            builder = (BuildContext context) => const HomeScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
