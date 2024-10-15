import 'package:carga_sin_estres_flutter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
