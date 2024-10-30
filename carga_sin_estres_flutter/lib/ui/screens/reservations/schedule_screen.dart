import 'package:carga_sin_estres_flutter/data/services/time_block_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ScheduleScreen extends StatefulWidget {
  final int companyId;

  const ScheduleScreen({super.key, required this.companyId});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<String> availableHours = [];
  String? selectedHour; // Cambiado para que solo se permita una selección
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';

  bool isLoading = true;

  final TimeBlockService _timeBlockService = TimeBlockService();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {
        formattedDate = DateFormat('EEE d \'de\' MMMM \'del\' yyyy', 'es_ES')
            .format(selectedDate);
      });
      _fetchTimeBlock(); // Obtiene el bloque de tiempo de la empresa después de inicializar la configuración regional
    });
  }

  // Método para obtener el bloque de tiempo de la empresa
  Future<void> _fetchTimeBlock() async {
    setState(() {
      isLoading = true; // Activar el indicador de carga
    });

    try {
      TimeBlock? timeBlock =
          await _timeBlockService.getTimeBlockByCompanyId(widget.companyId);
      if (timeBlock != null) {
        _generateAvailableHours(timeBlock.startTime, timeBlock.endTime);
      }
    } catch (error) {
      print('Error al obtener el bloque de tiempo: $error');
    } finally {
      setState(() {
        isLoading =
            false; // Desactivar el indicador de carga después de obtener los datos
      });
    }
  }

  // Método para generar las horas disponibles entre startTime y endTime
  void _generateAvailableHours(String start, String end) {
    DateTime startTime = DateFormat.Hms().parse(start);
    DateTime endTime = DateFormat.Hms().parse(end);

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

  // Método para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Cambiar el tema si se requiere
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('EEE d \'de\' MMMM \'del\' yyyy', 'es_ES')
            .format(pickedDate);
        selectedHour = null; // Deseleccionar horarios al cambiar de fecha
        _fetchTimeBlock(); // Volver a cargar los horarios para la nueva fecha
      });
    }
  }

  // Método para avanzar al siguiente día
  void _nextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      formattedDate = DateFormat('EEE d \'de\' MMMM \'del\' yyyy', 'es_ES')
          .format(selectedDate);
      selectedHour = null; // Deseleccionar horarios al avanzar de día
      _fetchTimeBlock(); // Volver a cargar los horarios para la nueva fecha
    });
  }

  // Método para retroceder al día anterior
  void _previousDay() {
    if (selectedDate.isAfter(DateTime.now())) {
      setState(() {
        selectedDate = selectedDate.subtract(const Duration(days: 1));
        formattedDate = DateFormat('EEE d \'de\' MMMM \'del\' yyyy', 'es_ES')
            .format(selectedDate);
        selectedHour = null; // Deseleccionar horarios al retroceder de día
        _fetchTimeBlock(); // Volver a cargar los horarios para la nueva fecha
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
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () =>
                  _selectDate(context), // Abre el calendario al hacer clic
              child: _buildDaySelector(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(), // Indicador de carga
                      )
                    : ListView.builder(
                        itemCount: availableHours.length,
                        itemBuilder: (context, index) {
                          String hour = availableHours[index];
                          return _buildTimeSlot(hour);
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedHour != null) {
                          Navigator.pop(context, {
                            'startDate': formattedDate,
                            'startTime': selectedHour,
                          });
                        } else {
                          print('No se seleccionó ningún horario');
                        }
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
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar la fecha seleccionada y los botones de avanzar/retroceder
  Widget _buildDaySelector() {
    return Container(
      color: const Color(0xFFEBA50A).withOpacity(0.7), // Fondo con opacidad
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.white), // Flecha blanca
            onPressed: _previousDay,
          ),
          Expanded(
            child: AutoSizeText(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20, // Tamaño más pequeño
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxFontSize: 20,
              minFontSize: 14, // Permite reducir el tamaño si es necesario
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward,
                color: Colors.white), // Flecha blanca
            onPressed: _nextDay,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String hour) {
    bool isSelected = selectedHour == hour;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                hour,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: const Color(0xFFFFD465),
              ),
              Text(
                _getNextHour(hour),
                style: const TextStyle(
                  fontSize: 16,
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
                    selectedHour = null;
                  } else {
                    selectedHour = hour;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 27),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFE5A4) : Colors.white,
                  border: const Border(
                    left: BorderSide(
                      color: Color(0xFFFBBF24),
                      width: 4,
                    ),
                  ),
                  borderRadius: isSelected
                      ? BorderRadius.circular(10)
                      : BorderRadius.zero,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      isSelected ? 'Seleccionado' : 'Disponible',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
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

  // Método para obtener la siguiente hora del intervalo
  String _getNextHour(String hour) {
    DateTime currentTime = DateFormat.Hm().parse(hour);
    DateTime nextTime = currentTime.add(const Duration(hours: 1));
    return DateFormat.Hm().format(nextTime);
  }
}
