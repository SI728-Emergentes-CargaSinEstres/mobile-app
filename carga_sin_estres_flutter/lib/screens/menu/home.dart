import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/widgets/company_search.dart';
import 'package:carga_sin_estres_flutter/widgets/quick_load.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/background/wave_up_3.png',
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildUserWave('Javier'),
                    const SizedBox(height: 30),
                    const QuickLoad(),
                    const SizedBox(height: 30),
                    const CompanySearch(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserWave(String username) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 24,
            color: AppTheme.secondaryBlack,
          ),
          children: <TextSpan>[
            const TextSpan(text: 'Bienvenido '),
            TextSpan(
              text: '$username 👋',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
