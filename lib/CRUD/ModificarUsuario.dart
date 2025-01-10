import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/util/ProductImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplicacionpadel/model/Usuario.dart';

class ModificarUsuario extends StatefulWidget {
  const ModificarUsuario({super.key});

  @override
  State<ModificarUsuario> createState() => _ModificarUsuarioState();
}

class _ModificarUsuarioState extends State<ModificarUsuario> {
  String? nombreUsuario;
  String? nombre;
  String? apellido;
  int? edad;
  List<Usuario> listaUsuarios = [];
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  String? pickedFilePath; // Almacenar URL de foto
  final _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  Future<void> obtenerUsuarios() async {
    final usuarios = await DbUsuario.usuarios();
    setState(() {
      listaUsuarios = usuarios;
    });
  }

  void enviarFormulario() async {
    if (_formKey.currentState!.validate() &&
        pickedFilePath != null &&
        pickedFilePath!.isNotEmpty) {
      _formKey.currentState!.save(); // Guarda los valores en las variables

      Usuario usuario = Usuario(
        idUsuario: 0,
        // Aquí podrías usar un ID adecuado
        nombreUsuario: nombreUsuario!,
        nombre: nombre!,
        apellido: apellido!,
        edad: edad!,
        puntos: 0, // Si es necesario, asigna puntos iniciales
      );

      try {
        // Intentamos actualizar el usuario en la base de datos
        await DbUsuario.update(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado exitosamente')),
        );

        // Reiniciar el formulario después de guardar
        _formKey.currentState!.reset();
        setState(() {
          pickedFilePath = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el usuario')),
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
            const Text(
              "Lista de usuarios:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Define un tamaño fijo para la lista
              child: ListView.builder(
                itemCount: listaUsuarios.length,
                itemBuilder: (context, index) {
                  final usuario = listaUsuarios[index];
                  return ListTile(
                    title: Text(usuario.nombreUsuario),
                    subtitle: Text('${usuario.nombre} ${usuario.apellido}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Introduce un nombre de usuario",
                hintText: "Nombre de usuario",
              ),
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
                labelText: "Introduce un nombre",
                hintText: "Nombre",
              ),
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
                labelText: "Introduce tu apellido",
                hintText: "Apellido",
              ),
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
                labelText: "Introduce tu edad",
                hintText: "Edad",
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    int.tryParse(value) == null) {
                  return "Introduzca una edad válida";
                }
                return null;
              },
              onSaved: (value) {
                edad = int.tryParse(value ?? '') ?? 0;
              },
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                ProductImage(urlPath: pickedFilePath),
                Positioned(
                  top: 65,
                  right: 25,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 100,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          pickedFilePath = pickedFile.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: FloatingActionButton(
                onPressed: enviarFormulario,
                child: const Icon(Icons.save_outlined),
              ),
            ),
          ],
        ));
  }
}
