import 'package:aplicacionpadel/model/Usuario.dart';

class Usuario_Partido {
  int idUsuario;
  int idPartido;
  Usuario? usuario1;
  Usuario? usuario2;
  Usuario? usuario3;
  Usuario? usuario4;

  Usuario_Partido({
    required this.idUsuario,
    required this.idPartido,
    required this.usuario1,
    required this.usuario2,
    required this.usuario3,
    required this.usuario4,
  });

  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "idPartido": idPartido,
      "nombreUsuario1": usuario1?.nombreUsuario,
      "nombreUsuario2": usuario2?.nombreUsuario,
      "nombreUsuario3": usuario3?.nombreUsuario,
      "nombreUsuario4": usuario3?.nombreUsuario,
    };
  }

  factory Usuario_Partido.fromMap(Map<String, dynamic> map){
  return Usuario_Partido(
  idUsuario: map["idUsuario"],
  idPartido: map["idPartido"],
  usuario1: map["usuario1"],
  usuario2: map["usuario2"],
  usuario3: map["usuario3"],
  usuario4: map["usuario4"]
  );

  }
}