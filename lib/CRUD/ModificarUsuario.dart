import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/util/ProductImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';

class ModificarUsuario extends StatefulWidget {
  const ModificarUsuario({super.key});

  @override
  State<ModificarUsuario> createState() => _ModificarUsuarioState();
}

class _ModificarUsuarioState extends State<ModificarUsuario> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  String? pickedFilePath; // Almacenar URL de foto
  late final TextEditingController _controllerNombre = TextEditingController();
  late final TextEditingController _controllerNombreUsuario = TextEditingController();
  late final TextEditingController _controllerApellido = TextEditingController();
  late final TextEditingController _controllerEdad = TextEditingController();
  int? puntos;
  int? id;
  List<Usuario> listaUsuarios = [];

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
        nombreUsuario: _controllerNombreUsuario.text,
        nombre: _controllerNombre.text,
        apellido: _controllerApellido.text,
        edad: int.parse(_controllerEdad.text),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchField<Usuario>(
                suggestions: listaUsuarios
                    .map((usuario) => SearchFieldListItem<Usuario>(
                          usuario.nombreUsuario,
                          // Lo que se muestra en el campo de búsqueda
                          item: usuario, // El objeto que está asociado
                        ))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.done,
                hint: 'Buscar usuario',
                onSuggestionTap: (selectedItem) {
                  final usuario = selectedItem.item;
                  if (usuario != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Seleccionaste: ${usuario.nombreUsuario}')
                      ));
                    _controllerNombre.text = usuario.nombreUsuario;
                    _controllerNombre.text = usuario.nombre;
                    _controllerApellido.text = usuario.apellido;
                    _controllerEdad.text = usuario.edad.toString();
                    puntos = usuario.puntos;
                    id = usuario.idUsuario;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controllerNombre,
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
                _controllerNombreUsuario.text = value!;
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
                _controllerNombre.text = value!;
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
                _controllerApellido.text = value!;
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
                _controllerEdad.text = value!;
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
