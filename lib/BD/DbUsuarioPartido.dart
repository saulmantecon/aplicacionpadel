import 'package:aplicacionpadel/BD/DbPadel.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/model/Usuario_Partido.dart';

class DbUsuarioPartido {
  static Future<void> insert(Usuario_Partido usuarioPartido) async {
    final db = await DbPadel.openDB();
    await db.insert("usuariopartidos", usuarioPartido.toMap());
  }

  static Future<List<Usuario_Partido>> usuarioPartidos() async {
    final db = await DbPadel.openDB();
    final List<Map<String, dynamic>> usuarioPartidosMap = await db.query(
        "usuariopartidos");
    List<Usuario_Partido> listaUsuariosPartidos = [];

    for (var usuarioPartidoMap in usuarioPartidosMap) {
      String nombreusuario1 = usuarioPartidoMap["nombreusuario1"];
      String nombreusuario2 = usuarioPartidoMap["nombreusuario2"];
      String nombreusuario3 = usuarioPartidoMap["nombreusuario3"];
      String nombreusuario4 = usuarioPartidoMap["nombreusuario4"];

      final List<Map<String, dynamic>> usuario1Map = await db.query(
          "usuariopartidos", where: "nombreUsuario = ?",
          whereArgs: [nombreusuario1]);
      final List<Map<String, dynamic>> usuario2Map = await db.query(
          "usuariopartidos", where: "nombreUsuario = ?",
          whereArgs: [nombreusuario2]);
      final List<Map<String, dynamic>> usuario3Map = await db.query(
          "usuariopartidos", where: "nombreUsuario = ?",
          whereArgs: [nombreusuario3]);
      final List<Map<String, dynamic>> usuario4Map = await db.query(
          "usuariopartidos", where: "nombreUsuario = ?",
          whereArgs: [nombreusuario4]);

      Usuario usu1 = Usuario.fromMap(usuario1Map.first);
      Usuario usu2 = Usuario.fromMap(usuario2Map.first);
      Usuario usu3 = Usuario.fromMap(usuario3Map.first);
      Usuario usu4 = Usuario.fromMap(usuario4Map.first);

      Usuario_Partido usuarioPartido = Usuario_Partido(
          idUsuario: usuarioPartidoMap["idUsuario"],
          idPartido: usuarioPartidoMap["idPartido"]);

      listaUsuariosPartidos.add(usuarioPartido);
    }
    return listaUsuariosPartidos;
  }

  static Future<void> update (Usuario_Partido usuario_partido) async{
    final db = await DbPadel.openDB();
    await db.update(
        "usuariopartidos",
        usuario_partido.toMap(),
        where: "idUsuario = ? AND idPartido = ?",
        whereArgs: [usuario_partido.idUsuario, usuario_partido.idPartido]);
  }
}