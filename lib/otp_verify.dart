import 'package:assignment/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class otp_verify extends StatefulWidget {
  const otp_verify({super.key});

  @override
  State<otp_verify> createState() => _otp_verifyState();
}

class _otp_verifyState extends State<otp_verify> {
  final FirebaseAuth auth = FirebaseAuth.instance ;
  var verificationCode ;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Color.fromRGBO(114, 178, 238, 0.9),
        borderRadius: BorderRadius.circular(0),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded,color: Colors.black,),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25,right: 25,top: 75),
        child: Column(
          children: [Text(
            "Verify Phone",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
          ),
            SizedBox(
              height: 15,
            ),
            Text('Code is send to ${phone_number.phone} ',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
            SizedBox(
              height: 25,
            ),
            Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              keyboardType: TextInputType.number,
              showCursor: true,
              onChanged: (value){
                verificationCode = value ;
              },
            ),
            Container(
                alignment: Alignment.center,
              child: Row(
                children: [SizedBox(
                  width: 45,
                ),Text("Didn\'t receive the code? ",style: TextStyle(fontSize: 15)),TextButton(onPressed: (){}, child: Text('Request Again',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),))],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () async{
                try{
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: phone_number.verificationID, smsCode: verificationCode);
                  await auth.signInWithCredential(credential);
                  Navigator.pushNamed(context, 'select_profile');
                }catch(e){

                }
              }, child: Text('VERIFY AND CONTINUE',style: TextStyle(fontSize: 20),),style: ElevatedButton.styleFrom(
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
