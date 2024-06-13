import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChatingPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: const Text('Error',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: const Text('loading....',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.phoneNumber != data['phoneNumber']) {
      return ListTile(
        leading: CircleAvatar(
          child: Image.asset(
            data['photoURL'] ?? "assets/user.png",
            fit: BoxFit.fill,
          ),
        ),
        title: Text(data['name']),
        subtitle: Text(data['phoneNumber']),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatingPage(
                        receiverUserPhoneNumber: data['phoneNumber'],
                        receiverUserName: data['name'],
                        receiverUserId: data['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }
}
