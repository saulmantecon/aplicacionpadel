
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
class DbPadel {
  // Inicializa la base de datos utilizando sqflite_common_ffi
  static Future<Database> openDB() async {
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
            db.execute(
                "CREATE TABLE usuarios (idUsuario INTEGER PRIMARY KEY AUTOINCREMENT, nombreUsuario TEXT UNIQUE, contrasena TEXT, nombre TEXT, apellido TEXT, edad INTEGER, puntos INTEGER, imagen TEXT)");
          db.execute(
                "CREATE TABLE partidos (idPartido INTEGER PRIMARY KEY AUTOINCREMENT, lugar TEXT, fecha TEXT, creadorId INTEGER NOT NULL,FOREIGN KEY (creadorId) REFERENCES Usuario(idUsuario) ON DELETE CASCADE)");
          },
          version: 1, // Establece la versión de la base de datos
        ));

    return db;
  } //_openDB
}