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
  //fijarPartido
  void asignarJugadoresAPartido()async{
    if(usuario2!=null && usuario3!=null && usuario4!=null ){
      Usuario_Partido usuario2_partido = Usuario_Partido(idUsuario: usuario2!.idUsuario!, idPartido: widget.partido.idPartido!);
      Usuario_Partido usuario3_partido = Usuario_Partido(idUsuario: usuario3!.idUsuario!, idPartido: widget.partido.idPartido!);
      Usuario_Partido usuario4_partido = Usuario_Partido(idUsuario: usuario4!.idUsuario!, idPartido: widget.partido.idPartido!);

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


  List<int> determinarGanador(String resultado, int idJugador1, int idJugador2, int idJugador3, int idJugador4) {
    List<String> sets = resultado.split(","); //Divide el string en sets individuales
    int setsGanadosEquipo1 = 0;
    int setsGanadosEquipo2 = 0;

    for (String set in sets) {
      List<String> puntuaciones = set.trim().split("-"); // 🔹 Divide los números
      if (puntuaciones.length == 2) {
        int puntosEquipo1 = int.parse(puntuaciones[0]); // 🔹 Puntos del equipo 1 (Jugador 1 y 2)
        int puntosEquipo2 = int.parse(puntuaciones[1]); // 🔹 Puntos del equipo 2 (Jugador 3 y 4)

        if (puntosEquipo1 > puntosEquipo2) {
          setsGanadosEquipo1++; // Equipo 1 gana este set
        } else {
          setsGanadosEquipo2++; // Equipo 2 gana este set
        }

        // 🔹 Si un equipo gana 2 sets, ya es el ganador
        if (setsGanadosEquipo1 == 2) {
          return [idJugador1, idJugador2]; //  Gana equipo 1
        } else if (setsGanadosEquipo2 == 2) {
          return [idJugador3, idJugador4]; // Gana equipo 2
        }
      }
    }

    //Si el partido llegó hasta el tercer set, el equipo con más sets ganados es el ganador
    return (setsGanadosEquipo1 > setsGanadosEquipo2) ? [idJugador1, idJugador2] : [idJugador3, idJugador4];
  }





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
                          List<int> ganadores = determinarGanador(
                              resultado, widget.partido.creador.idUsuario!,
                              usuario2!.idUsuario!,
                              usuario3!.idUsuario!,
                              usuario4!.idUsuario!);
                          try{
                            partidoVM.finalizarPartido(widget.partido.idPartido!, resultado, ganadores[0], ganadores[1]);
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
              child: IgnorePointer(
                ignoring: mostrarResultado,
                child: DropdownButton<Usuario>(
                  isExpanded: true,
                  value: opcionesFiltradas.contains(usuarioSeleccionado) ? usuarioSeleccionado : null,
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
              backgroundImage: usuarioSeleccionado?.imagen.isNotEmpty == true ? MemoryImage(base64Decode(usuarioSeleccionado!.imagen)) : const NetworkImage(
                          "https://www.l3tcraft.com/wp-content/uploads/2023/01/Knekro.webp") as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(usuarioSeleccionado != null ? usuarioSeleccionado.nombreUsuario : "No asignado",
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

  //WIDGET PARA CREAR CADA TEXTFORMFIELD (SET)
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
