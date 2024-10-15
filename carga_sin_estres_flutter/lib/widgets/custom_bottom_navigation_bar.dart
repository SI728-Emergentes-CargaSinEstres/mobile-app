import 'package:flutter/material.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          backgroundColor: Colors.transparent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '',
          backgroundColor: Colors.transparent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
          backgroundColor: Colors.transparent,
        ),
      ],
      selectedItemColor: AppTheme.primaryYellow,
      unselectedItemColor: AppTheme.secondaryBlack,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
