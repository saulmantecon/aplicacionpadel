import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:flutter/material.dart';

/// ViewModel que gestiona el estado de los usuarios en la aplicación.
class UsuarioViewModel extends ChangeNotifier{
  /// Usuario actualmente logeado en la aplicación.
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  /// Establece el usuario actual y notifica a los listeners.
  set usuarioActual(Usuario? value) {
    _usuarioActual = value;
    notifyListeners();
  }
  /// Lista de usuarios cargados desde la base de datos.
  List<Usuario> listaUsuarios =[];

  /// Carga la lista de usuarios desde la base de datos y notifica cambios.
  Future<void> cargarUsuarios() async{
    listaUsuarios = await DbUsuario.usuarios();
    notifyListeners();
  }
}
