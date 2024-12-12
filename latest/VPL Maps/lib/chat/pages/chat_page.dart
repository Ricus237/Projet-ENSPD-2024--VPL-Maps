import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latest/createPage.dart';
import 'package:latest/maps.dart';
import 'package:latest/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/database_service.dart';
import '../widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String a = "";
String b = "";
String c = "";

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  File? imageFile;

  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) async {
    setState(() async {
      _selectedIndex = index;
      if (index == 2) {}

      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Maps(
                      groupId: widget.groupId,
                    )));
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
        actions: [
          IconButton(
              color: Colors.white,
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
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: GoogleFonts.dancingScript(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
      body: Stack(
        children: <Widget>[
          Container(
            child: chatMessages(),
          ),
          // chat messages here

          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe:
                        widget.userName == snapshot.data.docs[index]['sender'],
                    day: snapshot.data.docs[index]['day'].toString(),
                    hour: snapshot.data.docs[index]['hour'].toString(),
                    minute: snapshot.data.docs[index]['minute'].toString(),
                    month: snapshot.data.docs[index]['month'].toString(),
                    year: snapshot.data.docs[index]['year'].toString(),
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String fullname = (prefs.getString('fullNameStore') ?? '');
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": fullname,
        "time": DateTime.now().millisecondsSinceEpoch,
        "day": DateTime.now().day,
        "hour": DateTime.now().hour,
        "minute": DateTime.now().minute,
        "month": DateTime.now().month,
        "year": DateTime.now().year,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
