import 'package:flutter/material.dart';
import 'model/Game.dart';
import 'model/Home.dart';
import 'model/Settings.dart';


void main() async{
  runApp(const AplicacionPadel());
}

class AplicacionPadel extends StatelessWidget {
  const AplicacionPadel({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigation(),
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
  final List <BottomNavigationBarItem> _listaBotones = List.of([
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Games"),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")]);
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
      body: _pages[_currentIndex], // Muestra la página correspondiente al índice seleccionado
    );
  }
}





