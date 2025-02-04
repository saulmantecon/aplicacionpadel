import 'package:flutter/material.dart';
import '../CRUDPartidoView/CrearPartido.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navega a la pantalla de Crear Partido
          Navigator.pushNamed(context, "/crearPartido");
        },
        label: const Text("Crear partido"),
        icon: const Icon(Icons.add_circle_outline),
      ),
      body: const Center(
        child: Text("Pantalla principal"),
      ),
    );
  }
}

//////////////////////////////////////////
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

