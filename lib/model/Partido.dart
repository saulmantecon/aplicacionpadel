import 'package:aplicacionpadel/model/Usuario.dart';

class Partido {
  int idPartido;
  String lugar;
  DateTime fecha;
  int hora;


  Partido({required this.idPartido,
      required this.lugar,
      required this.fecha,
      required this.hora});

  Map<String, dynamic> toMap() {
    return {
      "idPartido": idPartido,
      "lugar": lugar,
      "fecha": fecha,
      "hora": hora,
    };
  }

  // Método para crear un objeto 'Usuario' desde un Map (de la base de datos)
  factory Partido.fromMap(Map<String, dynamic> map) {
    return Partido(
        idPartido: map['idPartido'],
        lugar: map["lugar"],
        fecha: map["fecha"],
        hora: map['hora']
    );
  }

  @override
  String toString() {
    return 'Partido{idPartido: $idPartido, lugar: $lugar, fecha: $fecha, hora: $hora}';
  }
}
