import 'dart:ffi';
import 'dart:io';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/util/ProductImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplicacionpadel/BD/DbUsuario.dart';

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  String? nombreUsuario;
  String? nombre;
  String? apellido;
  int? edad;

  final _formKey = GlobalKey<FormState>(); //clave para el formulario
  String? pickedFilePath; //almacenar url de foto
  void enviarFormulario() async {
    if (_formKey.currentState!.validate() && pickedFilePath!=null && pickedFilePath!.isNotEmpty) {
      _formKey.currentState!.save(); // Guarda los valores en las variables

      Usuario usuario = Usuario(
        idUsuario: 0,
        nombreUsuario: nombreUsuario!,
        nombre: nombre!,
        apellido: apellido!,
        edad: edad!,
        puntos: 0,
      );


      try {

        // Intentamos insertar el usuario en la base de datos
        await DbUsuario.insert(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
        );
        // Reiniciar el formulario después de guardar
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el usuario')),
        );
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
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Introduce un nombre de usuario", hintText: "Nombre de usuario"),
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
          Stack(
            children: [
              ProductImage(urlPath: pickedFilePath),
              /*Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.black)
              ),
               */
              Positioned(
                  top: 65,
                  right: 25,
                  child: IconButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality:
                                100); //imageSource.gallery para galeria y .camera para la camera
                        if (pickedFile!=null){
                          setState(() {
                            pickedFilePath = pickedFile!.path;
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      color: Colors.black))
            ],
          ),
          const SizedBox(height: 100),
          FloatingActionButton(
            onPressed: () {
              enviarFormulario();
            },
            child: const Icon(Icons.save_outlined),
          )
        ],
      ),
    );
  }
}
