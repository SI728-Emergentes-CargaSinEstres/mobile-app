import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/quick_load_dialog.dart';
import 'package:flutter/material.dart';

class QuickLoad extends StatelessWidget {
  const QuickLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Carga Rápida',
                  style: TextStyle(
                    color: AppTheme.primaryYellow,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '¿Lo necesitas para hoy? Pulsa el botón y las empresas te contactarán',
                  style: TextStyle(
                    color: AppTheme.primaryWhite,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 6.0),
                  ),
                  onPressed: () {
                    quickLoadDialog(context, 'xx', 'yy', () {});
                  },
                  child: const Text(
                    'Solicitar servicio',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20.0),
          Image.asset(
            'assets/moving_images/moving_truck.png',
            width: 140,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
