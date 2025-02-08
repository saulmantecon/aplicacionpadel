import 'dart:convert';
import 'package:aplicacionpadel/BD/DbUsuarioPartido.dart';
import 'package:aplicacionpadel/model/Usuario_Partido.dart';
import 'package:aplicacionpadel/viewmodel/PartidoViewModel.dart';
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
  /// Actualiza la lista de usuarios disponibles para el partido.
  void actualizarUsuariosDisponibles() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
        usuariosFiltrados = usuarioVM.listaUsuarios.where((usuario) {
          return usuario != usuario2 && usuario != usuario3 && usuario != usuario4;
        }).toList();
      });
    });
  }

  /// Asigna jugadores al partido y los registra en la base de datos.
  void asignarJugadoresAPartido()async{
    if(usuario2!=null && usuario3!=null && usuario4!=null ){
      Usuario_Partido usuario2_partido = Usuario_Partido(idUsuario: usuario2!.idUsuario!, idPartido: widget.partido.idPartido!, equipo: 1);
      Usuario_Partido usuario3_partido = Usuario_Partido(idUsuario: usuario3!.idUsuario!, idPartido: widget.partido.idPartido!, equipo: 2);
      Usuario_Partido usuario4_partido = Usuario_Partido(idUsuario: usuario4!.idUsuario!, idPartido: widget.partido.idPartido!, equipo: 2);

      try{
        await DbUsuarioPartido.insert(usuario2_partido);
        await DbUsuarioPartido.insert(usuario3_partido);
        await DbUsuarioPartido.insert(usuario4_partido);
        setState(() {
          mostrarResultado=true;
        });

      }catch(e){
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al registrar los usuario_partido')),);
        }
      }
    }else{
      print("hay algun usuario null");
    }
  }//asignarJugadoresAPartido

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final partidoVM = Provider.of<PartidoViewModel>(context);

    // Verificar si el usuario logueado es el creador del partido
    bool esCreador = usuarioVM.usuarioActual?.idUsuario == widget.partido.creador.idUsuario;

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
                      const SizedBox(height: 5,),
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
                      const SizedBox(height: 5,),
                      buildJugadorDropdown(4, esCreador),
                    ],
                  ),
                ],
              ),
              //si se cumplen las validaciones aparece el boton de fijar partido
              if (esCreador && usuario2!=null && usuario3!=null && usuario4!=null)
                ElevatedButton(
                  onPressed: () => asignarJugadoresAPartido(),
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
              //cuando se pulsa a fijar partido aparecen 3 textield y un boton para finalizar el partido
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
                    ElevatedButton(
                      onPressed: () {
                        if (set1Controller.text.isEmpty || set2Controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Debes ingresar al menos 2 sets para finalizar el partido.")),
                          );
                        }else{
                          String resultado = "${set1Controller.text}, ${set2Controller.text}, ${set3Controller.text}";
                          try{
                            partidoVM.finalizarPartido(widget.partido.idPartido!, resultado);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Partido finalizado correctamente")),);
                          }catch(e){
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("error al finalizar el partido.")),);
                          }
                        }
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
    /// Construye un widget que muestra la información del creador del partido.
    ///
    /// Este widget incluye un avatar y el nombre del usuario en un contenedor con estilo.
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

  /// Construye un widget que muestra un menú desplegable para seleccionar jugadores.
  ///
  /// Este widget permite seleccionar un jugador disponible para el partido,
  /// asegurando que el mismo jugador no sea asignado dos veces.
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

    // Asegurarse de que el usuario seleccionado esté en las opciones
    if (usuarioSeleccionado != null && !opcionesFiltradas.contains(usuarioSeleccionado)) {
      opcionesFiltradas.add(usuarioSeleccionado);
    }
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: IgnorePointer(
        ignoring: mostrarResultado,
        child: DropdownButton<Usuario>(
          isExpanded: true,
          value: usuarioSeleccionado,
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
                  Text(
                    usuario.nombreUsuario,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  ///Widget para crear los textformfields de los sets.
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
