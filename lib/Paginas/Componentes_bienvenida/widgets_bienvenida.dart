import 'package:flutter/material.dart';

import '../Con_firebase/iniciar_sesion.dart';

Widget uacm() {
  return const Text(
    "U  A  C  M",
    style: TextStyle(
        color: Colors.brown,
        fontSize: 70,
        fontWeight: FontWeight.bold,
        fontFamily: 'Bangers'),
  );
}

Widget bienvenida() {
  return const Text(
    " BIENVENIDO A LA APLICACIÓN DEL DISPENSADOR DE MEDICAMENTOS AUTOMÁTICO",
    style: TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'PlayfairDisplaySC'),
    textAlign: TextAlign.center,
  );
}

Widget imagenbienv() {
  return Image.asset(
    'assets/imagenes/reloj_icono_transparencia.png',
    width: 200,
    height: 300,
  );
}

class BotonBienvenidaIniSes extends StatelessWidget {
  const BotonBienvenidaIniSes({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 80),
        backgroundColor: const Color.fromARGB(255, 19, 110, 228),
        side:
            const BorderSide(width: 5, color: Color.fromARGB(255, 9, 68, 116)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: const Text('Empezar',
          style: TextStyle(fontSize: 50, color: Colors.white)),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PaginaIniciarSesion()));
      },
    );
  }
}
