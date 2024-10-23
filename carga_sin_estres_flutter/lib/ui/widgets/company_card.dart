import 'package:carga_sin_estres_flutter/data/models/company.dart';
import 'package:carga_sin_estres_flutter/ui/screens/reservations/company_details.dart';
import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsScreen(company: company),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                company.logo,
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < company.averageRating
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      company.name,
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
                        Text(company.direction),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: company.services.map((service) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4.0),
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
                        service.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
