import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/data/services/history_service.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/reservation_card.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _reservationStatusTab = 'Nuevos';
  List<Reservation> reservations = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        final historyService = HistoryService();
        final fetchedReservations =
            await historyService.getReservationsByCustomerId(userId!);
        setState(() {
          reservations = fetchedReservations; // Mantén todas las reservas
        });
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  List<Reservation> _filteredReservations() {
    if (_reservationStatusTab == 'Nuevos') {
      return reservations
          .where((reservation) => reservation.status == 'solicited')
          .toList();
    } else if (_reservationStatusTab == 'Completados') {
      return reservations
          .where((reservation) =>
              reservation.status == 'finalized' ||
              reservation.status == 'cancelled')
          .toList();
    } else if (_reservationStatusTab == 'Pendientes') {
      return reservations
          .where((reservation) =>
              reservation.status != 'finalized' &&
              reservation.status != 'cancelled' &&
              reservation.status != 'solicited')
          .toList();
    }
    return reservations;
  }

  void _setActiveTab(String tab) {
    setState(() {
      _reservationStatusTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Historial de Reservas',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusFilterTab('Nuevos',
                        isActive: _reservationStatusTab == 'Nuevos'),
                    _buildStatusFilterTab('Pendientes',
                        isActive: _reservationStatusTab == 'Pendientes'),
                    _buildStatusFilterTab('Completados',
                        isActive: _reservationStatusTab == 'Completados'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredReservations().isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron servicios reservados',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredReservations().length,
                    itemBuilder: (context, index) {
                      final reservation = _filteredReservations()[index];
                      return ReservationCard(
                        reservation: reservation,
                        onRated: () {
                          _fetchReservations(); // Recarga la lista actualizada
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildStatusFilterTab(String title, {bool isActive = false}) {
    return GestureDetector(
      onTap: () => _setActiveTab(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4D4C7D) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isActive ? const Color(0xFF4D4C7D) : Colors.transparent),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF4D4C7D),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
