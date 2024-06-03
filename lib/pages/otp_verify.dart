import 'package:VideoChat/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:VideoChat/pages/phone_number.dart';
import 'NamePage.dart';

class otp_verify extends StatefulWidget {
  const otp_verify({super.key});

  @override
  State<otp_verify> createState() => _otp_verifyState();
}

class _otp_verifyState extends State<otp_verify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController verificationCode = TextEditingController();
  bool isProcessing = false;

  void verifyotp() async {

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: phone_number.verificationID,
          smsCode: verificationCode.text);
      UserCredential userCredential = await auth.signInWithCredential(credential);

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference usersRef =
      db.collection('users').doc('${userCredential.user!.uid}');
      var usersSnapshot = await usersRef.get();

      if(usersSnapshot.exists){
        setState(() {
          isProcessing = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
      }
      else{
        setState(() {
          isProcessing = false;
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NamePage()),
                (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }

  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Color.fromRGBO(114, 178, 238, 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              width: MediaQuery.of(context).size.width/1.5,
              child: Image.asset('assets/Mobile_login.png'),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 75),
              child: Column(
                children: [
                  Text(
                    "Verify Phone",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Code is send to ${phone_number.phone} ',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    controller: verificationCode,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn\'t receive the code? ",
                            style: TextStyle(fontSize: 15)),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Request Again',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if(!isProcessing && verificationCode.text.isNotEmpty){
                          setState(() {
                            isProcessing = true;
                          });
                          verifyotp();
                        }
                        else{
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Enter Verification Code')));
                        }
                      },
                      child: isProcessing
                          ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'VERIFY AND CONTINUE',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.alphaBlend(
                              Colors.blue.shade900, Colors.blue.shade500),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
