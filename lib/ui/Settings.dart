import 'package:aplicacionpadel/CRUDusuarioView//CrearUsuario.dart';
import 'package:aplicacionpadel/CRUDusuarioView//EliminarUsuario.dart';
import 'package:aplicacionpadel/CRUDusuarioView//ModificarUsuario.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Clase que representa la pantalla de configuración de usuarios.
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Controla la visibilidad del formulario
  bool _showCrearUsuarioForm = false;
  bool _showModificarUsuarioForm = false;
  bool _showEliminarUsuarioForm = false;
  /// Alterna la visibilidad del formulario de creación de usuario.
  void _toggleCrearUsuarioForm() {
    setState(() {
      _showCrearUsuarioForm = !_showCrearUsuarioForm;
    });
  }
  /// Alterna la visibilidad del formulario de modificación de usuario.
  void _toggleModificarUsuarioForm() {
    setState(() {
      _showModificarUsuarioForm = !_showModificarUsuarioForm;
    });
  }
  /// Alterna la visibilidad del formulario de eliminación de usuario.
  void _toggleEliminarUsuarioForm() {
    setState(() {
      _showEliminarUsuarioForm = !_showEliminarUsuarioForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            if(usuarioVM.usuarioActual?.nombreUsuario=="admin")
              ElevatedButton(
                onPressed: _toggleCrearUsuarioForm,
                // Muestra/oculta el formulario
                child: const Text("Crear usuario"),
              ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: (_toggleModificarUsuarioForm),
              child: const Text("Modificar usuario"),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: (_toggleEliminarUsuarioForm),
              child: const Text("Eliminar usuario"),
            ),
            const SizedBox(height: 50),
            // Aquí se muestra el formulario si _showCrearUsuarioForm es true
            if (_showCrearUsuarioForm)
              const CrearUsuario(), // Instancia de tu formulario
            const SizedBox(height: 50),
            if (_showModificarUsuarioForm)
              const ModificarUsuario(), // Instancia de tu formulario
            const SizedBox(height: 50),
            if (_showEliminarUsuarioForm)
              const EliminarUsuario(), // Instancia de tu formulario
            const SizedBox(height: 50),
          ],
        ),
      )),
    );
  }
}
