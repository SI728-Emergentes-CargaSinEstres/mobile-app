import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateOfBirthInput extends StatefulWidget {
  final double inputWidth;
  final String labelText;
  final TextEditingController controller;
  final String hintText;

  const DateOfBirthInput({
    super.key,
    required this.inputWidth,
    required this.labelText,
    required this.controller,
    required this.hintText,
  });

  @override
  State<DateOfBirthInput> createState() => _DateOfBirthInputState();
}

class _DateOfBirthInputState extends State<DateOfBirthInput> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.inputWidth,
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.calendar_today,
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
