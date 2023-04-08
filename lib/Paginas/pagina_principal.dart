import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Con_firebase/iniciar_sesion.dart';

class AppPrincipal extends StatefulWidget {
  const AppPrincipal({super.key});

  @override
  State<AppPrincipal> createState() => _AppPrincipalState();
}

class _AppPrincipalState extends State<AppPrincipal> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //title: const Text(
        //"Inicio de sesión de usuario",
        //style: TextStyle(color: Colors.black87),
        //),
        //   ),

        backgroundColor: const Color.fromARGB(239, 18, 226, 198),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bienvenido "),
              ElevatedButton(
                onPressed: () async => {
                  await FirebaseAuth.instance.signOut(),
                  await storage.delete(key: 'uid'),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaginaIniciarSesion(),
                      ),
                      (route) => false)
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: const Text('Cerrar sesión'),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Inicio sesión como:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                user.email!,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              // SizedBox(height: 40,),
              // ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),
              // icon
              // ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
