import 'package:flutter/material.dart';

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

  void enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
                  enviarFormulario();
                },
                child: const Icon(Icons.save_outlined),
              )
            ],
          )),
    );
  }
}
