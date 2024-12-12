import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latest/chat/helper/helper_function.dart';
import 'package:latest/chat/pages/auth/register_page.dart';
import 'package:latest/maps.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String alpha = prefs.getString('grouIpStore') ?? '';
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA60UJkOw6e22WVf6sccAAVWKEKv7S1vTs",
          authDomain: "projet-tutore-2024.firebaseapp.com",
          databaseURL: "https://projet-tutore-2024-default-rtdb.firebaseio.com",
          projectId: "projet-tutore-2024",
          storageBucket: "projet-tutore-2024.appspot.com",
          messagingSenderId: "847704277036",
          appId: "1:847704277036:web:0ba74996635160dbd85189",
          measurementId: "G-D90N6MFEDF"));
  runApp(MaterialApp(
      home: MyApp(
    groups: alpha,
  )));
}

ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 2, 68, 116),
  // Autres propriétés...
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.indigo.withOpacity(0.4),
  // Autres propriétés...
);

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  var groups;

  MyApp({super.key, required groups});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  bool _isSignedIn = false;
  String j = "";

  final loc.Location location = loc.Location();

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getLocation();
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
          j = (prefs.getString('grouIpStore') ?? '');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'VPL Maps',
        theme: isDarkMode ? darkTheme : lightTheme,
        home: _isSignedIn
            ? Maps(
                groupId: j,
              )
            : RegisterPage());
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
