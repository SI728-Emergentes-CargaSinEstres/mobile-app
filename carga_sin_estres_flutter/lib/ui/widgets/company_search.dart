import 'package:carga_sin_estres_flutter/data/models/company.dart';
import 'package:carga_sin_estres_flutter/data/services/company_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/company_card.dart';
import 'package:flutter/material.dart';

class CompanySearch extends StatefulWidget {
  const CompanySearch({super.key});

  @override
  State<CompanySearch> createState() => _CompanySearchState();
}

class _CompanySearchState extends State<CompanySearch> {
  List<Company> companies = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final service = CompanyService();
      List<Company> fetchedCompanies = await service.getCompanies();
      setState(() {
        companies = fetchedCompanies;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

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
        ...companies.map((company) {
          return CompanyCard(company: company);
        }),
      ],
    );
  }
}
