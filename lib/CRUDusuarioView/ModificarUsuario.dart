import 'dart:convert';

import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:aplicacionpadel/util/ProductImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';

///Clase que representa la pantalla para modificar un usuario existente
class ModificarUsuario extends StatefulWidget {
  const ModificarUsuario({super.key});

  @override
  State<ModificarUsuario> createState() => _ModificarUsuarioState();
}

class _ModificarUsuarioState extends State<ModificarUsuario> {
  final _formKey = GlobalKey<FormState>();
  String? pickedFilePath;
  late final TextEditingController _controllerNombreUsuario;
  late final TextEditingController _controllerNombre;
  late final TextEditingController _controllerApellido;
  late final TextEditingController _controllerEdad;
  late final TextEditingController _controllerContrasena;
  int? puntos;
  int? id;
  List<Usuario> listaUsuarios = [];
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controllerNombreUsuario = TextEditingController();
    _controllerNombre = TextEditingController();
    _controllerApellido = TextEditingController();
    _controllerEdad = TextEditingController();
    _controllerContrasena = TextEditingController();
    obtenerUsuarios();
  }
  /// Obtiene la lista de usuarios desde la base de datos.
  Future<void> obtenerUsuarios() async {
    final usuarios = await DbUsuario.usuarios();
    setState(() {
      listaUsuarios = usuarios;
    });
  }
  /// Carga los datos de un usuario seleccionado en los campos del formulario.
  void cargarDatosUsuario(Usuario usuario) {
    _controllerNombreUsuario.text = usuario.nombreUsuario;
    _controllerNombre.text = usuario.nombre;
    _controllerApellido.text = usuario.apellido;
    _controllerEdad.text = usuario.edad.toString();
    _controllerContrasena.text = usuario.contrasena;
    puntos = usuario.puntos;
    id = usuario.idUsuario;
    pickedFilePath = usuario.imagen;
  }
  /// Valida el formulario y actualiza la información del usuario en la base de datos.
  void enviarFormulario() async {
    if (_formKey.currentState!.validate() &&
        pickedFilePath != null &&
        pickedFilePath!.isNotEmpty) {
      _formKey.currentState!.save();

      Usuario usuario = Usuario(
        idUsuario: id!,
        nombreUsuario: _controllerNombreUsuario.text,
        contrasena: _controllerContrasena.text,
        nombre: _controllerNombre.text,
        apellido: _controllerApellido.text,
        edad: int.parse(_controllerEdad.text),
        puntos: 0,
        imagen: pickedFilePath!,
      );

      try {
        await DbUsuario.update(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado exitosamente')),
        );

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
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final bool isAdmin = usuarioVM.usuarioActual?.nombreUsuario == "admin";

    // Si no es admin, cargar automáticamente los datos del usuario actual
    if (!isAdmin && listaUsuarios.isNotEmpty) {
      final usuarioActual = usuarioVM.usuarioActual!;
      cargarDatosUsuario(usuarioActual);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// Campo de búsqueda para seleccionar un usuario si es administrador.
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchField<Usuario>(
                suggestions: listaUsuarios
                    .map((usuario) => SearchFieldListItem<Usuario>(
                  usuario.nombreUsuario,
                  item: usuario,
                ))
                    .toList(),
                suggestionState: Suggestion.expand,
                textInputAction: TextInputAction.done,
                hint: 'Buscar usuario',
                onSuggestionTap: (selectedItem) {
                  final usuario = selectedItem.item;
                  if (usuario != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Seleccionaste: ${usuario.nombreUsuario}'),
                    ));
                    cargarDatosUsuario(usuario);
                  }
                },
              ),
            ),
          const SizedBox(height: 20),
          // Campos de formulario
          TextFormField(
            controller: _controllerNombreUsuario,
            enabled: isAdmin, // Solo habilitado para admins
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
          ),
          TextFormField(
            controller: _controllerContrasena,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingresa tu contraseña',
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
                return "Introduzca una contraseña correcta";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _controllerNombre,
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
          ),
          TextFormField(
            controller: _controllerApellido,
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
          ),
          TextFormField(
            controller: _controllerEdad,
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
          ),
          const SizedBox(height: 20),
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
                      imageQuality: 100,
                    );
                    if (pickedFile != null) {
                      final bytes = await pickedFile.readAsBytes();
                      setState(() {
                        pickedFilePath = base64Encode(bytes);
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
      ),
    );
  }
}