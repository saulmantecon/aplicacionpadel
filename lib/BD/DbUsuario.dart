import 'dart:io';
import 'package:sqflite_common_ffi/windows/sqflite_ffi_setup.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../model/Usuario.dart';
class DbUsuario {
  // Inicializa la base de datos utilizando sqflite_common_ffi
  static Future<Database> _openDB() async {
    // Inicializa sqflite FFI
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;

    // Define la ruta de la base de datos
    final dbPath = join(await databaseFactory.getDatabasesPath(), "bdpadel");

    // Abre la base de datos (si no existe, la crea)
    final db = await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          onCreate: (db, version) {
            // Crear la tabla usuarios cuando la base de datos se crea por primera vez
            return db.execute(
                "CREATE TABLE usuarios (idUsuario INTEGER PRIMARY KEY AUTOINCREMENT, nombreUsuario TEXT UNIQUE, nombre TEXT, apellido TEXT, edad INTEGER, puntos INTEGER)");
          },
          version: 1, // Establece la versión de la base de datos
        ));

    return db;
  }//_openDB

  // Método para insertar un usuario en la base de datos
  static Future<void> insert(Usuario usuario) async {
    final db = await _openDB();
    await db.insert("usuarios", usuario.toMap());
  }//insert

  // Método para obtener los usuarios de la base de datos
  static Future<List<Usuario>> usuarios() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> usuariosMap = await db.query("usuarios");
    return List.generate(
      usuariosMap.length,
          (i) => Usuario(
            nombreUsuario: usuariosMap[i]["nombreUsuario"],
        idUsuario: usuariosMap[i]["idUsuario"],
        nombre: usuariosMap[i]["nombre"],
        apellido: usuariosMap[i]["apellido"],
        edad: usuariosMap[i]["edad"],
        puntos: usuariosMap[i]["puntos"],
      ),
    );
  }//listarUsuarios

  // Método para eliminar un usuario por su id
  static Future<void> delete(Usuario usuario) async {
    final db = await _openDB();
    await db.delete("usuarios", where: "idUsuario = ?", whereArgs: [usuario.idUsuario]);
  }//delete

  // Método para actualizar un usuario
  static Future<void> update(Usuario usuario) async {
    final db = await _openDB();
    await db.update(
      "usuarios",
      usuario.toMap(),
      where: "idUsuario = ?",
      whereArgs: [usuario.idUsuario],
    );
  }//update
}

