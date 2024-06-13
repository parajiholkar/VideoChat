import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chooseAvatar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Namecontroller = TextEditingController();
  String selectedPic = "assets/user.png";

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
      Namecontroller.text = data['name'];
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
          title: Center(
            child: Text(
              'EDIT YOUR PROFILE',
              textAlign: TextAlign.center,
              style: GoogleFonts.sniglet(fontSize: 18, color: Colors.black),
            ),
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
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                (AppBar().preferredSize.height * 2),
            width: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          CircleAvatar(
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
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChooseAvatarPage(
                                              onAvatarSelected: (avatar) {
                                                setState(() {
                                                  selectedPic = avatar;
                                                });
                                              },
                                            )));
                              },
                              child: Icon(
                                Icons.edit_rounded,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
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
                      child: TextFormField(
                        controller: Namecontroller,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Name',
                          suffix: Icon(
                            Icons.edit_rounded,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(Namecontroller.text.isNotEmpty){
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
                          'name': Namecontroller.text,
                          'photoURL': selectedPic,
                        }, SetOptions(merge: true));
                        Navigator.pop(context);
                        return ;
                      }

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Enter Name')));

                    },
                    child: Text(
                      'Update Profile',
                      style: GoogleFonts.sniglet(
                          fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 22, 22, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
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
