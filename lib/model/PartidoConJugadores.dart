import 'package:aplicacionpadel/model/Usuario.dart';
/// Modelo que representa un partido jugado en la aplicación.
class PartidoConJugadores {
  final int idPartido;
  final String resultado;
  final Usuario jugador1;
  final Usuario jugador2;
  final Usuario jugador3;
  final Usuario jugador4;

  PartidoConJugadores({
    required this.idPartido,
    required this.resultado,
    required this.jugador1,
    required this.jugador2,
    required this.jugador3,
    required this.jugador4,
  });
}