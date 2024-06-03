import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'otp_verify.dart';

class phone_number extends StatefulWidget {
  static var phone;
  static var email = "";

  static String verificationID = "";
  const phone_number({super.key});

  @override
  State<phone_number> createState() => _phone_numberState();
}

class _phone_numberState extends State<phone_number> {
  TextEditingController countrycode = TextEditingController();
  final emailcontroller = TextEditingController();
  var Phone_number = "";
  bool isProcessing = false;

  void sendotp({required String phoneNumber}) async {
    bool internetConnection = await InternetConnectionChecker().hasConnection;
    if (internetConnection) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '${countrycode.text + Phone_number}',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isProcessing = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
          },
          codeSent: (String verificationId, int? resendToken) {
            phone_number.verificationID = verificationId;
            phone_number.phone = '${countrycode.text + Phone_number}';
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => otp_verify()));
            setState(() {
              isProcessing = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isProcessing = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    } else {
      showAlertDialogBox();
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    countrycode.text = '+91';
    super.initState();
  }

  void showAlertDialogBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              icon: Icon(Icons.signal_wifi_connected_no_internet_4_outlined),
              title:
                  Text('No Internet Connection', textAlign: TextAlign.center),
              content: Text(
                'Please Check Your Internet Connectivity',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'cancel');
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
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
                    child: Image.asset('assets/Mobile_login.png'),
                  ),
                  Text(
                    "Please enter your mobile number",
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
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: countrycode,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              Phone_number = value.trim();
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile Number'),
                          ),
                        ),
                      ],
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
                        if (!isProcessing && Phone_number.length == 10) {
                          setState(() {
                            isProcessing = true;
                          });
                          sendotp(
                              phoneNumber: '${countrycode.text + Phone_number}');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Enter Valid Phone Number")));
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
          ],
        ),
      ),
    );
  }
}
