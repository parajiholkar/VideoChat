
import 'package:assignment/pages/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

import '../services/callingService/SignallingService.dart';
import 'ChatPage.dart';
import 'JoinScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => phone_number()), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Home Page'),
          actions: [
            IconButton(onPressed: signout, icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(
                child: Text(
                  'Chats',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  'Calls',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ]),
            Expanded(
                child: TabBarView(
                    children: [
                      ChatPage(),
                      JoiningScreen()
                    ]
                )
            )
          ],
        ),
      ),
    );
  }
}
