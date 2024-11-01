import 'dart:convert';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class UbigeoService {
  final String baseUrl = AppTheme.baseUrl;

  // Obtener todos los departamentos
  Future<List<String>> fetchDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener los departamentos');
    }
  }

  // Obtener las provincias según el departamento
  Future<List<String>> fetchProvinces(String department) async {
    final response =
        await http.get(Uri.parse('$baseUrl/provincias/$department'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las provincias');
    }
  }

  // Obtener los distritos según la provincia
  Future<List<Map<String, dynamic>>> fetchDistricts(String province) async {
    final response = await http.get(Uri.parse('$baseUrl/distritos/$province'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener los distritos');
    }
  }
}
