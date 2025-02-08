import 'package:aplicacionpadel/BD/DbPartido.dart';
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
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
  void finalizarPartido(int idPartido, String resultado, int idGanador1, int idGanador2) async {
    bool partidoEncontrado = false;

    for (var partido in listaPartidos) {
      if (partido.idPartido == idPartido) {
        partido.finalizado = true;
        partido.resultado = resultado;
        partidoEncontrado = true;
        break;
      }
    }

    if (partidoEncontrado) {
      await DbPartido.finalizarPartido(idPartido, resultado, idGanador1, idGanador2);
      notifyListeners(); //Solo notificamos si hubo un cambio
    }
  }



}