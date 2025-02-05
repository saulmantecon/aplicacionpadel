import 'package:aplicacionpadel/model/Partido.dart';

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

    return List.generate(
        partidosMap.length,
        (i) => Partido(
            idPartido: partidosMap[i]["idPartido"],
            lugar: partidosMap[i]["contrasena"],
            fecha: partidosMap[i]["fecha"],
            finalizado: partidosMap[i]["finalizado"],
            resultado: partidosMap[i]["resultado"]),
    );
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
