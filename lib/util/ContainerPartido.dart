import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Partido.dart';
import '../model/Usuario.dart';
import '../viewmodel/UsuarioViewModel.dart';

class Containerpartido extends StatefulWidget {
  final Partido partido;

  const Containerpartido({super.key, required this.partido});

  @override
  State<Containerpartido> createState() => _ContainerpartidoState();
}

class _ContainerpartidoState extends State<Containerpartido> {
  bool mostrarResultado = false;
  final TextEditingController set1Controller = TextEditingController();
  final TextEditingController set2Controller = TextEditingController();
  final TextEditingController set3Controller = TextEditingController();

  Usuario? usuario2;
  Usuario? usuario3;
  Usuario? usuario4;
  List<Usuario> usuariosFiltrados = []; // Lista filtrada

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (mounted) {
        final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
        await usuarioVM.cargarUsuarios(); // Esperamos a que cargue
        setState(() {
          usuariosFiltrados = List.from(usuarioVM
              .listaUsuarios); // Copia la lista sin modificar la original
        });
      }
    });
  }

  void actualizarUsuariosDisponibles() {
    setState(() {
      final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
      usuariosFiltrados = usuarioVM.listaUsuarios.where((usuario) {
        return usuario != usuario2 &&
            usuario != usuario3 &&
            usuario != usuario4;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);

    // Verificar si el usuario logueado es el creador del partido
    bool esCreador =
        usuarioVM.usuarioActual?.idUsuario == widget.partido.creador.idUsuario;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nº: ${widget.partido.idPartido}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.partido.lugar,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(widget.partido.fecha,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildJugadorCreador(widget.partido.creador),
                      buildJugadorDropdown(2, esCreador),
                    ],
                  ),
                  const Text("VS",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple)),
                  Column(
                    children: [
                      buildJugadorDropdown(3, esCreador),
                      buildJugadorDropdown(4, esCreador),
                    ],
                  ),
                ],
              ),
              if (esCreador)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      mostrarResultado = true; //Muestra el TextFormField y el botón de finalizar
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Fijar Partido",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              const SizedBox(height: 10),
              if (mostrarResultado)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSetInput("Set 1", set1Controller),
                        _buildSetInput("Set 2", set2Controller),
                        _buildSetInput("Set 3", set3Controller),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //BOTÓN "FINALIZAR PARTIDO" SOLO SI mostrarResultado ES TRUE
                    ElevatedButton(
                      onPressed: () {
                        String resultado =
                            "${set1Controller.text}, ${set2Controller.text}, ${set3Controller.text}";
                        print("Partido finalizado con resultado: $resultado");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Finalizar Partido",
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),

            ],
          )
      ),
    );
  }

  Widget _buildJugadorCreador(Usuario usuario) {
    return SizedBox(
      width: 200, //Tamaño uniforme para evitar desbordamientos
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: usuario.imagen.isNotEmpty
                  ? MemoryImage(base64Decode(usuario.imagen))
                  : const NetworkImage(
                          "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp")
                      as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              // Evita que el texto se salga del contenedor
              child: Text(
                usuario.nombreUsuario,
                overflow: TextOverflow.ellipsis,
                // Evita desbordamientos de texto
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJugadorDropdown(int numeroJugador, bool esCreador) {
    Usuario? usuarioSeleccionado;

    if (numeroJugador == 2) usuarioSeleccionado = usuario2;
    if (numeroJugador == 3) usuarioSeleccionado = usuario3;
    if (numeroJugador == 4) usuarioSeleccionado = usuario4;

    // Filtrar lista sin incluir al usuario creador
    List<Usuario> opcionesFiltradas = [];
    for (Usuario usuario in usuariosFiltrados) {
      if (usuario.idUsuario != usuario2?.idUsuario &&
          usuario.idUsuario != usuario3?.idUsuario &&
          usuario.idUsuario != usuario4?.idUsuario &&
          usuario.idUsuario != widget.partido.creador.idUsuario) {
        opcionesFiltradas.add(usuario);
      }
    }

    if (esCreador) {
      return Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: usuarioSeleccionado?.imagen.isNotEmpty == true
                  ? MemoryImage(base64Decode(usuarioSeleccionado!.imagen))
                  : const NetworkImage(
                          "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp")
                      as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButton<Usuario>(
                isExpanded: true,
                value: opcionesFiltradas.contains(usuarioSeleccionado)
                    ? usuarioSeleccionado
                    : null,
                hint: const Text("Selecciona un jugador"),
                onChanged: (Usuario? nuevoUsuario) {
                  if (nuevoUsuario != null) {
                    setState(() {
                      if (numeroJugador == 2) usuario2 = nuevoUsuario;
                      if (numeroJugador == 3) usuario3 = nuevoUsuario;
                      if (numeroJugador == 4) usuario4 = nuevoUsuario;
                      actualizarUsuariosDisponibles();
                    });
                  }
                },
                underline: const SizedBox(),
                items: opcionesFiltradas.map((Usuario usuario) {
                  return DropdownMenuItem<Usuario>(
                    value: usuario,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: usuario.imagen.isNotEmpty
                              ? MemoryImage(base64Decode(usuario.imagen))
                              : const NetworkImage(
                                      "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp")
                                  as ImageProvider,
                          radius: 15,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            usuario.nombreUsuario,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: usuarioSeleccionado?.imagen.isNotEmpty == true
                  ? MemoryImage(base64Decode(usuarioSeleccionado!.imagen))
                  : const NetworkImage(
                          "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp")
                      as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                usuarioSeleccionado != null
                    ? usuarioSeleccionado.nombreUsuario
                    : "No asignado",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.purple[700]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }

  // 🔹 WIDGET PARA CREAR CADA TEXTFORMFIELD (SET)
  Widget _buildSetInput(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 80,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Ej: 6-3",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        ),
      ],
    );
  }
}
