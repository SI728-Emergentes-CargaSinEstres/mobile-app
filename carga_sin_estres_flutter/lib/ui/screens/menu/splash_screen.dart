import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/background/wave_up.png',
            width: screenWidth,
            fit: BoxFit.cover,
            height: 170,
          ),
          Column(
            children: [
              Image.asset(
                'assets/moving_images/moving_splash_screen.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 20),
              const Text(
                'Carga Sin Estrés: Tu mudanza sin\npreocupaciones, de principio a fin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(235, 255, 211, 53),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/background/wave_down.png',
            width: screenWidth,
            fit: BoxFit.cover,
            height: 170,
          ),
        ],
      ),
    );
  }
}
