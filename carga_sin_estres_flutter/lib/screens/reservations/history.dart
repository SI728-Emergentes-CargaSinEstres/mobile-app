import 'package:carga_sin_estres_flutter/screens/reservations/chat.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:carga_sin_estres_flutter/widgets/custom_bottom_navigation_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _reservationStatusTab = 'Nuevos';

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
            child: ListView(
              children: [
                _buildReservationCard(
                  context,
                  startDate: 'Viernes 26/01/2024',
                  startTime: '11:00 hs',
                  endDate: 'Viernes 26/01/2024',
                  endTime: '14:00 hs',
                  origin: 'Av. Javier Prado Este 4200, Santiago de Surco',
                  destination: 'Prolongación Primavera 2390, Santiago de Surco',
                ),
              ],
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

  Widget _buildReservationCard(
    BuildContext context, {
    required String startDate,
    required String startTime,
    required String endDate,
    required String endTime,
    required String origin,
    required String destination,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fecha de inicio del servicio:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text('$startDate $startTime'),
            const SizedBox(height: 16.0),
            const Text(
              'Fecha de finalización del servicio:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text('$endDate $endTime'),
            const Divider(height: 24.0, thickness: 1.0),
            Row(
              children: [
                _buildLocationIcon(Colors.purple),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Origen',
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                      Text(origin),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                _buildLocationIcon(Colors.orange),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Destino',
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      Text(destination),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0, thickness: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.chat, 'Ver chat'),
                _buildActionButton(Icons.details, 'Ver detalles'),
                _buildActionButton(Icons.assignment, 'Contrato'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationIcon(Color color) {
    return CircleAvatar(
      radius: 10.0,
      backgroundColor: color.withOpacity(0.2),
      child: CircleAvatar(
        radius: 6.0,
        backgroundColor: color,
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 4.0),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
