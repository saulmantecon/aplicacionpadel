import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndTimePicker extends FormField<DateTime> {
  DateAndTimePicker({super.key, required FormFieldSetter<DateTime> onSaved})
      : super(
    onSaved: onSaved,
    builder: (FormFieldState<DateTime> state) {
      return _DatepickerWidget(state: state);
    },
  );
}

class _DatepickerWidget extends StatefulWidget {
  final FormFieldState<DateTime> state;

  const _DatepickerWidget({super.key, required this.state});

  @override
  State<_DatepickerWidget> createState() => _DatepickerWidgetState();
}

class _DatepickerWidgetState extends State<_DatepickerWidget> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        initialTime: TimeOfDay.fromDateTime(DateTime.now()), context: context,
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Guardar la fecha en el estado del FormField
        widget.state.didChange(finalDateTime);

        setState(() {
          _dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _dateController,
        decoration: const InputDecoration(
          labelText: "Seleccionar fecha y hora",
          filled: true,
          prefixIcon: Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        readOnly: true,
        onTap: selectDate,
        validator: (value) {
          if (widget.state.value == null) {
            return "Por favor, selecciona la fecha y hora";
          }
          return null;
        },
      ),
    );
  }
}
