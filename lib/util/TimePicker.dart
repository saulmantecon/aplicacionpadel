import 'package:flutter/material.dart';

class Timepicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onTimeSelected;

  const Timepicker({super.key, required this.onTimeSelected});

  @override
  State<Timepicker> createState() => _TimepickerState();
}

class _TimepickerState extends State<Timepicker> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("${selectedTime.hour}:${selectedTime.minute}"),
          ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    initialEntryMode: TimePickerEntryMode.dial);
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                  widget.onTimeSelected(time); // Enviar la hora seleccionada al padre
                }
              },
              child: const Text("Hora del partido"))
        ],
      ),
    );
  }
}
