import 'package:carga_sin_estres_flutter/data/models/company.dart';
import 'package:carga_sin_estres_flutter/data/models/contract.dart';
import 'package:carga_sin_estres_flutter/data/models/reservation.dart';
import 'package:carga_sin_estres_flutter/data/services/contract_service.dart';
import 'package:carga_sin_estres_flutter/data/services/history_service.dart';
import 'package:carga_sin_estres_flutter/data/services/rating_service.dart';
import 'package:carga_sin_estres_flutter/data/services/company_service.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/chat.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/delete_dialog.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/message_dialog.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/report_company_dialog.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
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
  Contract? _contract;
  Company? _company;
  int? _rating;
  final RatingService _ratingService = RatingService();
  final CompanyService _companyService = CompanyService();
  final HistoryService _historyService = HistoryService();
  bool _isLoadingContract = false;
  final ContractService _contractService = ContractService();

  @override
  void initState() {
    super.initState();
    _fetchContract();
    _fetchCompanyByName();
  }

  void _fetchCompanyByName() async {
    try {
      final fetchedCompany = await _companyService
          .getCompanyByName(widget.reservation.companyName);
      setState(() {
        _company = fetchedCompany;
      });
    } catch (e) {
      print('Error fetching company: $e');
    }
  }

  void _fetchContract() async {
    if (widget.reservation.status != 'solicited') {
      setState(() {
        _isLoadingContract = true;
      });
      try {
        final fetchedContract = await _contractService
            .getContractByReservationId(widget.reservation.id);
        setState(() {
          _contract = fetchedContract;
        });
      } catch (e) {
        print('Error fetching contract: $e');
      } finally {
        setState(() {
          _isLoadingContract = false;
        });
      }
    }
  }

  Future<void> _acceptChanges() async {
    try {
      await _historyService.updateReservationStatus(
        widget.reservation.id,
        'scheduled',
      );

      await _contractService.createContract(widget.reservation.id);

      _fetchContract();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios aceptados y contrato creado.')),
        );
      }
    } catch (e) {
      print('Error al aceptar cambios: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String formatDateTime(DateTime date, String time) {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    DateTime combined = DateTime(date.year, date.month, date.day, hour, minute);
    String formattedDate = DateFormat('EEEE dd/MM/yyyy').format(combined);
    String formattedTime = DateFormat('HH:mm').format(combined);
    return '$formattedDate ・ $formattedTime hs';
  }

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
            if (widget.reservation.status == 'finalized' ||
                widget.reservation.status == 'cancelled') ...[
              const Text(
                'Fecha de inicio del servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(formatDateTime(
                widget.reservation.startDate,
                widget.reservation.startTime,
              )),
              const SizedBox(height: 16.0),
              const Text(
                'Fecha de finalización del servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(formatDateTime(
                widget.reservation.endDate ?? DateTime.now(),
                widget.reservation.endTime ?? '00:00',
              )),
            ] else ...[
              const Text(
                'Fecha para realizar el servicio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(formatDateTime(
                widget.reservation.startDate,
                widget.reservation.startTime,
              )),
            ],
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

              // ---------- Contrato, solo visible si el estado no es 'solicited'

              if (_isLoadingContract)
                const CircularProgressIndicator()
              else if (_contract != null) ...[
                const Divider(height: 24.0, thickness: 1.0),
                const Text(
                  'Detalles del Contrato',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xFF4D4C7D)),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Hash Code:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_contract!.hashCodeValue),
                const SizedBox(height: 8.0),
                const Text(
                  'Fecha de Registro:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_contract!.registeredDate),
                const SizedBox(height: 8.0),
                const Text(
                  'Hora de Registro:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_contract!.registeredTime),
                const SizedBox(height: 8.0),
              ],

              // ---------- Cancelar solicitud, solo visible si el estado no es 'finalized', 'cancelled' o 'in progress'
              if (widget.reservation.status != 'finalized' &&
                  widget.reservation.status != 'cancelled' &&
                  widget.reservation.status != 'in progress') ...[
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      deleteDialog(
                        context,
                        '¿Estás seguro de que deseas eliminar la solicitud?',
                        'Eliminar solicitud',
                        () async {
                          try {
                            await _historyService.updateReservationStatus(
                              widget.reservation.id,
                              'cancelled',
                            );
                          } catch (error) {
                            print('Error: $error');
                          }
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                    ),
                    child: const Text('Cancelar solicitud',
                        style: TextStyle(color: AppTheme.secondaryRed)),
                  ),
                ),
              ],

              // ---------- Reportar infracción de empresa, solo visible si el estado está en 'in progress'
              if (widget.reservation.status == 'in progress') ...[
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      reportCompanyDialog(context, () async {
                        try {
                          await _historyService.updateReservationStatus(
                            widget.reservation.id,
                            'cancelled',
                          );
                        } catch (error) {
                          print('Error updating reservation status: $error');
                        }
                      }, _company?.id ?? -1);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                    ),
                    child: const Text(
                      'Reportar infracción de empresa',
                      style: TextStyle(color: AppTheme.secondaryRed),
                    ),
                  ),
                ),
              ],
              const Divider(height: 24.0, thickness: 1.0),
            ],

            // ---------- Aceptar o Rechazar cambios, solo visible si el estado es 're-scheduled' o 'to be scheduled'
            if (_isDetailsExpanded &&
                (widget.reservation.status == 're-scheduled' ||
                    widget.reservation.status == 'to be scheduled')) ...[
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        messageDialog(
                          context,
                          '¿Estás seguro de que deseas aceptar los cambios?',
                          'Aceptar cambios',
                          _acceptChanges,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                      ),
                      child: const Text(
                        'Aceptar Cambios',
                        style: TextStyle(color: AppTheme.secondaryBlack),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        deleteDialog(
                          context,
                          '¿Estás seguro de que deseas rechazar los cambios?',
                          'Rechazar cambios',
                          () async {
                            try {
                              await _historyService.updateReservationStatus(
                                widget.reservation.id,
                                'cancelled',
                              );
                            } catch (error) {
                              print('Error: $error');
                            }
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryRed,
                      ),
                      child: const Text(
                        'Rechazar cambios',
                        style: TextStyle(color: AppTheme.primaryWhite),
                      ),
                    ),
                  ),
                ],
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
                  onPressed: () async {
                    if (_rating != null) {
                      try {
                        await _ratingService.postRatingByCompanyId(
                          _company?.id ?? -1,
                          _rating!,
                        );
                        print('Rating enviado: $_rating');
                      } catch (e) {
                        print('Error: $e');
                      }
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
                        builder: (context) =>
                            ChatScreen(reservation: widget.reservation),
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
