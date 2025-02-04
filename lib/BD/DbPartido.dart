import 'package:aplicacionpadel/model/Partido.dart';

import '../model/Usuario.dart';
import 'DbPadel.dart';

class DbPartido {
  // Método para insertar un partido en la base de datos
  static Future<void> insert(Partido partido) async {
    final db = await DbPadel.openDB();
    await db.insert("partidos", partido.toMap());
  } //insert

  // Método para obtener los partidos de la base de datos
  static Future<List<Partido>> partidos() async {
    final db = await DbPadel.openDB();

    // Obtener todos los partidos de la base de datos
    final List<Map<String, dynamic>> partidosMap = await db.query("partidos");

    List<Partido> listaPartidos = [];

    for (var partidoMap in partidosMap) {
      // Obtener el ID del creador
      int creadorId = partidoMap["creadorId"];

      // Buscar el usuario correspondiente en la tabla `usuarios`
      final List<Map<String, dynamic>> usuarioMap =
      await db.query("usuarios", where: "idUsuario = ?", whereArgs: [creadorId]);

      if (usuarioMap.isNotEmpty) {
        Usuario creador = Usuario.fromMap(usuarioMap.first);

        // Crear el objeto Partido con el creador ya cargado
        Partido partido = Partido(
          idPartido: partidoMap["idPartido"],
          lugar: partidoMap["lugar"],
          fecha: partidoMap["fecha"],
          creador: creador, // Pasamos el objeto completo
        );
        listaPartidos.add(partido);
      }
    }
    return listaPartidos;
  }


  // Método para eliminar un partido por su id
  static Future<void> delete(int idPartido) async {
    final db = await DbPadel.openDB();
    await db.delete("partidos", where: "idPartido = ?", whereArgs: [idPartido]);
  } //delete

  // Método para actualizar un partido
  static Future<void> update(Partido partido) async {
    final db = await DbPadel.openDB();
    await db.update(
      "partidos",
      partido.toMap(),
      where: "idPartido = ?",
      whereArgs: [partido.idPartido],
    );
  } //update
}
