import 'package:aplicacionpadel/BD/DbPadel.dart';
import '../model/Usuario.dart';

/// Clase para manejar las operaciones relacionadas con la tabla de usuarios.
class DbUsuario {
  /// Inserta un usuario en la base de datos.
  ///
  /// Recibe un objeto [Usuario] y lo guarda en la tabla `usuarios`.
  static Future<void> insert(Usuario usuario) async {
    final db = await DbPadel.openDB();
    await db.insert("usuarios", usuario.toMap());
  }

  /// Obtiene todos los usuarios de la base de datos.
  ///
  /// Retorna una lista de objetos [Usuario] creados a partir de los datos de la tabla `usuarios`.
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
  }

  /// Elimina un usuario de la base de datos por su ID.
  ///
  /// [idUsuario] es el identificador del usuario que se eliminará.
  static Future<void> delete(int idUsuario) async {
    final db = await DbPadel.openDB();
    await db.delete("usuarios", where: "idUsuario = ?", whereArgs: [idUsuario]);
  }

  /// Actualiza la información de un usuario en la base de datos.
  ///
  /// Recibe un objeto [Usuario] con los datos actualizados.
  static Future<void> update(Usuario usuario) async {
    final db = await DbPadel.openDB();
    await db.update(
      "usuarios",
      usuario.toMap(),
      where: "idUsuario = ?",
      whereArgs: [usuario.idUsuario],
    );
  }

  /// Busca un usuario por su nombre de usuario y contraseña para iniciar sesión.
  ///
  /// Retorna un objeto [Usuario] si las credenciales son correctas, o `null` si no hay coincidencias.
  static Future<Usuario?> getUsuarioLogin(
      String nombreUsuario, String contrasena) async {
    final db = await DbPadel.openDB();

    // Consulta para buscar al usuario con las credenciales proporcionadas.
    final List<Map<String, dynamic>> result = await db.query(
      "usuarios",
      where: "nombreUsuario = ? AND contrasena = ?",
      whereArgs: [nombreUsuario, contrasena],
      limit: 1, // Limita el resultado a 1 fila.
    );

    // Si hay resultados, crea un objeto Usuario, si no, retorna null.
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
      return null;
    }
  }
}
