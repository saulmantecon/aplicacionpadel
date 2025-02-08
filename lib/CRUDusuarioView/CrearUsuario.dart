import 'dart:convert';
import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/util/ProductImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


///Clase que representa la pantalla para crear un usuario.
class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  String? nombreUsuario;
  String? contrasena;
  String? nombre;
  String? apellido;
  int? edad;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>(); //clave para el formulario
  String? pickedFilePath; //almacenar url de foto


  /// Valida el formulario y registra un nuevo usuario en la base de datos.
  ///
  /// - Si la validación es exitosa, se guarda el usuario y se muestra un mensaje de éxito.
  /// - En caso de error, se muestra un mensaje informativo en la interfaz.
  void enviarFormulario() async {
    if (_formKey.currentState!.validate() &&
        pickedFilePath != null &&
        pickedFilePath!.isNotEmpty) {
      _formKey.currentState!.save(); // Guarda los valores en las variables

      Usuario usuario = Usuario(
          nombreUsuario: nombreUsuario!,
          contrasena: contrasena!,
          nombre: nombre!,
          apellido: apellido!,
          edad: edad!,
          puntos: 0,
          imagen: pickedFilePath!);

      try {
        // Intenta insertar el usuario en la base de datos
        await DbUsuario.insert(usuario);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrado exitosamente')),
          );
        }
        // Reiniciar el formulario después de guardar
        _formKey.currentState!.reset();
        setState(() {
          pickedFilePath = null;
        });
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar el usuario')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellene todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              /// TextFormfield para el nombre de usuario.
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
                onSaved: (value) {
                  nombreUsuario = value;
                },
              ),
              ///Textformfield para la contraseña con opción de visualización.
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
              /// TextformField para el nombre del usuario.
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Introduce un nombre", hintText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduzca un nombre correcto";
                  }
                  return null;
                },
                onSaved: (value) {
                  nombre = value;
                },
              ),
              /// TextformField para el apellido del usuario.
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Introduce tu apellido", hintText: "Apellido"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduzca un apellido correcto";
                  }
                  return null;
                },
                onSaved: (value) {
                  apellido = value;
                },
              ),
              /// TextformField para la edad del usuario.
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Introduce tu edad", hintText: "Edad"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduzca una edad correcta";
                  }
                  return null;
                },
                onSaved: (value) {
                  edad = int.tryParse(value ?? '') ??
                      0; // Aquí intentamos parsear a int, y si no es válido, asignamos 0
                },
              ),
              ///Stack donde se podrá introducir una imagen de perfil de usuario.
              Stack(
                children: [
                  ProductImage(urlPath: pickedFilePath),
                  Positioned(
                      top: 50,
                      right: 25,
                      child: IconButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final XFile? pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality:
                                    50); //imageSource.gallery para galeria y .camera para la camera
                            if (pickedFile != null) {
                              final bytes = await pickedFile.readAsBytes();
                              setState(() {
                                pickedFilePath = base64Encode(
                                    bytes); // Convertimos la imagen a Base64
                              });
                            }
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          color: Colors.black)
                  )
                ],
              ),
              const SizedBox(height: 100),
              /// FloatingActionButton para enviar el formulario y registrar el usuario.
              FloatingActionButton(
                onPressed: () {
                  enviarFormulario();
                },
                child: const Icon(Icons.save_outlined),
              )
            ],
          ),
        ));
  }
}
