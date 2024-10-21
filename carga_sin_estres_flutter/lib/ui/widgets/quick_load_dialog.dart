import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

void quickLoadDialog(
  BuildContext context,
  String origen,
  String destino,
  VoidCallback onPressed,
) {
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
                'Carga Rápida',
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
                Row(
                  children: [
                    const Text(
                      'Dirección de origen:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                          fontSize: 12.0),
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      origen,
                      style: const TextStyle(
                          color: AppTheme.secondaryGray3, fontSize: 14.0),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Text(
                      'Dirección de destino:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                          fontSize: 12.0),
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      origen,
                      style: const TextStyle(
                          color: AppTheme.secondaryGray3, fontSize: 14.0),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
              ],
            ),
            actions: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onPressed();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Reservar',
                          style: TextStyle(color: AppTheme.secondaryBlack)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 207, 207, 207),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: AppTheme.secondaryBlack)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
