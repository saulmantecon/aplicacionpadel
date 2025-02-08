import 'dart:io';

import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';

///Clase que representa la pantalla de eliminarUsuario
class EliminarUsuario extends StatefulWidget {
  const EliminarUsuario({super.key});

  @override
  State<EliminarUsuario> createState() => _EliminarUsuarioState();
}

class _EliminarUsuarioState extends State<EliminarUsuario> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  /// Controlador de texto para el campo de entrada del nombre de usuario.
  late final TextEditingController _controllerNombreUsuario;
  int? id;
  List<Usuario> listaUsuarios = [];

  @override
  void initState() {
    super.initState();
    _controllerNombreUsuario = TextEditingController();
    obtenerUsuarios();
  }
  /// Obtiene la lista de usuarios desde la base de datos.
  Future<void> obtenerUsuarios() async {
    final usuarios = await DbUsuario.usuarios();
    setState(() {
      listaUsuarios = usuarios;
    });
  }
  /// Carga los datos del usuario seleccionado en el formulario
  void cargarDatosUsuario(Usuario usuario) {
    _controllerNombreUsuario.text = usuario.nombreUsuario;
    id = usuario.idUsuario;
  }
  /// Valida el formulario y elimina el usuario de la base de datos.
  void enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Eliminar usuario en la base de datos
        await DbUsuario.delete(id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado exitosamente')),
        );
        setState(() {
          listaUsuarios.removeWhere((element) => element.idUsuario == id);
          _formKey.currentState!.reset(); // Reiniciar el formulario
        });

        await Future.delayed(const Duration(seconds: 2));
        //Cerrar la aplicación
        if (Platform.isAndroid) {
          SystemNavigator.pop(); // Para Android
        } else if (Platform.isIOS) {
          exit(0); // Para iOS
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario')),
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
    final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
    final bool isAdmin = usuarioVM.usuarioActual?.nombreUsuario == "admin";

    // Si no es admin, cargar automáticamente los datos del usuario actual
    if (!isAdmin) {
      final usuarioActual = usuarioVM.usuarioActual!;
      cargarDatosUsuario(usuarioActual);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchField<Usuario>(
                marginColor: Colors.blue,
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
                  final usuarioSelect = selectedItem.item;
                  if (usuarioSelect != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Seleccionaste: ${usuarioSelect.nombreUsuario}'),
                    ));
                    cargarDatosUsuario(usuarioSelect);
                  }
                },
              ),
            ),
          const SizedBox(height: 20),
          /// Textformfield para el nombre de usuario a eliminar.
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
          const SizedBox(height: 20),
          Center(
            child: FloatingActionButton(
              onPressed: () {
                if (isAdmin || usuarioVM.usuarioActual?.idUsuario == id) {
                  enviarFormulario();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No tienes permisos para eliminar este usuario.')));
                }
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}