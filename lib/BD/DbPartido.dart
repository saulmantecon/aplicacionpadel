import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'DbPadel.dart';

/// Clase para manejar los partidos en la base de datos.
class DbPartido {
  /// Inserta un partido en la base de datos.
  ///
  /// Retorna el ID del partido insertado.
  static Future<int> insert(Partido partido) async {
    final db = await DbPadel.openDB();
    int id = await db.insert("partidos", partido.toMap());
    return id;
  }

  /// Obtiene todos los partidos de la base de datos.
  ///
  /// Retorna una lista de objetos `Partido`, cada uno con su creador asociado.
  static Future<List<Partido>> partidos() async {
    final db = await DbPadel.openDB();

    // Consulta para obtener todos los partidos.
    final List<Map<String, dynamic>> partidosMap = await db.query("partidos");

    List<Partido> partidos = [];

    for (var partidoData in partidosMap) {
      // Busca el usuario creador del partido en la tabla `usuarios`.
      List<Map<String, dynamic>> usuarioMap = await db.query(
        "usuarios",
        where: "nombreUsuario = ?",
        whereArgs: [partidoData["creador"]],
      );

      Usuario creador = Usuario.fromMap(usuarioMap.first);

      // Crea el objeto Partido con el usuario recuperado.
      partidos.add(Partido(
        idPartido: partidoData["idPartido"],
        lugar: partidoData["lugar"],
        fecha: partidoData["fecha"],
        creador: creador,
        finalizado: (partidoData["finalizado"] ?? 0) == 1,
        resultado: partidoData["resultado"],
      ));
    }
    return partidos;
  }

  /// Elimina un partido de la base de datos por su ID.
  static Future<void> delete(int idPartido) async {
    final db = await DbPadel.openDB();
    await db.delete("partidos", where: "idPartido = ?", whereArgs: [idPartido]);
  }

  /// Marca un partido como finalizado y actualiza los puntos de los ganadores.
  ///
  /// Actualiza el campo `finalizado` y agrega el resultado del partido.
  /// Suma 3 puntos a los dos jugadores ganadores.
  static Future<void> finalizarPartido(
      int idPartido, String resultado, int idGanador1, int idGanador2) async {
    final db = await DbPadel.openDB();

    // Actualiza el estado del partido.
    await db.update(
      "partidos",
      {"finalizado": 1, "resultado": resultado},
      where: "idPartido = ?",
      whereArgs: [idPartido],
    );

    // Suma puntos a los ganadores.
    await db.rawUpdate(
        "UPDATE usuarios SET puntos = puntos + 3 WHERE idUsuario = ?", [idGanador1]);
    await db.rawUpdate(
        "UPDATE usuarios SET puntos = puntos + 3 WHERE idUsuario = ?", [idGanador2]);
  }

  /// Obtiene los IDs de los jugadores de un equipo en un partido.
  ///
  /// Recibe el ID del partido y el número del equipo.
  /// Retorna una lista con los IDs de los jugadores.
  static Future<List<int>> obtenerJugadoresPorEquipo(
      int idPartido, int equipo) async {
    final db = await DbPadel.openDB();
    final resultados = await db.query(
      "usuariopartidos",
      columns: ["idUsuario"],
      where: "idPartido = ? AND equipo = ?",
      whereArgs: [idPartido, equipo],
    );
    return resultados.map((fila) => fila["idUsuario"] as int).toList();
  }
}
