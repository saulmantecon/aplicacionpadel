import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/CRUDusuarioView/CrearUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Clase  que representa la pantalla de inicio de sesión de un usuario.
class Loginusuario extends StatefulWidget {
  const Loginusuario({super.key});

  @override
  State<Loginusuario> createState() => _LoginusuarioState();
}

class _LoginusuarioState extends State<Loginusuario> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? nombreUsuario;
  String? contrasena;
  bool _showCrearUsuarioForm = false;

  /// Alterna la visibilidad del formulario de creación de usuario.
  void _toggleCrearUsuarioForm() {
    setState(() {
      _showCrearUsuarioForm = !_showCrearUsuarioForm;
    });
  }

  /// Valida el formulario e intenta iniciar sesión con los datos ingresados.
  void enviarFormulario(BuildContext context) async {
    final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
    usuarioVM.cargarUsuarios();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Usuario? usuario = await DbUsuario.getUsuarioLogin(nombreUsuario!, contrasena!);
        if (usuario != null) {
          usuarioVM.usuarioActual = usuario;
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, "/BottomNavigation");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login correcto')));
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login incorrecto')));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al iniciar sesión')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    Text(
                      "Inicio de Sesión",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // Campo de nombre de usuario
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombre de usuario",
                        hintText: "Introduce tu nombre de usuario",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, introduce tu nombre de usuario";
                        }
                        return null;
                      },
                      onSaved: (value) => nombreUsuario = value,
                    ),
                    const SizedBox(height: 16),
                    // Campo de contraseña
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        hintText: "Introduce tu contraseña",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, introduce tu contraseña";
                        }
                        return null;
                      },
                      onSaved: (value) => contrasena = value,
                    ),
                    const SizedBox(height: 20),
                    /// Botón para iniciar sesión.
                    ElevatedButton(
                      onPressed: () => enviarFormulario(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.login),
                          SizedBox(width: 10),
                          Text("Iniciar sesión"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    /// Botón para mostrar el formulario de creación de usuario.
                    TextButton(
                      onPressed: _toggleCrearUsuarioForm,
                      child: const Text("¿No tienes una cuenta? Regístrate aquí"),
                    ),
                    if (_showCrearUsuarioForm) CrearUsuario()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
