import 'dart:convert';

import 'package:aplicacionpadel/model/Partido.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aplicacionpadel/model/Partido.dart';

class Containerpartido extends StatefulWidget {
  final Partido partido;
  const Containerpartido({super.key, required this.partido});

  @override
  State<Containerpartido> createState() => _ContainerpartidoState();
}

class _ContainerpartidoState extends State<Containerpartido> {
  bool mostrarResultado = false;
  final TextEditingController set1Controller = TextEditingController();
  final TextEditingController set2Controller = TextEditingController();
  final TextEditingController set3Controller = TextEditingController();

  void toggleMostrarResultado(){
    mostrarResultado= !mostrarResultado;
  }

  void guardarResultado() async{
    String set1 = set1Controller.text.trim();
    String set2 = set2Controller.text.trim();
    String set3 = set3Controller.text.trim();

    if (set1.isEmpty || set2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes completar al menos 2 sets")),
      );
    }else{
      String resultado = "$set1, $set2";
      if (set3.isNotEmpty) {
        resultado += ", $set3";
      }




      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Resultado guardado: $resultado")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Nº: ${widget.partido.idPartido}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.partido.lugar, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.partido.fecha, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _buildJugador(""),
                    _buildJugador("Jugador", widget.partido.creador.imagen),
                  ],
                ),
                const Text("VS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
                Column(
                  children: [
                    _buildJugador("Jugador", widget.partido.creador.imagen),
                    _buildJugador("Jugador", widget.partido.creador.imagen),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    toggleMostrarResultado();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Fijar partido", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 20,),
            if (mostrarResultado) _buildResultadoInput(), //cuando pulse el usuario al boton fijarPartido
          ],
        ),
      ),
    );
  }
  //widget para apuntar el resultado de un partido
  Widget _buildResultadoInput() {
    return Column(
      children: [
        Row(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSetInput("Set 1", set1Controller),
            _buildSetInput("Set 2", set2Controller),
            _buildSetInput("Set 3 (opcional)", set3Controller)
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            guardarResultado();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Guardar Resultado"),
        ),
      ],
    );
  }
  //widget de los sets de los partidos
  Widget _buildSetInput(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Ej: 6-3",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJugador(String nombre, String imagenUsuario) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: widget.partido.creador.imagen.isNotEmpty ? MemoryImage(base64Decode(imagenUsuario)) : const NetworkImage("https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp") as ImageProvider,
            radius: 20,
          ),
          const SizedBox(width: 8),
          Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700])),
        ],
      ),
    );
  }
}
