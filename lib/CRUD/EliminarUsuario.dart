import 'package:aplicacionpadel/BD/DbUsuario.dart';
import 'package:aplicacionpadel/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class EliminarUsuario extends StatefulWidget {
  const EliminarUsuario({super.key});

  @override
  State<EliminarUsuario> createState() => _EliminarUsuarioState();
}

class _EliminarUsuarioState extends State<EliminarUsuario> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  late final TextEditingController _controllerNombreUsuario;
  late int id;
  late String nombre;
  late String apellido;
  late int puntos;
  late int edad;
  List<Usuario> listaUsuarios = [];

  @override
  void initState() {
    super.initState();
    _controllerNombreUsuario = TextEditingController();
    obtenerUsuarios();
  }

  Future<void> obtenerUsuarios() async {
    final usuarios = await DbUsuario.usuarios();
    setState(() {
      listaUsuarios = usuarios;
    });
  }

  void enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores en las variables

      try {
        // Intento actualizar el usuario en la base de datos
        await DbUsuario.delete(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario eliminado exitosamente')));
        setState(() {
          listaUsuarios.removeWhere((element) => element.idUsuario == id);
          // Reiniciar el formulario después de guardar
          _formKey.currentState!.reset();
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
                marginColor: Colors.blue,
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
                  final usuarioSelect = selectedItem.item;
                  if (usuarioSelect != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seleccionaste: ${usuarioSelect.nombreUsuario}')));
                    _controllerNombreUsuario.text = usuarioSelect.nombreUsuario;
                    id = usuarioSelect.idUsuario;
                    nombre = usuarioSelect.nombre;
                    apellido = usuarioSelect.apellido;
                    puntos = usuarioSelect.puntos;
                    edad = usuarioSelect.edad;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controllerNombreUsuario,
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
