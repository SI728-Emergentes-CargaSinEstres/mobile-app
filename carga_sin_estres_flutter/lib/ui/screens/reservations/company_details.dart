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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                ),
                child: const Text('Ver calendario',
                    style: TextStyle(
                        fontSize: 16, color: AppTheme.secondaryBlack)),
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
          items: ['Lima', 'Arequipa', 'Ayacucho'],
          onChanged: (value) {
            setState(() {
              selectedRegion = value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Provincia',
          items: ['Lima', 'Callao'],
          onChanged: (value) {
            setState(() {
              selectedProvince = value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hintText: 'Distrito',
          items: ['Monterrico', 'San Juan De Lurigancho'],
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
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
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
