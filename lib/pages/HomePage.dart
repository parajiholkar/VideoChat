import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChatPage.dart';
import 'JoinScreen.dart';
import 'profilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> getData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    return data['photoURL'] ?? "assets/user.png";
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
                  child: Text(
                    'Chats',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Calls',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {

                      if(snapshot.hasError){
                        return CircleAvatar(
                          child: Image.asset(
                            "assets/user.png",
                            fit: BoxFit.fill,
                          ),
                        );
                      }

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CircleAvatar(
                          child: Image.asset(
                            "assets/user.png",
                            fit: BoxFit.fill,
                          ),
                        );
                      }

                      if(snapshot.hasData){
                        return CircleAvatar(
                          child: Image.asset(
                            snapshot.data ?? "assets/user.png",
                            fit: BoxFit.fill,
                          ),
                        );
                      }

                      return CircleAvatar(
                        child: Image.asset(
                          snapshot.data ?? "assets/user.png",
                          fit: BoxFit.fill,
                        ),
                      );
                    }),
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
