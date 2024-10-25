import 'package:carga_sin_estres_flutter/data/services/ubigeo_service.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/schedule_screen.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:carga_sin_estres_flutter/data/models/company.dart';

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
  String? selectedOriginDistrict;
  List<String> originRegions = [];
  List<String> originProvinces = [];
  List<String> originDistricts = [];

  // Variables para la Dirección de Destino
  String? selectedDestinationRegion;
  String? selectedDestinationProvince;
  String? selectedDestinationDistrict;
  List<String> destinationRegions = [];
  List<String> destinationProvinces = [];
  List<String> destinationDistricts = [];

  final UbigeoService _ubigeoService = UbigeoService();

  @override
  void initState() {
    super.initState();
    _fetchRegions(isOrigin: true);
    _fetchRegions(isOrigin: false);
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
          selectedOriginDistrict = null;
        } else {
          destinationProvinces = data;
          destinationDistricts.clear();
          selectedDestinationProvince = null;
          selectedDestinationDistrict = null;
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
          originDistricts = data.map((d) => d['distrito'] as String).toList();
        } else {
          destinationDistricts =
              data.map((d) => d['distrito'] as String).toList();
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
            _buildTextField(),
            const SizedBox(height: 24),
            const Text(
              'Dirección de destino',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            const SizedBox(height: 8),
            _buildFDropdownAddress(isOrigin: false),
            const SizedBox(height: 8),
            _buildTextField(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ScheduleScreen(companyId: widget.company.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                ),
                child: const Text(
                  'Ver calendario',
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppTheme.secondaryBlack,
                        backgroundColor: AppTheme.secondaryGray2),
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
                selectedOriginDistrict = null;
              });
              _fetchProvinces(department: value!, isOrigin: true);
            } else {
              setState(() {
                selectedDestinationRegion = value;
                selectedDestinationProvince = null;
                selectedDestinationDistrict = null;
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
                selectedOriginDistrict = null;
              });
              _fetchDistricts(province: value!, isOrigin: true);
            } else {
              setState(() {
                selectedDestinationProvince = value;
                selectedDestinationDistrict = null;
              });
              _fetchDistricts(province: value!, isOrigin: false);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Distrito',
          value:
              isOrigin ? selectedOriginDistrict : selectedDestinationDistrict,
          items: isOrigin ? originDistricts : destinationDistricts,
          onChanged: (value) {
            setState(() {
              if (isOrigin) {
                selectedOriginDistrict = value;
              } else {
                selectedDestinationDistrict = value;
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

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Dirección exacta',
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
