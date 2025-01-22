import 'package:aplicacionpadel/util/datepicker.dart';
import 'package:flutter/material.dart';

class Crearpartido extends StatefulWidget {
  const Crearpartido({super.key});

  @override
  State<Crearpartido> createState() => _CrearpartidoState();
}

class _CrearpartidoState extends State<Crearpartido> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(

                  labelText: "Introduce el lugar del partido",
                  hintText: "lugar"),
            ),
            DatePicker()
          ],
        ));
  }
}
