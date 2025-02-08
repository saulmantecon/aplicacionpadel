import 'package:aplicacionpadel/BD/DbPadel.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/model/Usuario_Partido.dart';
import 'package:aplicacionpadel/model/PartidoConJugadores.dart';

/// Clase para gestionar la relación entre usuarios y partidos en la base de datos.
class DbUsuarioPartido {

  /// Inserta un usuario en un partido en la tabla `usuariopartidos`.
  static Future<void> insert(Usuario_Partido usuarioPartido) async {
    final db = await DbPadel.openDB();
    await db.insert("usuariopartidos", usuarioPartido.toMap());
  }

  /// Obtiene todos los partidos finalizados con sus jugadores.
  ///
  /// Devuelve una lista de [PartidoConJugadores] con la información de los jugadores de cada equipo.
  static Future<List<PartidoConJugadores>> partidosConJugadores() async {
    final db = await DbPadel.openDB();

    // Obtener todos los partidos finalizados
    final List<Map<String, dynamic>> partidosMap = await db.query(
      "partidos",
      where: "finalizado = ?",
      whereArgs: [1], // Solo partidos finalizados
    );

    List<PartidoConJugadores> partidosConJugadores = [];

    for (var partidoData in partidosMap) {
      int idPartido = partidoData["idPartido"];

      // Obtener los jugadores del equipo 1
      final List<Map<String, dynamic>> equipo1Data = await db.rawQuery("""
        SELECT u.* 
        FROM usuariopartidos up
        JOIN usuarios u ON up.idUsuario = u.idUsuario
        WHERE up.idPartido = ? AND up.equipo = 1
        LIMIT 2
      """, [idPartido]);

      // Obtener los jugadores del equipo 2
      final List<Map<String, dynamic>> equipo2Data = await db.rawQuery("""
        SELECT u.* 
        FROM usuariopartidos up
        JOIN usuarios u ON up.idUsuario = u.idUsuario
        WHERE up.idPartido = ? AND up.equipo = 2
        LIMIT 2
      """, [idPartido]);

      // Crear el objeto PartidoConJugadores y agregarlo a la lista
      partidosConJugadores.add(PartidoConJugadores(
        idPartido: idPartido,
        resultado: partidoData["resultado"],
        jugador1: Usuario.fromMap(equipo1Data[0]),
        jugador2: Usuario.fromMap(equipo1Data[1]),
        jugador3: Usuario.fromMap(equipo2Data[0]),
        jugador4: Usuario.fromMap(equipo2Data[1]),
      ));
    }
    return partidosConJugadores;
  }
}
