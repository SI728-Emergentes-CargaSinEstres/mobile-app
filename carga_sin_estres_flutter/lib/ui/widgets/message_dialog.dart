import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

void messageDialog(BuildContext context, String message, String buttonText,
    VoidCallback onPressed) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(canvasColor: Colors.transparent),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: const Icon(
              Icons.warning_amber_sharp,
              color: AppTheme.primaryYellow,
              size: 100,
            ),
            content: Text(message, textAlign: TextAlign.center),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onPressed();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                      ),
                      child: Text(buttonText,
                          style: const TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      child: const Text('Cancelar',
                          style: TextStyle(color: AppTheme.primaryYellow)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
