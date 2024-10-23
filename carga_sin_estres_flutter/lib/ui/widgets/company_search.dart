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

  List<Company> filteredCompanies = [];
  final TextEditingController _searchByNameController = TextEditingController();
  final TextEditingController _searchByLocationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompanies();
    _searchByNameController.addListener(_filterCompanies);
    _searchByLocationController.addListener(_filterCompanies);
  }

  Future<void> _loadCompanies() async {
    try {
      final service = CompanyService();
      List<Company> fetchedCompanies = await service.getCompanies();
      setState(() {
        companies = fetchedCompanies;
        filteredCompanies = fetchedCompanies;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void _filterCompanies() {
    String nameQuery = _searchByNameController.text.toLowerCase();
    String locationQuery = _searchByLocationController.text.toLowerCase();

    setState(() {
      filteredCompanies = companies.where((company) {
        bool matchesName = company.name.toLowerCase().contains(nameQuery);
        bool matchesLocation =
            company.direction.toLowerCase().contains(locationQuery);
        return matchesName && matchesLocation;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchByNameController.dispose();
    _searchByLocationController.dispose();
    super.dispose();
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
          controller: _searchByNameController,
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
        TextField(
          controller: _searchByLocationController,
          decoration: InputDecoration(
            hintText: 'Ubicación',
            hintStyle: const TextStyle(color: AppTheme.secondaryGray3),
            prefixIcon:
                const Icon(Icons.location_on, color: AppTheme.secondaryGray3),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
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
        const SizedBox(height: 10),
        ...filteredCompanies.map((company) {
          return CompanyCard(company: company);
        }),
      ],
    );
  }
}
