import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Partido.dart';
import '../model/Usuario.dart';
import '../viewmodel/PartidoViewModel.dart';
import '../viewmodel/UsuarioViewModel.dart';
import 'JugadorNoCreador.dart';

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
  Usuario? creador;

  @override
  void initState() {
    super.initState();
    _cargarCreador();
  }

  // 🔹 Método para obtener el usuario creador desde `PartidoViewModel`
  Future<void> _cargarCreador() async {
    final partidoViewModel = Provider.of<PartidoViewModel>(context, listen: false);
    Usuario? usuario = await partidoViewModel.getCreadorPartido(widget.partido.idPartido!);

    setState(() {
      creador = usuario;
    });
  }

  void toggleMostrarResultado() {
    setState(() {
      mostrarResultado = !mostrarResultado;
    });
  }

  void guardarResultado() async {
    String set1 = set1Controller.text.trim();
    String set2 = set2Controller.text.trim();
    String set3 = set3Controller.text.trim();

    if (set1.isEmpty || set2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes completar al menos 2 sets")),
      );
    } else {
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
        child: creador == null ? const Center(child: CircularProgressIndicator()) : Column( // Mostrar carga si el usuario aún no está listo
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
                    _buildJugadorCreador(creador!),
                    JugadorNoCreador(),
                  ],
                ),
                const Text("VS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
                Column(
                  children: [
                    JugadorNoCreador(),
                    JugadorNoCreador(),
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
            const SizedBox(height: 20),
            if (mostrarResultado) _buildResultadoInput(),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget para mostrar el jugador con su imagen
  Widget _buildJugadorCreador(Usuario usuario) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: usuario.imagen.isNotEmpty
                ? MemoryImage(base64Decode(usuario.imagen))
                : const NetworkImage("https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp") as ImageProvider,
            radius: 20,
          ),
          const SizedBox(width: 8),
          Text(usuario.nombreUsuario, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700])),
        ],
      ),
    );
  }


  // 🔹 Widget para ingresar el resultado del partido
  Widget _buildResultadoInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSetInput("Set 1", set1Controller),
            const SizedBox(width: 10),
            _buildSetInput("Set 2", set2Controller),
            const SizedBox(width: 10),
            _buildSetInput("Set 3 (opcional)", set3Controller)
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: guardarResultado,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Guardar Resultado"),
        ),
      ],
    );
  }

  // 🔹 Widget para ingresar un set
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
}
