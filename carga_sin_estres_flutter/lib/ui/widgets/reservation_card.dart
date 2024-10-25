import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatefulWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  bool _isDetailsExpanded = false;
  bool _isRatingExpanded = false;
  int? _rating;

  @override
  Widget build(BuildContext context) {
    String formatDateTime(DateTime date, String time) {
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime combined =
          DateTime(date.year, date.month, date.day, hour, minute);
      String formattedDate = DateFormat('EEEE dd/MM/yyyy').format(combined);
      String formattedTime = DateFormat('HH:mm').format(combined);
      return '$formattedDate ・ $formattedTime hs';
    }

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
            Text(formatDateTime(
                widget.reservation.startDate, widget.reservation.startTime)),
            const SizedBox(height: 16.0),
            const Text(
              'Fecha de finalización del servicio:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(formatDateTime(widget.reservation.endDate ?? DateTime.now(),
                widget.reservation.endTime ?? '00:00')),
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

            // ------------- Ver detalles
            if (_isDetailsExpanded) ...[
              const SizedBox(height: 8.0),
              const Text(
                'Servicios solicitados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.reservation.services),
              const SizedBox(height: 8.0),
              const Text(
                'Nombre de la empresa:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.reservation.companyName),
              const SizedBox(height: 8.0),
              const Text(
                'Costo del servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              widget.reservation.price == 0
                  ? const Text('Por cotizar')
                  : Text('\$${widget.reservation.price}'),
              const SizedBox(height: 8.0),
              const Text(
                'Estado del servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.reservation.status == 'solicited'
                    ? 'Iniciar Proceso'
                    : widget.reservation.status == 'to be scheduled'
                        ? 'Por programar'
                        : widget.reservation.status == 'scheduled'
                            ? 'Programado'
                            : widget.reservation.status == 're-scheduled'
                                ? 'Reprogramado'
                                : widget.reservation.status == 'cancelled'
                                    ? 'Cancelada'
                                    : widget.reservation.status == 'in progress'
                                        ? 'En progreso'
                                        : widget.reservation.status ==
                                                'finalized'
                                            ? 'Finalizado'
                                            : widget.reservation.status,
              ),
              const Divider(height: 24.0, thickness: 1.0),
            ],

            // ---------- Calificar servicio, solo visible si el estado es 'finalized'
            if (_isRatingExpanded &&
                widget.reservation.status == 'finalized') ...[
              const SizedBox(height: 8.0),
              const Text(
                'Califica el servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: _rating != null && _rating! > index
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_rating != null) {
                      print('Rating enviado: $_rating');
                      setState(() {
                        _rating = null;
                      });
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ),
              const Divider(height: 24.0, thickness: 1.0),
            ],

            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.details, 'Ver detalles', () {
                  setState(() {
                    _isDetailsExpanded = !_isDetailsExpanded;
                    _isRatingExpanded = false;
                  });
                }),
                // Botón "Calificar servicio"
                if (widget.reservation.status == 'finalized')
                  _buildActionButton(Icons.star, 'Calificar servicio', () {
                    setState(() {
                      _isRatingExpanded = !_isRatingExpanded;
                      _isDetailsExpanded = false;
                    });
                  }),
                if (widget.reservation.status != 'finalized' &&
                    widget.reservation.status != 'cancelled')
                  _buildActionButton(Icons.chat, 'Ver chat', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  }),
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
