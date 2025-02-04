import 'dart:convert';

import 'package:aplicacionpadel/model/Partido.dart';
import 'package:flutter/material.dart';

class Containerpartido extends StatelessWidget {
  final Partido partido;
  const Containerpartido({super.key, required this.partido});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 100,
        width: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Evita que la columna intente expandirse demasiado
          children: [
            // Lugar y Fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    partido.lugar,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Evita desbordamiento del texto
                  ),
                ),
                const SizedBox(width: 10), // Espaciado entre los textos
                Expanded(
                  child: Text(
                    partido.fecha,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // Jugadores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _buildJugador(partido.creador.nombreUsuario, partido.creador.imagen),
                    _buildJugador("Jugador", partido.creador.imagen),
                  ],
                ),
                const Text(
                  "VS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                Column(
                  children: [
                    _buildJugador("Jugador", partido.creador.imagen),
                    _buildJugador("Jugador", partido.creador.imagen),
                  ],
                ),
              ],
            ),
            // Botón de Fijar Partido
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "Fijar partido",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJugador(String nombre, String imagenUsuario) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Evita que se expanda más de lo necesario
        children: [
          CircleAvatar(
            backgroundImage: partido.creador.imagen.isNotEmpty
                ? MemoryImage(base64Decode(imagenUsuario))
                : const NetworkImage("https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp") as ImageProvider, // Imagen por defecto
            radius: 20,
          ),
          const SizedBox(width: 16),
          Text(
            nombre,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
    );
  }
}
