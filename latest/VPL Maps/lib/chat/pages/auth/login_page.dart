import 'package:google_fonts/google_fonts.dart';
import 'package:latest/createPage.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/helper_function.dart';
import '../../pages/auth/register_page.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loc.Location location = loc.Location();

  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/back1.jpg'),
                    fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight,
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage('assets/images/logo.png'),
                                  )),
                                ),
                                const SizedBox(height: 15),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: GoogleFonts.dancingScript(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      // Ajoutez cette ligne pour personnaliser la bordure
                                      borderSide: BorderSide(
                                        color:
                                            Colors.red, // Couleur de la bordure
                                        width: 2.0, // Épaisseur de la bordure
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },

                                  // check the validation
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val!)
                                        ? null
                                        : "Entre un Email Valide";
                                  },
                                ),
                                const SizedBox(height: 9),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelStyle: GoogleFonts.dancingScript(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    labelText: "Mot de passe",
                                    prefixIcon: Icon(
                                      Icons.key,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      // Ajoutez cette ligne pour personnaliser la bordure
                                      borderSide: BorderSide(
                                        color:
                                            Colors.red, // Couleur de la bordure
                                        width: 2.0, // Épaisseur de la bordure
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val!.length < 6) {
                                      return "Mot de passe de 6 carractères";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    child: Text(
                                      "Connexion",
                                      style: GoogleFonts.dancingScript(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      login();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Pas de compte? ",
                                      style: GoogleFonts.dancingScript(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: "Inscription",
                                          style: GoogleFonts.dancingScript(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    nextScreenReplace(
                                        context, const RegisterPage());
                                  },
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              )),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          _requestPermission;
          _getLocation();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePage()));
        } else {
          showSnackbar(context, Colors.blue, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String fullname = (prefs.getString('fullNameStore') ?? '');

    var j = (prefs.getString('grouIpStore') ?? '');
    try {
      final loc.LocationData _locationResult = await location.getLocation();

      await FirebaseFirestore.instance
          .collection('locations')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': fullname,
        'groupId': j,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
