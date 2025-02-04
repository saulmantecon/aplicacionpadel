import 'package:aplicacionpadel/CRUDPartidoView/CrearPartido.dart';
import 'package:aplicacionpadel/CRUDusuarioView/LoginUsuario.dart';
import 'package:aplicacionpadel/viewmodel/PartidoViewModel.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/Game.dart';
import 'ui/Home.dart';
import 'ui/Settings.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UsuarioViewModel()),
    ChangeNotifierProvider(create: (context) => PartidoViewModel()),
  ],
  child: const AplicacionPadel(),));
}

class AplicacionPadel extends StatelessWidget {
  const AplicacionPadel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/crearPartido" : (context) => CrearPartido(),
        "/BottomNavigation" : (context) => BottomNavigation(),

      },
      debugShowCheckedModeBanner: false,
      home: Loginusuario(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // Lista de páginas para cada índice
  final List<Widget> _pages = [
    const Home(),
    const Game(),
    const Settings(),
  ];

  //Lista de botones
  final List<BottomNavigationBarItem> _listaBotones = List.of([
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Games"),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
  ]);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _listaBotones,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[
          _currentIndex], // Muestra la página correspondiente al índice seleccionado
    );
  }
}
