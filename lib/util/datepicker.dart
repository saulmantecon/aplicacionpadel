import 'package:flutter/material.dart';

class Datepicker extends StatefulWidget {
  final ValueChanged<DateTime?> onDateSelected; // Callback para devolver la fecha seleccionada

  const Datepicker({super.key, required this.onDateSelected});

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
      widget.onDateSelected(_picked); // Llamar al callback con la fecha seleccionada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: TextField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: "Seleccionar fecha",
          filled: true,
          prefixIcon: Icon(Icons.calendar_today),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        ),
        readOnly: true,
        onTap: () => selectDate(),
      ),
    );
  }
}
