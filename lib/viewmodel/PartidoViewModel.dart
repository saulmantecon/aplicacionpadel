import 'package:aplicacionpadel/BD/DbPartido.dart';
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:flutter/material.dart';

class PartidoViewModel extends ChangeNotifier{
  List<Partido> listaPartidos = [];

  void cargarPartidos() async{
    listaPartidos = await DbPartido.partidos();
    notifyListeners();
  }

  void agregarPartido(Partido partido) {
    listaPartidos.add(partido);
    notifyListeners(); // Notifica a los widgets para que se redibujen
  }

}