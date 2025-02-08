import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Usuario.dart';
import '../viewmodel/PartidoConJugadorViewModel.dart';

/// Clase que representa la pantalla del historial de partidos.
class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      // Cargar los partidos finalizados al iniciar la pantalla
      Provider.of<PartidoConJugadoresViewModel>(context, listen: false)
          .cargarPartidosConJugadores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final partidoVM = Provider.of<PartidoConJugadoresViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Partidos"),
      ),
      body: partidoVM.listaPartido.isEmpty
          ? const Center(child: Text("No hay partidos finalizados aún."))
          : ListView.builder(
        itemCount: partidoVM.listaPartido.length,
        itemBuilder: (context, index) {
          final partido = partidoVM.listaPartido[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Partido Nº: ${partido.idPartido}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Resultado: ${partido.resultado}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Equipo 1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPlayerRow(partido.jugador1),
                          const SizedBox(height: 8),
                          _buildPlayerRow(partido.jugador2),
                        ],
                      ),
                      const Center(
                        child: Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      // Equipo 2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPlayerRow(partido.jugador3),
                          const SizedBox(height: 8),
                          _buildPlayerRow(partido.jugador4),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget que genera una fila con ícono y nombre del jugador.
  Widget _buildPlayerRow(Usuario jugador) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: jugador.imagen.isNotEmpty
              ? MemoryImage(base64Decode(jugador.imagen))
              : const NetworkImage(
              "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp")
          as ImageProvider,
        ),
        const SizedBox(width: 8),
        Text(
          jugador.nombreUsuario,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
