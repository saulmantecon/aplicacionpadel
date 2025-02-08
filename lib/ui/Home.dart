import 'package:aplicacionpadel/model/Partido.dart';
import 'package:aplicacionpadel/util/ContainerPartido.dart';
import 'package:aplicacionpadel/viewmodel/PartidoViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Clase que representa la pantalla de inicio.
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
      body: HomeView(),
    );
  }
}

/// Clase que muestra la lista de partidos no finalizados.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<PartidoViewModel>(context, listen: false).cargarPartidos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final partidoVM = Provider.of<PartidoViewModel>(context);

    //Filtrar partidos NO finalizados
    List<Partido> partidosNoFinalizados = partidoVM.listaPartidos.where((partido) => !partido.finalizado).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 2 : 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 600
      ),
      itemCount: partidosNoFinalizados.length,
      itemBuilder: (context, index) {
        final partido = partidosNoFinalizados[index];
        return Containerpartido(partido: partido);
      },
    );
  }
}
