import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latest/chat/pages/auth/login_page.dart';
import 'package:latest/chat/service/auth_service.dart';
import 'package:latest/createPage.dart';
import 'package:latest/maps.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final loc.Location location = loc.Location();

  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  int _selectedIndex = 0;
  void _onItemTapped(int index) async {
    setState(() async {
      _selectedIndex = index;
      if (index == 2) {
        await AuthService().signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      if (index == 1) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Communauté",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ), // very important as noted

      bottomNavigationBar: BottomNavigationBar(
          elevation: 0, // to get rid of the shadow
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          backgroundColor: Color.fromARGB(255, 255, 255,
              255), // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility_off),
              label: 'Anonime',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Sortir',
            ),
          ]),
      body: StreamBuilder(
          stream: groups.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      _getLocation();
                      final grouNameStore =
                          await SharedPreferences.getInstance();
                      grouNameStore.setString(
                          "grouNameStore", document['groupName']);

                      final grouIpStore = await SharedPreferences.getInstance();
                      grouIpStore.setString("grouIpStore", document['groupId']);
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
                            vertical: 10, horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: HexColor('#FF5287').withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor('#FA7D82'),
                                HexColor('#6F72CA'),
                                HexColor('#B0F2B6')
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 34, left: 16, right: 16, bottom: 34),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo.png"),
                                          ), // button text
                                        )),
                                    Spacer(),
                                    Text(
                                      document['groupName'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        letterSpacing: 0.2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
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
          }),
    );
  }

  _getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String fullname = (prefs.getString('fullNameStore') ?? '');
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('locations')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': fullname
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
