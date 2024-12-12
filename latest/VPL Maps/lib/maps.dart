import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latest/chat/pages/auth/login_page.dart';
import 'package:latest/chat/pages/chat_page.dart';
import 'package:latest/createPage.dart';
import 'package:latest/profile.dart';
import 'package:latest/voip.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/service/auth_service.dart';

String a = "";
String b = "";
String c = "";

class Maps extends StatefulWidget {
  final groupId;

  Maps({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final loc.Location location = loc.Location();

  int _selectedIndex = 0;
  void _onItemTapped(int index) async {
    setState(() async {
      _selectedIndex = index;
      if (index == 2) {}
      if (index == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        a = (prefs.getString('grouIpStore') ?? '');
        b = (prefs.getString('fullNameStore') ?? '');
        c = (prefs.getString('grouNameStore') ?? '');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPage(groupId: a, groupName: c, userName: b)));
      }
      if (index == 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        a = (prefs.getString('grouIpStore') ?? '');
        b = (prefs.getString('userNameStore') ?? '');
        c = (prefs.getString('grouNameStore') ?? '');
      }
      if (index == 2) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        a = (prefs.getString('grouIpStore') ?? '');
        b = (prefs.getString('userNameStore') ?? '');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VoIP()));
      }
      if (index == 3) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreatePage()));
      }
    });
  }

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
              onTap: () {
                // Handle item 1 tap.
              },
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
              onTap: () {
                // Handle item 2 tap.
              },
            ),
            // Add more items as needed.
          ],
        ),
      ),
      extendBody: true, // very important as noted

      bottomNavigationBar: BottomNavigationBar(
          elevation: 0, // to get rid of the shadow
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: GoogleFonts.dancingScript(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.dancingScript(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          onTap: _onItemTapped,
          backgroundColor: Color.fromARGB(255, 255, 255,
              255), // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.satellite_alt),
              label: 'Géolocalisation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_callback),
              label: 'VoIp',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Sortir',
            ),
          ]),
      appBar: AppBar(
        title: Text(
          'Geolocalisation',
          style: GoogleFonts.dancingScript(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                c = (prefs.getString('grouNameStore') ?? '');
                String fullname = (prefs.getString('fullNameStore') ?? '');
                a = (prefs.getString('grouIpStore') ?? '');
                var number = (prefs.getString('numberStore') ?? '');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profilePage(
                              email: FirebaseAuth.instance.currentUser?.email
                                  as String,
                              number: number,
                              username: fullname,
                              groupName: c,
                              groupId: a,
                            )));
              },
              icon: const Icon(
                Icons.person,
              )),
          IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: const Icon(
                Icons.exit_to_app,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('locations')
            .where('groupId', isEqualTo: widget.groupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return FlutterMap(
              options: const MapOptions(
                initialCenter: latLng.LatLng(4.15680, 9.83155),
                initialZoom: 8.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers:
                      _buildMarkers(snapshot.data as QuerySnapshot<Object?>),
                ),
              ]);
        },
      ),
    );
  }

  List<Marker> _buildMarkers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Marker(
          width: 80.0,
          height: 80.0,
          point: latLng.LatLng(doc['latitude'], doc['longitude']),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(Icons.location_on_outlined,
                          color: Colors.red, size: 14),
                    ),
                  ],
                ),
              ),
              Text(
                doc['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ));
    }).toList();
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
