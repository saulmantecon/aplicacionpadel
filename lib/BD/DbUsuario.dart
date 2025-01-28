import 'package:aplicacionpadel/BD/DbPadel.dart';

import '../model/Usuario.dart';

class DbUsuario {
  // Inicializa la base de datos utilizando sqflite_common_ffi

  // Método para insertar un usuario en la base de datos
  static Future<void> insert(Usuario usuario) async {
    final db = await DbPadel.openDB();
    await db.insert("usuarios", usuario.toMap());
  } //insert

  // Método para obtener los usuarios de la base de datos
  static Future<List<Usuario>> usuarios() async {
    final db = await DbPadel.openDB();
    final List<Map<String, dynamic>> usuariosMap = await db.query("usuarios");
    return List.generate(
      usuariosMap.length,
      (i) => Usuario(
        nombreUsuario: usuariosMap[i]["nombreUsuario"],
        contrasena: usuariosMap[i]["contrasena"],
        idUsuario: usuariosMap[i]["idUsuario"],
        nombre: usuariosMap[i]["nombre"],
        apellido: usuariosMap[i]["apellido"],
        edad: usuariosMap[i]["edad"],
        puntos: usuariosMap[i]["puntos"],
        imagen: usuariosMap[i]["imagen"],
      ),
    );
  } //listarUsuarios

  // Método para eliminar un usuario por su id
  static Future<void> delete(int idUsuario) async {
    final db = await DbPadel.openDB();
    await db.delete("usuarios", where: "idUsuario = ?", whereArgs: [idUsuario]);
  } //delete

  // Método para actualizar un usuario
  static Future<void> update(Usuario usuario) async {
    final db = await DbPadel.openDB();
    await db.update(
      "usuarios",
      usuario.toMap(),
      where: "idUsuario = ?",
      whereArgs: [usuario.idUsuario],
    );
  } //update

  static Future<Usuario?> getUsuarioLogin(String nombreUsuario, String contrasena) async {
    final db = await DbPadel.openDB();
    // Consulta la base de datos para encontrar el usuario con el nombre de usuario y la contraseña proporcionados
    final List<Map<String, dynamic>> result = await db.query(
      "usuarios",
      where: "nombreUsuario = ? AND contrasena = ?",
      // Condición para filtrar por nombre de usuario y contraseña
      whereArgs: [nombreUsuario, contrasena],
      limit: 1 //limite de filas
    );

    // Si encontramos un usuario, lo devolvemos, de lo contrario, retornamos null
    if (result.isNotEmpty) {
      return Usuario(
        nombreUsuario: result[0]["nombreUsuario"],
        contrasena: result[0]["contrasena"],
        idUsuario: result[0]["idUsuario"],
        nombre: result[0]["nombre"],
        apellido: result[0]["apellido"],
        edad: result[0]["edad"],
        puntos: result[0]["puntos"],
        imagen: result[0]["imagen"],
      );
    } else {
      return null; // Retorna null si no se encuentra un usuario con esas credenciales
    }
  }
}
