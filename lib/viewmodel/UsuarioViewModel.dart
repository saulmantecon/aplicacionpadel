import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:flutter/material.dart';

class UsuarioViewModel extends ChangeNotifier{
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  set usuarioActual(Usuario? value) {
    _usuarioActual = value;
    notifyListeners();
  }
}
