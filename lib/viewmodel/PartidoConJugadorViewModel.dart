import 'package:aplicacionpadel/BD/DbUsuarioPartido.dart';
import 'package:aplicacionpadel/model/PartidoConJugadores.dart';
import 'package:flutter/material.dart';

/// Clase Viewmodel de PartidoConJugadores
/// Guarda una lista personalziada necesaria para hacer el historial de partidos jugados.
class PartidoConJugadoresViewModel extends ChangeNotifier{
  List<PartidoConJugadores> listaPartido= [];


  void cargarPartidosConJugadores() async{
    listaPartido = await DbUsuarioPartido.partidosConJugadores();
    notifyListeners();
  }
}