import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

/// Clase para manejar la base de datos de la aplicación.
///
/// Esta clase se encarga de abrir la base de datos y crear las tablas necesarias 
/// (`usuarios`, `partidos`, `usuariopartidos`) si no existen.
class DbPadel {
  /// Abre la base de datos de la aplicación.
  ///
  /// Si no existe, la crea con las tablas necesarias:
  /// - `usuarios`: Almacena información de los usuarios.
  /// - `partidos`: Almacena información de los partidos.
  /// - `usuariopartidos`: Relaciona usuarios con partidos.
  ///
  /// Retorna la base de datos lista para usar.
  static Future<Database> openDB() async {
    // Inicializa sqflite para plataformas como Windows.
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;

    // Define la ruta de la base de datos.
    final dbPath = join(await databaseFactory.getDatabasesPath(), "bdpadel");

    // Abre o crea la base de datos.
    final db = await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          onCreate: (db, version) {
            // Crea la tabla de usuarios.
            db.execute(
                "CREATE TABLE usuarios (idUsuario INTEGER PRIMARY KEY AUTOINCREMENT, nombreUsuario TEXT UNIQUE, contrasena TEXT, nombre TEXT, apellido TEXT, edad INTEGER, puntos INTEGER, imagen TEXT)");

            // Crea la tabla de partidos.
            db.execute(
                "CREATE TABLE partidos (idPartido INTEGER PRIMARY KEY AUTOINCREMENT, lugar TEXT, fecha TEXT, creador TEXT, finalizado INTEGER, resultado TEXT)");

            // Crea la tabla para relacionar usuarios y partidos.
            db.execute(
                "CREATE TABLE usuariopartidos (idUsuario INTEGER NOT NULL, idPartido INTEGER NOT NULL, equipo INTEGER NOT NULL, PRIMARY KEY (idUsuario, idPartido), FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario), FOREIGN KEY (idPartido) REFERENCES partidos(idPartido))");
          },
          version: 1,
        ));

    return db;
  }
}
