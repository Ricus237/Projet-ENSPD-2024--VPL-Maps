import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:io';

class profilePage extends StatefulWidget {
  final username;

  var groupName;

  var groupId;

  var number;

  var email;

  profilePage(
      {Key? key,
      required this.username,
      required this.email,
      required this.number,
      required this.groupName,
      required this.groupId})
      : super(key: key);
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final key = GlobalKey();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  File? file;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        title: 'VPL Maps',
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Profil utilisateur',
              ),
              centerTitle: true,
            ),
            body: StreamBuilder(
                stream: users
                    .where('email',
                        isEqualTo: FirebaseAuth.instance.currentUser?.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  var a = widget.username;
                  var b = widget.groupName;
                  var c = FirebaseAuth.instance.currentUser?.email;
                  var d = widget.groupId;
                  String qrData =
                      "{Nom: $a + Group: $b + Email: $c + GroupId: $d}";
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Form(
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 15),
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width: 130,
                                                    height: 130,
                                                    decoration:
                                                        const BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/logo.png'),
                                                    )),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Nom d'utilisateur:",
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 9,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.username,
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.email,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Email :",
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 9),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.email,
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.people,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Communauté",
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.groupName,
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.key,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "ID de la communauté: ",
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.groupId,
                                                        style: GoogleFonts
                                                            .dancingScript(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              )),
                                        )
                                      ]))));
                    }).toList(),
                  );
                })));
  }
}
