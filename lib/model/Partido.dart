import 'package:aplicacionpadel/model/Usuario.dart';

class Partido{
  late int idPartido;
  late DateTime fecha;
  late int hora;
  late String nombreUsuario;

  Partido(this.fecha,this.hora,this.nombreUsuario);
}