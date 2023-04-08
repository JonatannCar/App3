import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tesis_aplicacion/Paginas/Con_firebase/registrarse.dart';

import '../pagina_principal.dart';
import 'olvido_contrasena.dart';

class PaginaIniciarSesion extends StatefulWidget {
  const PaginaIniciarSesion({Key? key}) : super(key: key);

  @override
  State<PaginaIniciarSesion> createState() => _PaginaIniciarSesionState();
}

class _PaginaIniciarSesionState extends State<PaginaIniciarSesion> {
///////////////////////////////
  static bool _esVisible =
      true; // variable booleana que se utiliza para el campo de la contraseña
// La clave gobal identifica elementos de forma única,Esto identifica de forma única el correo electrónico Formy permite la validación del formulario en un paso posterior.

  final _formKey = GlobalKey<FormState>();
  var email = ""; // Variable para el correo electrónico
  var password = ""; // Variable para la contraseña
  // Se crean controladores de texto para recuperar el valor actual de los campos de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // ignore: prefer_const_constructors, unnecessary_new
  final storage = new FlutterSecureStorage();
// NUEVO
  bool isLoading = false;

/////////////////////// EMPIEZA INICIO DE SESIÓN CON GOOGLE ///////////////////////

  Future<UserCredential> ingresarconGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? autentication =
        await googleUser?.authentication;

    final credentials = GoogleAuthProvider.credential(
        accessToken: autentication!.accessToken,
        idToken: autentication.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<UserCredential> _signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   return await _auth.signInWithCredential(credential);
  // }

//////////////////// TERMINA INICIO DE SESIÓN CON GOOGLE /////////////////////////

  usuarioLogueado() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await storage.write(key: "uid", value: userCredential.user?.uid);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        // Mientras el correo y contraseña sean válidos se inicia sesión
        context,
        MaterialPageRoute(
          builder: (context) => const AppPrincipal(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Error
      if (e.code == 'user-not-found') {
        // Mensaje de alerta que se mostrará abajo de la pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(days: 365),
            action: SnackBarAction(
              label: 'Entendido',
              textColor: Colors.white,
              onPressed: () {},
            ),
            backgroundColor: const Color.fromARGB(255, 224, 29, 15),
            content: const Text(
              "No se encontró usuario para este correo electrónico",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            duration: const Duration(days: 365),
            action: SnackBarAction(
              label: 'Entendido',
              textColor: Colors.white,
              onPressed: () {},
            ),
            backgroundColor: Colors.redAccent,
            content: const Text(
              "Contraseña incorrecta proporcionada por el usuario",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
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
            body: Form(
                key: _formKey, // Key para el formulario
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    // padding: const EdgeInsets.only(top: 120.0, bottom : 0.0),
                    child: Center(
                        child: ListView(
                      children: [
//////////////////////////////////////////////////////////////////
                        const SizedBox(
                          height: 30,
                        ),
                        //////////////////////////////////////////////////////////////////
                        const Icon(
                          Icons.account_circle,
                          size: 120,
                          color: Colors.blue,
                        ),
                        //////////////////////////////////////////////////////////////////
                        const SizedBox(height: 20),
                        //////////////////////////////////////////////////////////////////
                        IniciarSesionTextoAyuda(),
                        //////////////////////////////////////////////////////////////////
                        const SizedBox(height: 30),
                        //////////////////////////////////////////////////

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.blueGrey,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black12, // relleno
                              labelText: 'Correo electrónico :',
                              labelStyle: const TextStyle(
                                  fontSize: 21, color: Colors.black),
                              errorStyle: const TextStyle(
                                  color: Colors.redAccent, fontSize: 15),
                              hintText: "ejemplo@correo.com",
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: Colors.white54),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              // Borde externo del campo de texto
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0,
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0), //mio
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese correo electrónico';
                            } else if (!emailController.text.contains('@')) {
                              return 'Ingrese correo electrónico válido';
                            }
                            return null;
                          },
                        ),

                        //////////////////////////////////////////////////////////////////
                        const SizedBox(
                          height: 20,
                        ),
                        //////////////////////////////////////////////////////////////////

                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          autofocus: false, // mio
                          obscureText:
                              _esVisible, //Para ocultar los datos que se van ingresando
                          cursorColor: Colors.blueGrey,
                          textInputAction: TextInputAction.next, //mio
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black12,
                              labelText: 'Contraseña :',
                              labelStyle: const TextStyle(
                                  fontSize: 21, color: Colors.black),
                              errorStyle: const TextStyle(
                                  color: Colors.redAccent, fontSize: 15),
                              hintText: "Escriba su contraseña",
                              hintStyle: const TextStyle(
                                  fontSize: 15, color: Colors.white54),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _esVisible = !_esVisible;
                                    });
                                  },
                                  child: _esVisible
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Colors.black45,
                                        )),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0,
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0), //mio
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese contraseña';
                            }
                            return null;
                          },
                        ),

                        //////////////////////////////////////////////////////////////////
                        // const SizedBox(height: 10),
                        //////////////////////////////////////////////////////////////////
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ContrasenaOlvido(),
                                  ),
                                ),
                              },
                              child: const Text(
                                '¿Olvidó su contraseña?',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        //////////////////////////////////////////////////////////////////

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 70),
                                backgroundColor:
                                    const Color.fromARGB(255, 19, 110, 228)),
                            icon: const Icon(
                              Icons.login,
                              size: 42,
                            ),
                            label: const Text(
                              'Iniciar sesión',
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: // Al presionar el botón se indica si el formulario es válido o falso, se inicia sesión
                                () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                });
                                usuarioLogueado();
                              }
                            },
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////
                        const SizedBox(height: 10),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'O continue con',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await ingresarconGoogle();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Future.microtask(() {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AppPrincipal()),
                                        (Route<dynamic> route) => false);
                                  });
                                }
                                // await _signInWithGoogle();
                                // Future.microtask(() {
                                //   Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           const AppPrincipal(),
                                //     ),
                                //   );
                                // });

                                // ignore: unused_local_variable
                                ////////////////////////// 2 ////////////////////
                                //   User? user =
                                //       await Authenticator.IniciarSesionconGoogle(
                                //           context: context);
                                //   Future.microtask(() {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             const AppPrincipal(),
                                //       ),
                                //     );
                                //   });
                              },
                              ////////////////////////// 2 ////////////////////

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              icon: Image.asset(
                                'assets/imagenes/Google-Logo.png',
                                height: 20,
                              ),
                              label: const Text(
                                'Iniciar Sesión con Google',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),

                        //////////////////////////////////////////////////////////////////
                        const SizedBox(
                          height: 20 * 0.8,
                        ),
                        //////////////////////////////////////////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("¿No tiene una cuenta? "),
                            TextButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // ignore: prefer_const_constructors
                                    builder: (context) => Registro(),
                                  ),
                                )
                              },
                              child: const Text('Registrarse'),
                            ),
                          ],
                        )
                        //////////////////////////////////////////////////////////////////
                      ],
                    ))))));
  }
}

