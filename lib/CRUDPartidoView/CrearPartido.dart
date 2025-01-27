import 'package:aplicacionpadel/util/TimePicker.dart';
import 'package:flutter/material.dart';
import 'package:aplicacionpadel/util/datepicker.dart';

class CrearPartido extends StatefulWidget {
  const CrearPartido({super.key, onCancel});

  @override
  State<CrearPartido> createState() => _CrearPartidoState();
}

class _CrearPartidoState extends State<CrearPartido> {
  final _formKey = GlobalKey<FormState>();
  String? _lugarDelPartido;
  DateTime? _fechaSeleccionada; // Variable para almacenar la fecha seleccionada
  TimeOfDay? _horaSeleccionada; // Variable para la hora seleccionada

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Introduce el lugar del partido",
                hintText: "Ejemplo: Pista central",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, introduce el lugar del partido";
                }
                return null;
              },
              onSaved: (value) {
                _lugarDelPartido = value;
              },
            ),
            const SizedBox(height: 20),
            Datepicker(
              onDateSelected: (fecha) {
                setState(() {
                  _fechaSeleccionada = fecha; // Actualizar la fecha seleccionada
                });
              },
            ),
            const SizedBox(height: 20),
            Timepicker(onTimeSelected: (value){
              setState(() {
                _horaSeleccionada = value;
              });
            },),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  // Aquí puedes gestionar los datos introducidos
                  print("Lugar del partido: $_lugarDelPartido");
                  print("Fecha del partido: $_fechaSeleccionada");
                  print("Hora del partido: $_horaSeleccionada");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Partido creado exitosamente")),
                  );
                }
              },
              child: const Text("Guardar Partido"),
            ),
          ],
        ),
      ),
    );
  }
}
