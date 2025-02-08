import 'package:aplicacionpadel/CRUDPartidoView/CrearPartido.dart';
import 'package:aplicacionpadel/CRUDusuarioView/LoginUsuario.dart';
import 'package:aplicacionpadel/viewmodel/PartidoConJugadorViewModel.dart';
import 'package:aplicacionpadel/viewmodel/PartidoViewModel.dart';
import 'package:aplicacionpadel/viewmodel/UsuarioViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/Game.dart';
import 'ui/Home.dart';
import 'ui/Settings.dart';

///main de la aplicación
void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UsuarioViewModel()),
    ChangeNotifierProvider(create: (context) => PartidoViewModel()),
    ChangeNotifierProvider(create: (context) => PartidoConJugadoresViewModel()),
  ],
      child: const AplicacionPadel()));
}

/// Clase principal de la aplicación de pádel.
class AplicacionPadel extends StatelessWidget {
  const AplicacionPadel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData(),
      routes: {
        "/crearPartido": (context) => CrearPartido(),
        "/BottomNavigation": (context) => BottomNavigation(),
      },
      debugShowCheckedModeBanner: false,
      home: Loginusuario(),
    );
  }

  /// Define el tema principal de la aplicación
  ThemeData _buildThemeData() {
    return ThemeData(
        primarySwatch: Colors.blue,
        // Azul como color principal
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        // Fondo azul claro
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1), // Azul oscuro para el AppBar
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Fondo azul
            foregroundColor: Colors.white, // Texto blanco
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF1565C0),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ));
  }
}
/// Clase para la navegación entre pantallas con barra de navegación inferior.
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> _pages = [
    const Home(),
    Game(),
    const Settings(),
  ];

  final List<BottomNavigationBarItem> _listaBotones = List.of([
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Games"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: "Settings"),
  ]);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _listaBotones,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1565C0),
        // Azul para seleccionado
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
