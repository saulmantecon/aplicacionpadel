import 'package:aplicacionpadel/BD/DbPartido.dart';
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:flutter/material.dart';

class PartidoViewModel extends ChangeNotifier{
  List<Partido> listaPartidos = [];
  List<Map<String, dynamic>> listapartidosCreador = [];

  void cargarPartidos() async{
    listaPartidos = await DbPartido.partidos();
    notifyListeners();
  }

  void agregarPartido(Partido partido) {
    listaPartidos.add(partido);
    notifyListeners(); // Notifica a los widgets para que se redibujen
  }

  Future<Usuario?> getCreadorPartido(int idPartido)async{
    Usuario? usuario= await DbPartido.obtenerUsuarioCreadorPartido(idPartido);
    if(usuario!=null){
      return usuario;
    }else{
      return null;
    }
  }

}