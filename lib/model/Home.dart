import 'package:flutter/material.dart';
import 'package:aplicacionpadel/util/datepicker.dart';

import '../CRUDPartidoView/CrearPartido.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isCreatingPartido = false; // Variable para controlar qué contenido mostrar

  void _toggleCrearPartido() {
    setState(() {
      _isCreatingPartido = !_isCreatingPartido;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isCreatingPartido ? "Crear Partido" : "Inicio"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleCrearPartido, // Cambia el estado al presionar
        label: Text(_isCreatingPartido ? "Volver" : "Crear partido"),
        icon: Icon(
            _isCreatingPartido ? Icons.arrow_back : Icons.add_circle_outline),
      ),
      body: _isCreatingPartido
          ? CrearPartido(
              onCancel:
                  _toggleCrearPartido, // Permitir regresar al contenido principal
            )
          : const Center(
              child: Text(
                  "Pantalla principal"), // Aquí va el contenido principal de Home
            ),
    );
  }
}
