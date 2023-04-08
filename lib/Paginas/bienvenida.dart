import 'package:flutter/material.dart';
import 'Componentes_bienvenida/widgets_bienvenida.dart';

class PaginaBienvenida extends StatefulWidget {
  const PaginaBienvenida({super.key});

  @override
  State<PaginaBienvenida> createState() => _PaginaBienvenidaState();
}

class _PaginaBienvenidaState extends State<PaginaBienvenida> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Scaffold(
      //appBar: AppBar(
      //title: const Text(""),
      //backgroundColor: const Color.fromARGB(239, 18, 226, 198),
      //),
      //Container(
      //child: Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(239, 18, 226, 198),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                uacm(),
                imagenbienv(),
                bienvenida(),
                const SizedBox(height: 50),
                const BotonBienvenidaIniSes(),
              ],
            )
          ],
        ),
      ),
      // ),
    );
  }
}
