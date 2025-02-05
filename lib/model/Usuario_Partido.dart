import 'package:aplicacionpadel/model/Usuario.dart';

class Usuario_Partido {
  int idUsuario;
  int idPartido;

  Usuario_Partido({
    required this.idUsuario,
    required this.idPartido,
  });

  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "idPartido": idPartido,
    };
  }

  factory Usuario_Partido.fromMap(Map<String, dynamic> map) {
    return Usuario_Partido(
        idUsuario: map["idUsuario"],
        idPartido: map["idPartido"],
    );
  }
}