// ignore: non_constant_identifier_names
Widget IniciarSesionTextoAyuda() {
  return const Text(
    "POR FAVOR INICIE SESIÓN O REGISTRESE PARA UTILIZAR LA APLICACIÓN",
    style: TextStyle(
        color: Colors.brown,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'PlayfairDisplaySC'),
    textAlign: TextAlign.center,
  );
}

// class Authenticator {
//   // ignore: non_constant_identifier_names
//   static Future<User?> IniciarSesionconGoogle(
//       {required BuildContext context}) async {
//     FirebaseAuth authenticator = FirebaseAuth.instance;

//     User? user;
//     GoogleSignIn objGoogleSignIn = GoogleSignIn();
//     GoogleSignInAccount? objGoogleSignInAccount =
//         await objGoogleSignIn.signIn();

//     if (objGoogleSignInAccount != null) {
//       GoogleSignInAuthentication objGoogleSignInAuthentication =
//           await objGoogleSignInAccount.authentication;

//       AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: objGoogleSignInAuthentication.accessToken,
//           idToken: objGoogleSignInAuthentication.idToken);
//       try {
//         UserCredential userCredential =
//             await authenticator.signInWithCredential(credential);
//         user = userCredential.user;
//         return user;
//       } on FirebaseAuthException {
//         // ignore: avoid_print
//         print('Error en la autenticación');
//       }
//     }
//     return null;
//   }
// }
