import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class phone_number extends StatefulWidget {
  static var phone ;
  static String verificationID = "" ;
  const phone_number({super.key});

  @override
  State<phone_number> createState() => _phone_numberState();
}

class _phone_numberState extends State<phone_number> {
  TextEditingController countrycode = TextEditingController();
  var Phone_number = "";

  @override
  void initState() {
    countrycode.text = '+91' ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded,color: Colors.black,),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25,right: 25,top: 75),
          child: Column(
            children: [Text(
              "Please enter your mobile number",
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
            ),
              SizedBox(
              height: 15,
            ),
              Text('You\'ll receive a 6 digit code\nto verify next',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5,color: Colors.black)
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 25,
                      width: 30,
                      child: Image.asset('assets/tiranga.jpg'),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: countrycode,
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Text('-' ,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          Phone_number = value ;
                        },
                        decoration: InputDecoration(border: InputBorder.none,hintText: 'Mobile Number'),
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
                child: ElevatedButton(onPressed: () async{
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '${countrycode.text+Phone_number}',
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        phone_number.verificationID = verificationId ;
                        phone_number.phone = Phone_number ;
                        Navigator.pushNamed(context, 'otp_verify') ;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );


                }, child: Text('CONTINUE',style: TextStyle(fontSize: 20),),style: ElevatedButton.styleFrom(
                  primary: Color.alphaBlend(Colors.blue.shade900

                      , Colors.blue.shade500),shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero
                )
                ),),
              ),
            ],
          ),
      ),
    );
  }
}
