import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'HomePage.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  TextEditingController _nameEditingController = TextEditingController();
  bool isProcessing = false;

  void saveData()async{
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'name': _nameEditingController.text,
        'phoneNumber': FirebaseAuth.instance.currentUser!.phoneNumber,
      }, SetOptions(merge: true));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);

      setState(() {
        isProcessing = false;
      });
    }
    catch (e){

      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 120),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image.asset('assets/image.png'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Please enter your Name",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You\'ll receive a 6 digit code\nto verify next',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(8)),
                      child: TextField(
                        controller: _nameEditingController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Your Name'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if(!isProcessing && _nameEditingController.text.isNotEmpty){
                            setState(() {
                              isProcessing = true;
                            });
                            saveData();
                          }
                          else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Enter Your Name")));
                          }
                        },
                        child: isProcessing
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          'CONTINUE',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Color.alphaBlend(
                                Colors.blue.shade900, Colors.blue.shade500),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              WaveWidget(
                config: CustomConfig(
                    colors: [Color.alphaBlend(
                        Colors.blue.shade900, Colors.blue.shade500),Theme.of(context).primaryColorDark,],
                    durations: [3500, 1944],
                    heightPercentages: [0.20, 0.35]),
                size: Size(double.infinity, 450),
              )
            ],
          ),
      ),
    );
  }
}
