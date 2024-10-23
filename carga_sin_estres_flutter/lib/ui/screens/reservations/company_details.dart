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
  String? selectedRegion;
  String? selectedProvince;
  String? selectedDistrict;

  // Listas para almacenar las opciones dinámicas de región, provincia y distrito
  List<String> regions = [];
  List<String> provinces = [];
  List<String> districts = [];

  bool isLoading = false; // Variable para indicar si está cargando datos

  final UbigeoService _ubigeoService =
      UbigeoService(); // Instancia del servicio de Ubigeo

  @override
  void initState() {
    super.initState();
    _fetchRegions(); // Llamar al servicio para obtener las regiones
  }

  // Método para obtener los departamentos (regiones)
  Future<void> _fetchRegions() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<String> data = await _ubigeoService.fetchDepartments();
      setState(() {
        regions = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error al obtener los departamentos: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para obtener las provincias
  Future<void> _fetchProvinces(String department) async {
    setState(() {
      isLoading = true;
      provinces.clear(); // Limpiar provincias al seleccionar una nueva región
      districts.clear(); // Limpiar distritos
      selectedProvince = null;
      selectedDistrict = null;
    });

    try {
      List<String> data = await _ubigeoService.fetchProvinces(department);
      setState(() {
        provinces = data;
        isLoading = false;
      });
    } catch (error) {
      print('Error al obtener las provincias: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para obtener los distritos
  Future<void> _fetchDistricts(String province) async {
    setState(() {
      isLoading = true;
      districts.clear(); // Limpiar distritos al seleccionar una nueva provincia
      selectedDistrict = null;
    });

    try {
      List<Map<String, dynamic>> data =
          await _ubigeoService.fetchDistricts(province);
      setState(() {
        districts = data.map((d) => d['distrito'] as String).toList();
        isLoading = false;
      });
    } catch (error) {
      print('Error al obtener los distritos: $error');
      setState(() {
        isLoading = false;
      });
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
            _buildFDropdownAddress(),
            const SizedBox(height: 8),
            _buildTextField(),
            const SizedBox(height: 24),
            const Text(
              'Dirección de destino',
              style: TextStyle(fontSize: 16, color: AppTheme.secondaryGray),
            ),
            const SizedBox(height: 8),
            _buildFDropdownAddress(),
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

  Widget _buildFDropdownAddress() {
    return Column(
      children: [
        _buildDropdown(
          hintText: 'Región',
          value: selectedRegion, // Añadir el valor seleccionado
          items: regions,
          onChanged: (value) {
            if (value != selectedRegion) {
              setState(() {
                selectedRegion = value;
                selectedProvince = null;
                selectedDistrict = null;
              });
              _fetchProvinces(value!);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Provincia',
          value: selectedProvince, // Añadir el valor seleccionado
          items: provinces,
          onChanged: (value) {
            if (value != selectedProvince) {
              setState(() {
                selectedProvince = value;
                selectedDistrict = null;
              });
              _fetchDistricts(value!);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Distrito',
          value: selectedDistrict, // Añadir el valor seleccionado
          items: districts,
          onChanged: (value) {
            setState(() {
              selectedDistrict = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value, // El valor seleccionado
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value)
          ? value
          : null, // Verifica si el valor está en la lista
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
      onChanged: (selectedValue) {
        if (selectedValue != value) {
          onChanged(selectedValue);
        }
      },
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
