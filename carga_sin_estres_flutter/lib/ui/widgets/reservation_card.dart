import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/chat.dart';
import 'package:flutter/material.dart';

class ReservationCard extends StatefulWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  @override
  Widget build(BuildContext context) {
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
            Text(
                '${widget.reservation.startDate.toString()} ${widget.reservation.startTime.toString()}'),
            const SizedBox(height: 16.0),
            const Text(
              'Fecha de finalización del servicio:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
                '${widget.reservation.endDate.toString()} ${widget.reservation.endTime.toString()}'),
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
                      Text(widget.reservation.originAddress),
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
                      Text(widget.reservation.destinationAddress),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0, thickness: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.chat, 'Ver chat', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                }),
                _buildActionButton(Icons.details, 'Ver detalles', () {}),
                _buildActionButton(Icons.assignment, 'Contrato', () {}),
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

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(height: 4.0),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
