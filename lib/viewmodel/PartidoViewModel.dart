import 'package:aplicacionpadel/BD/DbPartido.dart';
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:flutter/material.dart';

/// Clase Viewmodel de partido.
class PartidoViewModel extends ChangeNotifier{
  List<Partido> listaPartidos = [];

  ///carga los partidos de la base de datos.
  void cargarPartidos() async{
    listaPartidos = await DbPartido.partidos();
    notifyListeners();
  }
  ///Agrega un partido a la lista creada en el viewmodel.
  void agregarPartido(Partido partido) {
    listaPartidos.add(partido);
    notifyListeners(); // Notifica a los widgets para que se redibujen
  }
  /// Finaliza un partido, actualiza su estado en la base de datos y determina el equipo ganador.
  ///
  /// Parámetros:
  /// - `idPartido`: Identificador del partido a finalizar.
  /// - `resultado`: Marcador final del partido en formato de sets.
  void finalizarPartido(int idPartido, String resultado) async {
    bool partidoEncontrado = false;

    // Obtener los jugadores por equipo desde la BD
    List<int> equipo1 = await DbPartido.obtenerJugadoresPorEquipo(idPartido, 1);
    List<int> equipo2 = await DbPartido.obtenerJugadoresPorEquipo(idPartido, 2);

    for (var partido in listaPartidos) {
      if (partido.idPartido == idPartido) {
        partido.finalizado = true;
        partido.resultado = resultado;
        partidoEncontrado = true;
        break;
      }
    }

    if (partidoEncontrado) {
      // Determinar los ganadores
      List<int> ganadores = determinarGanador(resultado, equipo1, equipo2);

      // Actualizar la BD
      await DbPartido.finalizarPartido(idPartido, resultado, ganadores[0], ganadores[1]);
      notifyListeners();
    }
  }

  /// Determina el equipo ganador basado en los sets ganados.
  ///
  /// Parámetros:
  /// - `resultado`: Resultado del partido en formato de sets.
  /// - `equipo1`: Lista de IDs de jugadores del equipo 1.
  /// - `equipo2`: Lista de IDs de jugadores del equipo 2.
  ///
  /// Retorna:
  /// - Una lista de IDs de jugadores del equipo ganador.
  List<int> determinarGanador(String resultado, List<int> equipo1, List<int> equipo2) {
    List<String> sets = resultado.split(","); // 🔹 Divide el string en sets individuales
    int setsGanadosEquipo1 = 0;
    int setsGanadosEquipo2 = 0;

    for (String set in sets) {
      List<String> puntuaciones = set.trim().split("-"); // 🔹 Divide los números
      if (puntuaciones.length == 2) {
        int puntosEquipo1 = int.parse(puntuaciones[0]); // 🔹 Puntos del equipo 1
        int puntosEquipo2 = int.parse(puntuaciones[1]); // 🔹 Puntos del equipo 2

        if (puntosEquipo1 > puntosEquipo2) {
          setsGanadosEquipo1++; //Equipo 1 gana este set
        } else {
          setsGanadosEquipo2++; //Equipo 2 gana este set
        }

        // 🔹 Si un equipo gana 2 sets, ya es el ganador
        if (setsGanadosEquipo1 == 2) {
          return equipo1; //Gana equipo 1
        } else if (setsGanadosEquipo2 == 2) {
          return equipo2; //Gana equipo 2
        }
      }
    }

    //Si el partido llegó hasta el tercer set, el equipo con más sets ganados es el ganador
    return (setsGanadosEquipo1 > setsGanadosEquipo2) ? equipo1 : equipo2;
  }




}