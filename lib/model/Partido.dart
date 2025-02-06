import 'package:aplicacionpadel/model/Usuario.dart';

class Partido {
  int? idPartido;
  String lugar;
  String fecha;
  String creador;
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
      "creador": creador,
      "finalizado": finalizado, //false o true
      "resultado": resultado
    };
  }

  @override
  String toString() {
    return 'Partido{idPartido: $idPartido, lugar: $lugar, fecha: $fecha}';
  }
}
