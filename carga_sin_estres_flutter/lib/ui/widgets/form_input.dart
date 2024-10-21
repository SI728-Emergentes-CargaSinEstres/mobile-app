import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final double inputWidth;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  const FormInput(
      {super.key,
      required this.inputWidth,
      required this.labelText,
      required this.icon,
      required this.controller});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.inputWidth,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: AppTheme.secondaryGray,
          ),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppTheme.secondaryGray2,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
