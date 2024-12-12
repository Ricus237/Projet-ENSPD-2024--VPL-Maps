import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latest/chat/service/auth_service.dart';
import 'package:latest/chat/service/database_service.dart';
import 'package:latest/maps.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final loc.Location location = loc.Location();

  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String groupPass = "";
  String groupPass2 = "";
  bool isJoined = false;
  bool _borderRed = false;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.recycling),
              title: Text(
                'Corbeille',
                style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () {
                // Handle item 1 tap.
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_clock),
              title: Text(
                'Récent',
                style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () {
                // Handle item 1 tap.
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: Text(
                'Aide',
                style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () {
                // Handle item 1 tap.
              },
            ),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text(
                "Thèmes",
                style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text(
                'Langue',
                style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () {},
            ),
            // Add more items as needed.
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.search,
              )),
        ],
        elevation: 1,
        title: Text(
          "Communautés",
          style: GoogleFonts.dancingScript(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ), // very important as noted

      body: SingleChildScrollView(
          child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await popUpDialog(context);
            },
            child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsets.only(top: 34, left: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.create,
                          shadows: [Shadow(color: Colors.black)],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Créer une communauté',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dancingScript(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 14,
                  right: 16,
                  bottom: 34,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.people_alt),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Rejoindre une communauté',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Other widgets (if any)
          Container(
              height: 400, // Set an appropriate height
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('groups')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        return GestureDetector(
                            onTap: () async {
                              final grouIpStore =
                                  await SharedPreferences.getInstance();
                              grouIpStore.setString(
                                  "grouIpStore", document['groupId']);
                              grouIpStore.setString(
                                  "grouNameStore", document['groupName']);
                              await FirebaseFirestore.instance
                                  .collection('locations')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .set({'groupId': document['groupId']},
                                      SetOptions(merge: true));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Maps(groupId: document['groupId'])));
                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14,
                                        left: 14,
                                        right: 14,
                                        bottom: 14),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/logo.png"),
                                                  ), // button text
                                                )),
                                            SizedBox(
                                              width: 10,
                                              height: 10,
                                            ),
                                            Text(
                                              document['groupName'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.dancingScript(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
                  }))
        ],
      )),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                "Créer une communauté",
                style: GoogleFonts.dancingScript(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : TextFormField(
                          onChanged: (val1) {
                            setState(() {
                              groupName = val1;
                            });
                          },
                          validator: (val1) {
                            if (val1!.isNotEmpty) {
                              return null;
                            } else {
                              return "Le Nom ne doit pas être vide";
                            }
                          },
                          style: GoogleFonts.dancingScript(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Nom de la communauté",
                              hintStyle: GoogleFonts.dancingScript(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: _borderRed
                                      ? BorderSide(color: Colors.red)
                                      : BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    onChanged: (val1) {
                      setState(() {
                        groupPass = val1;
                      });
                    },
                    style: GoogleFonts.dancingScript(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "Mot de passe d'accès",
                        hintStyle: GoogleFonts.dancingScript(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                            borderSide: _borderRed
                                ? BorderSide(color: Colors.red)
                                : BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _borderRed = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text(
                    "Annuler",
                    style: GoogleFonts.dancingScript(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if ((groupName != "") && (groupPass != "")) {
                      setState(() {
                        _isLoading = true;
                        _borderRed = false;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        groupName,
                        groupPass,
                      )
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      _getLocation();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var a2 = (prefs.getString('grouIpStore') ?? '');
                      await FirebaseFirestore.instance
                          .collection('locations')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .set({'groupId': a2}, SetOptions(merge: true));
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Maps(
                                    groupId: a2,
                                  )));
                    } else {
                      setState(() {
                        _borderRed = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 2, 68, 116),
                  ),
                  child: Text(
                    "Créer",
                    style: GoogleFonts.dancingScript(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            );
          }));
        });
  }

  popUpDialog2(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                "Entrer le mot de pass d'accès",
                style: GoogleFonts.dancingScript(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : TextField(
                          onChanged: (val1) {
                            setState(() {
                              groupPass2 = val1;
                            });
                          },
                          style: GoogleFonts.dancingScript(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Mot de passe d'accès",
                              hintStyle: GoogleFonts.dancingScript(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: _borderRed
                                      ? BorderSide(color: Colors.red)
                                      : BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _borderRed = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text(
                    "Annuler",
                    style: GoogleFonts.dancingScript(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if ((groupName != "") && (groupPass != "")) {
                      setState(() {
                        _isLoading = true;
                        _borderRed = false;
                      });
                      _getLocation();
                    } else {
                      setState(() {
                        _borderRed = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    "Entrer",
                    style: GoogleFonts.dancingScript(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            );
          }));
        });
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
