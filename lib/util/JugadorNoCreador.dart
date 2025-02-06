
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Usuario.dart';
import '../viewmodel/UsuarioViewModel.dart';

class JugadorNoCreador extends StatefulWidget {
  const JugadorNoCreador({super.key});

  @override
  _JugadorNoCreadorState createState() => _JugadorNoCreadorState();
}

class _JugadorNoCreadorState extends State<JugadorNoCreador> {
  Usuario? usuario;

  //ahora tengo que hacer una funcion que me cargue los usuario_partido en los que está el usuario actual. Si no está apuntado
  //en ese partido se podrá apuntar

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            backgroundImage: usuario != null && usuario!.imagen.isNotEmpty
                ? MemoryImage(base64Decode(usuario!.imagen))
                : null,
            child: usuario == null ? const Icon(Icons.person, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Text(usuario?.nombreUsuario ?? "", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700])),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final usuarioViewModel = Provider.of<UsuarioViewModel>(context, listen: false);
              setState(() {
                usuario = usuarioViewModel.usuarioActual;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text("Cargar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}