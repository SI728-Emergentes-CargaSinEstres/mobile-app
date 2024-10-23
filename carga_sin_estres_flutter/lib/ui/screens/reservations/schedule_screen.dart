import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<String> availableHours = [];

  // Ejemplo de respuesta de la API
  Map<String, dynamic> scheduleResponse = {
    "id": 2,
    "startTime": "09:00:00",
    "endTime": "12:00:00", // Modifica según el horario obtenido
    "companyId": 1,
  };

  List<String> selectedHours = [];
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _generateAvailableHours();
  }

  // Método para generar las horas disponibles entre startTime y endTime
  void _generateAvailableHours() {
    DateTime startTime = DateFormat.Hms().parse(scheduleResponse['startTime']);
    DateTime endTime = DateFormat.Hms().parse(scheduleResponse['endTime']);

    List<String> hours = [];
    while (startTime.isBefore(endTime)) {
      String formattedHour = DateFormat.Hm().format(startTime);
      hours.add(formattedHour);

      // Incrementa por una hora
      startTime = startTime.add(const Duration(hours: 1));
    }

    setState(() {
      availableHours = hours;
    });
  }

  // Método para seleccionar una fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate, // Solo fechas a partir de hoy
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'), // Asegúrate de usar la localización
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Puedes cambiar el tema si deseas
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        formattedDate = DateFormat('dd/MM/yy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Agenda Empresarial',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySelector(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableHours.length,
                itemBuilder: (context, index) {
                  String hour = availableHours[index];
                  return _buildTimeSlot(hour);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí puedes manejar la reserva o el siguiente paso
                      print('Horarios seleccionados: $selectedHours');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                    ),
                    child: const Text(
                      'Seleccionar',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryBlack,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Volver atrás
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryGray2,
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar solo la fecha de hoy y el botón para seleccionar otra fecha
  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'HOY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            _selectDate(context); // Abre el selector de fecha
          },
          icon: const Icon(Icons.calendar_today, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildTimeSlot(String hour) {
    bool isSelected = selectedHours.contains(hour);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                hour,
                style: const TextStyle(
                  fontSize: 16, // Aumentado el tamaño de las horas
                  color: Colors.black,
                ),
              ),
              Container(
                width: 2,
                height: 40, // Ajuste de la longitud de la línea
                color: const Color(0xFFFFD465), // Color de la línea
              ),
              Text(
                _getNextHour(hour),
                style: const TextStyle(
                  fontSize: 16, // Aumentado el tamaño de las horas
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedHours.remove(hour);
                  } else {
                    selectedHours.add(hour);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 27),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFE5A4) : Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: const Color(0xFFFBBF24),
                      width: 4, // Solo borde izquierdo
                    ),
                  ),
                  borderRadius: isSelected
                      ? BorderRadius.circular(
                          10) // Redondeado para seleccionado
                      : BorderRadius.zero, // Sin redondeado para disponible
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      isSelected ? 'Seleccionado' : 'Disponible',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Aumentado el tamaño del texto
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para obtener la siguiente hora para el intervalo
  String _getNextHour(String hour) {
    DateTime currentTime = DateFormat.Hm().parse(hour);
    DateTime nextTime = currentTime.add(const Duration(hours: 1));
    return DateFormat.Hm().format(nextTime);
  }
}
