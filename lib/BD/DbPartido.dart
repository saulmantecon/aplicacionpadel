
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../model/Usuario.dart';
import 'DbPadel.dart';
class DbPartido {

  // Método para insertar un usuario en la base de datos
  static Future<void> insert(Partido partido) async {
    final db = await DbPadel.openDB();
    await db.insert("partidos", partido.toMap());
  }//insert

  // Método para obtener los usuarios de la base de datos
  static Future<List<Partido>> partidos() async {
    final db = await DbPadel.openDB();
    final List<Map<String, dynamic>> partidosMap = await db.query("partidos");
    return List.generate(
      partidosMap.length,
          (i) => Partido(
        idPartido: partidosMap[i]["idPartido"],
        lugar: partidosMap[i]["lugar"],
        fecha: partidosMap[i]["fecha"],
        hora: partidosMap[i]["hora"]
    )
    );
  }//listarUsuarios

  // Método para eliminar un usuario por su id
  static Future<void> delete(int idPartido) async {
    final db = await DbPadel.openDB();
    await db.delete("partidos", where: "idPartido = ?", whereArgs: [idPartido]);
  }//delete

  // Método para actualizar un usuario
  static Future<void> update(Partido partido) async {
    final db = await DbPadel.openDB();
    await db.update(
      "partidos",
      partido.toMap(),
      where: "idPartido = ?",
      whereArgs: [partido.idPartido],
    );
  }//update
}

