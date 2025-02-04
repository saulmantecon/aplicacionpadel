import 'package:aplicacionpadel/model/Usuario.dart';

class Partido {
  int? idPartido;
  String lugar;
  String fecha;
  //Usuario creador;

  Partido(
      {this.idPartido,
      required this.lugar,
      required this.fecha,
     // required this.creador
  });

  Map<String, dynamic> toMap() {
    return {
      "idPartido": idPartido,
      "lugar": lugar,
      "fecha": fecha,
    };
  }

  // Método para crear un objeto 'Usuario' desde un Map (de la base de datos)
  factory Partido.fromMap(Map<String, dynamic> map) {
    return Partido(
      idPartido: map['idPartido'],
      lugar: map["lugar"],
      fecha: map["fecha"],
      //creador: map["creador"]
    );
  }

  @override
  String toString() {
    return 'Partido{idPartido: $idPartido, lugar: $lugar, fecha: $fecha}';
  }
}
