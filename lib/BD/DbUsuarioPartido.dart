import 'package:aplicacionpadel/BD/DbPadel.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/model/Usuario_Partido.dart';

class DbUsuarioPartido {
  static Future<void> insert(Usuario_Partido usuarioPartido) async {
    final db = await DbPadel.openDB();
    await db.insert("usuariopartidos", usuarioPartido.toMap());
  }

}