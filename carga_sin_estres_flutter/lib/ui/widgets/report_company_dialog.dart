import 'package:carga_sin_estres_flutter/data/services/business_rules_service.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

void reportCompanyDialog(
  BuildContext context,
  VoidCallback onPressed,
  int companyId,
) {
  final BusinessRulesService businessRulesService = BusinessRulesService();
  TextEditingController reasonController = TextEditingController();

  Future<void> createCompanyViolation() async {
    try {
      await businessRulesService.createCompanyViolationService(
        companyId,
        reasonController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: AppTheme.secondaryGray),
          ),
          backgroundColor: AppTheme.secondaryRed,
        ),
      );
    }
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            canvasColor: Colors.transparent,
          ),
          child: AlertDialog(
            backgroundColor: AppTheme.secondaryBlack,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: const Center(
              child: Text(
                'Reportar',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryYellow,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Una vez reportada la empresa, se cancelará la reserva.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  style: const TextStyle(color: AppTheme.secondaryGray),
                  decoration: InputDecoration(
                    hintText: 'Escriba la razón aquí...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: AppTheme.primaryWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onPressed();
                      createCompanyViolation();

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Reportar',
                        style: TextStyle(color: AppTheme.secondaryBlack)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Cancelar',
                        style: TextStyle(color: AppTheme.secondaryBlack)),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
