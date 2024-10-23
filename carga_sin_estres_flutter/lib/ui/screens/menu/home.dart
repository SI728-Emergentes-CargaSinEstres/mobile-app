import 'package:carga_sin_estres_flutter/data/models/customer.dart';
import 'package:carga_sin_estres_flutter/data/services/customer_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/company_search.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/quick_load.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? userId;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        CustomerService customerService = CustomerService();
        Customer fetchedCustomer =
            await customerService.getCustomerById(userId!);
        setState(() {
          customer = fetchedCustomer;
        });
      } catch (e) {
        print('Error al obtener el customer: $e');
      }
    }
  }

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
                    _buildUserWave(customer?.firstName ?? ''),
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildUserWave(String username) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
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
        // Botón de cerrar sesión
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            // Acción para cerrar sesión
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // Limpiar la información guardada

            // Redirigir a la pantalla de login
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}
