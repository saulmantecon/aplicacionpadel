import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/model/Usuario.dart';

import 'DbPadel.dart';

class DbPartido {
  // Método para insertar un partido en la base de datos
  static Future<int> insert(Partido partido) async {
    final db = await DbPadel.openDB();
    int id =await db.insert("partidos", partido.toMap());
    return id;
  } //insert

  static Future<List<Partido>> partidos() async {
    final db = await DbPadel.openDB();

    // Obtener todos los partidos de la base de datos
    final List<Map<String, dynamic>> partidosMap = await db.query("partidos");

    List<Partido> partidos = [];

    for (var partidoData in partidosMap) {
      // 🔹 Buscar el usuario en la tabla usuarios usando el nombreUsuario
      List<Map<String, dynamic>> usuarioMap = await db.query(
        "usuarios",
        where: "nombreUsuario = ?",
        whereArgs: [partidoData["creador"]],
      );

      Usuario creador = Usuario.fromMap(usuarioMap.first);

      // 🔹 Crear el objeto Partido con el usuario recuperado
      partidos.add(Partido(
        idPartido: partidoData["idPartido"],
        lugar: partidoData["lugar"],
        fecha: partidoData["fecha"],
        creador: creador, // Aquí asignamos el objeto Usuario
        finalizado: (partidoData["finalizado"] ?? 0) == 1,
        resultado: partidoData["resultado"],
      ));
    }

    return partidos;
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
