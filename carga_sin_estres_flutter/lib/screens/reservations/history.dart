import 'package:carga_sin_estres_flutter/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History Screen')),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
