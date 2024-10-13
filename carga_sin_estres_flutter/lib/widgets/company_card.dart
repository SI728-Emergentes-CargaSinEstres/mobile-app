import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final String logo;
  final String nombre;
  final String ubicacion;
  final int calificacion;
  final String tipoServicio;

  const CompanyCard({
    super.key,
    required this.logo,
    required this.nombre,
    required this.ubicacion,
    required this.calificacion,
    required this.tipoServicio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              logo,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          calificacion,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          tipoServicio,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.orange, size: 16.0),
                      const SizedBox(width: 4),
                      Text(ubicacion),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
