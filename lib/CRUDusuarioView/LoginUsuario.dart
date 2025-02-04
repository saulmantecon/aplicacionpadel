import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loginusuario extends StatefulWidget {
  const Loginusuario({super.key});

  @override
  State<Loginusuario> createState() => _LoginusuarioState();
}

class _LoginusuarioState extends State<Loginusuario> {
  final _formKey = GlobalKey<FormState>(); //clave para el formulario
  bool _obscureText = true;
  String? nombreUsuario;
  String? contrasena;

  void enviarFormulario(BuildContext context) async {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Usuario? usuario =
            await DbUsuario.getUsuarioLogin(nombreUsuario!, contrasena!);
        if (usuario != null) {
          usuarioVM.usuarioActual = usuario;
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Login correcto')));
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
            const SnackBar(content: Text('Error al logear el usuario')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio de sesion"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Introduce un nombre de usuario",
                      hintText: "Nombre de usuario"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Introduzca un nombre de usuario correcto";
                    }
                    return null;
                  },
                  onSaved: (value) => nombreUsuario = value),
              TextFormField(
                obscureText: _obscureText,
                // Esto oculta el texto ingresado (se muestra como puntos o asteriscos)
                decoration: InputDecoration(
                  labelText: 'Contraseña', // Etiqueta para el campo
                  hintText: 'Ingresa tu contraseña', // Texto de ayuda
                  suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Cambia el valor de obscureText
                        });
                      } // Icono que puede cambiar para mostrar/ocultar la contraseña
                      ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduzca un nombre de usuario correcto";
                  }
                  return null;
                },
                onSaved: (value) => contrasena = value,
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  enviarFormulario(context);
                },
                child: const Icon(Icons.save_outlined),
              )
            ],
          )),
    );
  }
}
