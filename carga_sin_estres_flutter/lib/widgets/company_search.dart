import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/widgets/company_card.dart';
import 'package:flutter/material.dart';

class CompanySearch extends StatelessWidget {
  const CompanySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Búsqueda de empresas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Nombre',
            hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
            prefixIcon:
                const Icon(Icons.business, color: AppTheme.secondaryGray3),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Ubicación',
                  hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
                  prefixIcon: const Icon(Icons.location_on,
                      color: AppTheme.secondaryGray3),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['San Miguel', 'Monterrico', 'San Isidro']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Servicio',
                  hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
                  prefixIcon: const Icon(Icons.miscellaneous_services,
                      color: AppTheme.secondaryGray3),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Carga', 'Mudanza'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Usar Column para apilar los Company Cards
        const Column(
          children: [
            CompanyCard(
              logo: 'assets/moving_images/moving_truck.png',
              nombre: 'Romabe transporte',
              ubicacion: 'San Miguel',
              calificacion: 4,
              tipoServicio: 'Carga',
            ),
            CompanyCard(
              logo: 'assets/moving_images/moving_truck.png',
              nombre: 'J&G Transporte y mudanzas',
              ubicacion: 'Monterrico',
              calificacion: 3,
              tipoServicio: 'Mudanza',
            ),
            CompanyCard(
              logo: 'assets/moving_images/moving_truck.png',
              nombre: 'Transporte y mudanzas Rapi2',
              ubicacion: 'San Isidro',
              calificacion: 1,
              tipoServicio: 'Mudanza',
            ),
          ],
        ),
      ],
    );
  }
}
