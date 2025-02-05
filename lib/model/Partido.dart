import 'package:aplicacionpadel/model/Usuario.dart';

class Partido {
  int? idPartido;
  String lugar;
  String fecha;
  Usuario creador;
  bool finalizado = false;
  String? resultado;

  Partido(
      {this.idPartido,
      required this.lugar,
      required this.fecha,
      required this.creador,
      required this.finalizado,
      this.resultado});

  Map<String, dynamic> toMap() {
    return {
      "idPartido": idPartido,
      "lugar": lugar,
      "fecha": fecha,
      "creador": creador.nombreUsuario,
      "finalizado": bool2Int(finalizado), //false o true
      "resultado": resultado
    };
  }

  int bool2Int(bool bool) {
    int respuesta = 0;
    if (bool) {
      respuesta = 1;
    }
    return respuesta;
  }

  @override
  String toString() {
    return 'Partido{idPartido: $idPartido, lugar: $lugar, fecha: $fecha}';
  }
}
