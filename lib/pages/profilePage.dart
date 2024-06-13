import 'package:VideoChat/pages/EditProfilePage.dart';
import 'package:VideoChat/pages/phone_number.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedPic = "assets/user.png";
  String name = '' ;

  void signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => phone_number()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    setState(() {
      name = data['name'];
      selectedPic = data['photoURL'] ?? "assets/user.png";
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'YOUR PROFILE',
            style: GoogleFonts.sniglet(fontSize: 18, color: Colors.black),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/Arrow---Right-Circle.png',
                width: 30,
                height: 30,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                },
                child: Text('Edit'))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        selectedPic,
                        fit: BoxFit.cover,
                        width: 110,
                        height: 110,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: 4, bottom: 5),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            spreadRadius: 1.5,
                            blurRadius: 1.5)
                      ]),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: 4, bottom: 9),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            spreadRadius: 1.5,
                            blurRadius: 1.5)
                      ]),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          FirebaseAuth.instance.currentUser?.phoneNumber ??
                              "",style: TextStyle(fontSize: 18),)),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      signout();
                    },
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.sniglet(
                          fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 22, 22, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
