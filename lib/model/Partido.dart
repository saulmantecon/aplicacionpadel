

class Partido {
  int? idPartido;
  String lugar;
  String fecha;
  bool finalizado = false;
  String? resultado;

  Partido(
      {this.idPartido,
      required this.lugar,
      required this.fecha,
      required this.finalizado,
      this.resultado});

  Map<String, dynamic> toMap() {
    return {
      "idPartido": idPartido,
      "lugar": lugar,
      "fecha": fecha,
      "finalizado": bool2Int(finalizado), //false o true
      "resultado": resultado
    };
  }

  // Método para crear un objeto 'partido' desde un Map (de la base de datos)
  factory Partido.fromMap(Map<String, dynamic> map) {
    return Partido(
      idPartido: map['idPartido'],
      lugar: map["lugar"],
      fecha: map["fecha"],
      finalizado: map["finalizado"],
      resultado: map["resultado"]
    );
  }

  int bool2Int(bool bool){
    int respuesta=0;
    if(bool){
      respuesta=1;
    }
    return respuesta;
  }

  @override
  String toString() {
    return 'Partido{idPartido: $idPartido, lugar: $lugar, fecha: $fecha}';
  }
}
