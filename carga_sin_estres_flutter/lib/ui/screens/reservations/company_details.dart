import 'dart:convert';

import 'package:carga_sin_estres_flutter/data/models/reservation_model.dart';
import 'package:carga_sin_estres_flutter/data/services/reservation_service.dart';
import 'package:carga_sin_estres_flutter/data/services/ubigeo_service.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/schedule_screen.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:carga_sin_estres_flutter/data/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final Company company;

  const CompanyDetailsScreen({super.key, required this.company});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  // Variables para la Dirección de Origen
  String? selectedOriginRegion;
  String? selectedOriginProvince;
  String? selectedOriginDistrictId;
  List<String> originRegions = [];
  List<String> originProvinces = [];
  List<Map<String, dynamic>> originDistricts = [];

  // Variables para la Dirección de Destino
  String? selectedDestinationRegion;
  String? selectedDestinationProvince;
  String? selectedDestinationDistrictId;
  List<String> destinationRegions = [];
  List<String> destinationProvinces = [];
  List<Map<String, dynamic>> destinationDistricts = [];

  // Controladores de texto para las direcciones
  final TextEditingController _originAddressController =
      TextEditingController();
  final TextEditingController _destinationAddressController =
      TextEditingController();

  // Variables para la fecha y hora seleccionada
  String? startDate;
  String? startTime;

  String? selectedServiceType;
  List<String> serviceTypes = [];

  bool isReserveButtonEnabled =
      false; // Variable para controlar el estado del botón

  final UbigeoService _ubigeoService = UbigeoService();

  Future<void> _fetchCompanyServices() async {
    try {
      // Obtener los servicios desde la empresa seleccionada
      setState(() {
        serviceTypes = widget.company.services.map((s) => s.name).toList();
      });
    } catch (error) {
      print('Error al obtener los servicios de la empresa: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRegions(isOrigin: true);
    _fetchRegions(isOrigin: false);
    _fetchCompanyServices(); // Nueva línea para obtener los tipos de servicios
  }

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se destruye
    _originAddressController.dispose();
    _destinationAddressController.dispose();
    super.dispose();
  }

  void _validateReserveButton() {
    setState(() {
      isReserveButtonEnabled = selectedOriginRegion != null &&
          selectedOriginProvince != null &&
          selectedOriginDistrictId != null &&
          selectedDestinationRegion != null &&
          selectedDestinationProvince != null &&
          selectedDestinationDistrictId != null &&
          selectedServiceType != null &&
          startDate != null &&
          startTime != null;
    });
  }

  Future<void> _fetchRegions({required bool isOrigin}) async {
    try {
      List<String> data = await _ubigeoService.fetchDepartments();
      setState(() {
        if (isOrigin) {
          originRegions = data;
        } else {
          destinationRegions = data;
        }
      });
    } catch (error) {
      print('Error al obtener los departamentos: $error');
    }
  }

  Future<void> _fetchProvinces(
      {required String department, required bool isOrigin}) async {
    try {
      List<String> data = await _ubigeoService.fetchProvinces(department);
      setState(() {
        if (isOrigin) {
          originProvinces = data;
          originDistricts.clear();
          selectedOriginProvince = null;
          selectedOriginDistrictId = null;
        } else {
          destinationProvinces = data;
          destinationDistricts.clear();
          selectedDestinationProvince = null;
          selectedDestinationDistrictId = null;
        }
      });
    } catch (error) {
      print('Error al obtener las provincias: $error');
    }
  }

  Future<void> _fetchDistricts(
      {required String province, required bool isOrigin}) async {
    try {
      List<Map<String, dynamic>> data =
          await _ubigeoService.fetchDistricts(province);
      setState(() {
        if (isOrigin) {
          originDistricts = data;
        } else {
          destinationDistricts = data;
        }
      });
    } catch (error) {
      print('Error al obtener los distritos: $error');
    }
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
        title: Text(
          widget.company.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.secondaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.company.logo),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.company.description.isNotEmpty
                            ? widget.company.description
                            : 'Descripción no disponible',
                        style: const TextStyle(
                            fontSize: 16, color: AppTheme.secondaryGray),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < widget.company.averageRating
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Detalles de la empresa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCompanyDetails(),
            const SizedBox(height: 40),
            const Text(
              'Detalles de la reserva',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dirección de origen',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            const SizedBox(height: 8),
            _buildFDropdownAddress(isOrigin: true),
            const SizedBox(height: 8),
            _buildTextField(isOrigin: true),
            const SizedBox(height: 24),
            const Text(
              'Dirección de destino',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            const SizedBox(height: 8),
            _buildFDropdownAddress(isOrigin: false),
            const SizedBox(height: 8),
            _buildTextField(isOrigin: false),
            const SizedBox(height: 16),
            const Text(
              'Tipo de servicio',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedServiceType,
              decoration: InputDecoration(
                hintText: 'Selecciona el tipo de servicio',
                hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              items: serviceTypes.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedServiceType = value;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ScheduleScreen(companyId: widget.company.id),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      startDate = result['startDate'];
                      startTime = result['startTime'];
                    });
                    _validateReserveButton();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                ),
                child: Text(
                  startDate != null && startTime != null
                      ? '$startDate - $startTime'
                      : 'Ver calendario',
                  style:
                      TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isReserveButtonEnabled
                        ? () async {
                            if (selectedOriginDistrictId != null &&
                                selectedDestinationDistrictId != null &&
                                startDate != null &&
                                startTime != null) {
                              try {
                                final int? originUbigeo = _getDistrictIdByName(
                                    selectedOriginDistrictId, originDistricts);
                                final int? destinationUbigeo =
                                    _getDistrictIdByName(
                                        selectedDestinationDistrictId,
                                        destinationDistricts);

                                if (originUbigeo == null ||
                                    destinationUbigeo == null) {
                                  throw Exception(
                                      'No se pudo encontrar el id del distrito seleccionado.');
                                }

                                final String originAddress =
                                    _originAddressController.text;
                                final String destinationAddress =
                                    _destinationAddressController.text;

                                // Crear el modelo de reserva
                                final Reservation reservation = Reservation(
                                  ubigeoOrigin: originUbigeo,
                                  originAddress: originAddress,
                                  ubigeoDestination: destinationUbigeo,
                                  destinationAddress: destinationAddress,
                                  startDate: startDate!,
                                  startTime: startTime!,
                                  services:
                                      selectedServiceType!, // Añadido el tipo de servicio seleccionado
                                );

                                // Obtener el customerId desde SharedPreferences
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final int? customerId = prefs.getInt('userId');

                                if (customerId == null || customerId == 0) {
                                  throw Exception(
                                      'Error: customerId no válido');
                                }

                                // Imprimir la información de la solicitud
                                print(
                                    'Realizando solicitud para crear reserva con los siguientes datos:');
                                print('Customer ID: $customerId');
                                print('Company ID: ${widget.company.id}');
                                print('Ubigeo Origen: $originUbigeo');
                                print('Ubigeo Destino: $destinationUbigeo');
                                print('Dirección Origen: $originAddress');
                                print('Dirección Destino: $destinationAddress');
                                print('Fecha: $startDate');
                                print('Hora: $startTime');

                                // Crear la reserva
                                final String reservationJson =
                                    jsonEncode(reservation.toJson());
                                print(
                                    'JSON de la reserva que se envía al backend: $reservationJson');

                                // Crear la reserva
                                await ReservationService().createReservation(
                                  customerId: customerId,
                                  companyId: widget.company.id,
                                  reservation: reservation,
                                );

                                // Mostrar mensaje de éxito
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Reserva creada con éxito'),
                                ));

                                // Navegar a la vista de historial de reservas
                                Navigator.pushReplacementNamed(
                                    context, '/history');
                              } catch (e) {
                                print('Error al crear la reserva: $e');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text('Error al crear la reserva: $e'),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    'Por favor, completa todos los campos incluyendo la fecha y la hora.'),
                              ));
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppTheme.secondaryBlack,
                      backgroundColor: isReserveButtonEnabled
                          ? AppTheme.primaryYellow
                          : AppTheme.secondaryGray2,
                    ),
                    child:
                        const Text('Reservar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppTheme.secondaryBlack,
                        backgroundColor: AppTheme.secondaryGray2),
                    child:
                        const Text('Cancelar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildCompanyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TIC:',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            Text(
              widget.company.tic.isNotEmpty
                  ? widget.company.tic
                  : 'No TIC available',
              style:
                  const TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Dirección:',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 113, 109, 109)),
            ),
            Text(
              widget.company.direction.isNotEmpty
                  ? widget.company.direction
                  : 'No direction available',
              style:
                  const TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Email:',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 113, 109, 109)),
            ),
            Text(
              widget.company.email.isNotEmpty
                  ? widget.company.email
                  : 'No email available',
              style:
                  const TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Teléfono:',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 113, 109, 109)),
            ),
            Text(
              widget.company.phoneNumber.isNotEmpty
                  ? widget.company.phoneNumber
                  : 'No phone available',
              style:
                  const TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Servicios:',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 113, 109, 109)),
            ),
            Text(
              widget.company.services.isNotEmpty
                  ? widget.company.services.map((s) => s.name).join(', ')
                  : 'No hay servicios disponibles',
              style:
                  const TextStyle(fontSize: 16, color: AppTheme.secondaryBlack),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFDropdownAddress({required bool isOrigin}) {
    return Column(
      children: [
        _buildDropdown(
          hintText: 'Región',
          value: isOrigin ? selectedOriginRegion : selectedDestinationRegion,
          items: isOrigin ? originRegions : destinationRegions,
          onChanged: (value) {
            if (isOrigin) {
              setState(() {
                selectedOriginRegion = value;
                selectedOriginProvince = null;
                selectedOriginDistrictId = null;
              });
              _fetchProvinces(department: value!, isOrigin: true);
            } else {
              setState(() {
                selectedDestinationRegion = value;
                selectedDestinationProvince = null;
                selectedDestinationDistrictId = null;
              });
              _fetchProvinces(department: value!, isOrigin: false);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Provincia',
          value:
              isOrigin ? selectedOriginProvince : selectedDestinationProvince,
          items: isOrigin ? originProvinces : destinationProvinces,
          onChanged: (value) {
            if (isOrigin) {
              setState(() {
                selectedOriginProvince = value;
                selectedOriginDistrictId = null;
              });
              _fetchDistricts(province: value!, isOrigin: true);
            } else {
              setState(() {
                selectedDestinationProvince = value;
                selectedDestinationDistrictId = null;
              });
              _fetchDistricts(province: value!, isOrigin: false);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Distrito',
          value: isOrigin
              ? selectedOriginDistrictId
              : selectedDestinationDistrictId,
          items: isOrigin
              ? originDistricts
                  .map((district) => district['distrito'] as String)
                  .toList()
              : destinationDistricts
                  .map((district) => district['distrito'] as String)
                  .toList(),
          onChanged: (value) {
            setState(() {
              if (isOrigin) {
                selectedOriginDistrictId = value;
              } else {
                selectedDestinationDistrictId = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({required bool isOrigin}) {
    return TextField(
      controller:
          isOrigin ? _originAddressController : _destinationAddressController,
      decoration: InputDecoration(
        hintText: isOrigin
            ? 'Dirección exacta de origen'
            : 'Dirección exacta de destino',
        hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

int? _getDistrictIdByName(
    String? districtName, List<Map<String, dynamic>> districts) {
  try {
    return districts
        .firstWhere((district) => district['distrito'] == districtName)['id'];
  } catch (e) {
    print('Error al buscar el distrito: $e');
    return null;
  }
}

Future<int> getCustomerIdFromPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('customerId') ?? 0; // Retorna 0 si no existe
}
