import 'package:aplicacionpadel/CRUD/ModificarUsuario.dart';
import 'package:flutter/material.dart';
import 'package:aplicacionpadel/CRUD/CrearUsuario.dart';
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _showCrearUsuarioForm = false;// Controla la visibilidad del formulario
  bool _showModificarUsuarioForm = false;

  void _toggleCrearUsuarioForm() {
    setState(() {
      _showCrearUsuarioForm = !_showCrearUsuarioForm;
    });
  }

  void _toggleModificarUsuarioForm() {
    setState(() {
      _showModificarUsuarioForm = !_showModificarUsuarioForm;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _toggleCrearUsuarioForm, // Muestra/oculta el formulario
                child: const Text("Crear usuario"),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: (_toggleModificarUsuarioForm),
                child: const Text("Modificar usuario"),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {},
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
            ],
          ),
        )
      ),
    );
  }
}
