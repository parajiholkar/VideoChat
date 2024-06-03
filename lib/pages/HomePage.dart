import 'package:VideoChat/pages/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../services/callingService/SignallingService.dart';
import 'ChatPage.dart';
import 'JoinScreen.dart';
import 'profilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => phone_number()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('VideoChat'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text('Chats',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Calls',style: TextStyle(fontWeight: FontWeight.bold),),
                )
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: TabBarView(children: [ChatPage(), JoiningScreen()])),
    );
  }
}
