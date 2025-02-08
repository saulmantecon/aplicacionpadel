
import 'Usuario.dart';
/// Modelo que representa un partido en la aplicación.
class Partido {
  /// Identificador único del partido.
  int? idPartido;
  /// Lugar donde se juega el partido.
  String lugar;
  /// Fecha y hora del partido.
  String fecha;
  /// Usuario que creó el partido.
  Usuario creador;
  /// Indica si el partido ha finalizado o no.
  bool finalizado = false;
  /// Resultado del partido (puede ser nulo si no ha finalizado).
  String? resultado;

  Partido(
      {this.idPartido,
      required this.lugar,
      required this.fecha,
      required this.creador,
      required this.finalizado,
      this.resultado});


  /// Convierte la instancia de Partido en un mapa para su almacenamiento en base de datos.

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
  /// Convierte un valor booleano a un entero (0 para false, 1 para true).
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
