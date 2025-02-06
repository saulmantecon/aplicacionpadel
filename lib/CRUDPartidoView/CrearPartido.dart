import 'package:aplicacionpadel/BD/DbPartido.dart';
import 'package:aplicacionpadel/BD/DbUsuarioPartido.dart';
import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/model/Usuario_Partido.dart';
import 'package:aplicacionpadel/util/DateAndTimePicker.dart';
import 'package:aplicacionpadel/viewmodel/PartidoViewModel.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CrearPartido extends StatefulWidget {
  const CrearPartido({super.key});

  @override
  State<CrearPartido> createState() => _CrearPartidoState();
}

class _CrearPartidoState extends State<CrearPartido> {
  final _formKey = GlobalKey<FormState>();
  String? _lugarDelPartido;
  String? _fechaHoraSeleccionada;

  void enviarFormulario(PartidoViewModel partidoVM, UsuarioViewModel usuarioVM) async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guarda los valores en las variables
      Partido partido = Partido(
          lugar: _lugarDelPartido!,
          fecha: _fechaHoraSeleccionada!,
          creador: usuarioVM.usuarioActual!.nombreUsuario,
          finalizado: false,
          resultado: null);
      try{
        int idPartido =await DbPartido.insert(partido);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Partido $idPartido registrado exitosamente')));

        partidoVM.agregarPartido(partido);

        _formKey.currentState!.reset();

        Usuario_Partido usuarioPartido = Usuario_Partido(
            idUsuario: usuarioVM.usuarioActual!.idUsuario!,
            idPartido: idPartido);

        await DbUsuarioPartido.insert(usuarioPartido);

        Navigator.pop(context);
      }catch(e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el partido')),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellene todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final partidoVM = Provider.of<PartidoViewModel>(context);
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Partido"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Introduce el lugar del partido",
                  hintText: "Ejemplo: Pista central",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, introduce el lugar del partido";
                  }
                  return null;
                },
                onSaved: (value) {
                  _lugarDelPartido = value;
                },
              ),
              const SizedBox(height: 20),
              DateAndTimePicker(
                onSaved: (value) {
                  if(value!=null){
                    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(value);

                    _fechaHoraSeleccionada = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => enviarFormulario(partidoVM, usuarioVM) ,
                child: const Text("Guardar Partido"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
