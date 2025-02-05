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
            creador: partidosMap[i]["creador"],
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

  static Future<Usuario?> obtenerUsuarioCreadorPartido(int idPartido) async {
    final db = await DbPadel.openDB();

    List<Map<String, dynamic>> resultado = await db.rawQuery(
        '''
    SELECT u.* 
    FROM partidos p
    JOIN usuarios u ON p.creador = u.nombreUsuario
    WHERE p.idPartido = ?
    ''',
        [idPartido]
    );

    if (resultado.isNotEmpty){
      return Usuario(
        nombreUsuario: resultado[0]["nombreUsuario"],
        contrasena: resultado[0]["contrasena"],
        idUsuario: resultado[0]["idUsuario"],
        nombre: resultado[0]["nombre"],
        apellido: resultado[0]["apellido"],
        edad: resultado[0]["edad"],
        puntos: resultado[0]["puntos"],
        imagen: resultado[0]["imagen"],
      );
    }else{
      return null;
    }
  }



}
