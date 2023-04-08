import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Paginas/bienvenida.dart';
import 'Paginas/pagina_principal.dart';

// La función main() que es la función de entrada de la aplicación de Flutter
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Se asegura que los widgets de Flutter estén correctamente inicializados
  //await Firebase.initializeApp();

  runApp(
      PaginaBase()); // Se ejecuta la aplicación, pasando como argumento una instancia de la clase PaginaBase
}

// ignore: use_key_in_widget_constructors
class PaginaBase extends StatelessWidget {
  // Se define la estructura de la página principal de la app
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // ignore: unnecessary_new, prefer_const_constructors
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    // Se incluye una función checkLoginStatus para verificar que un usuario ha iniciado sesión
    String? value = await storage.read(key: "uid");
    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            // ignore: avoid_print
            print("Algo salió mal");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ignore: prefer_const_constructors
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
              title: 'Flutter Firebase EMail Password Auth',
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              debugShowCheckedModeBanner: false,
              home: FutureBuilder<bool>(
                //Espera la inicialización de firebase
                future: checkLoginStatus(),

                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    // ignore: prefer_const_constructors
                    return PaginaBienvenida(); // Si el usuario no ha iniciado sesión se muestra página de bienvenida
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        color: Colors.red,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }
                  // ignore: prefer_const_constructors
                  return AppPrincipal(); // Si el usuario ha iniciado sesión se muestra la página principal de la app
                },
              ));
        });
  }
}
