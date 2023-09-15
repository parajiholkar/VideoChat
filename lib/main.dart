
import 'package:assignment/otp_verify.dart';
import 'package:assignment/phone_number.dart';
import 'package:assignment/select_language.dart';
import 'package:assignment/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'select_language',
    routes: {
      // routes
      'select_language' : (context) => select_language() ,
      'phone_number' : (context) =>phone_number() ,
      'otp_verify' : (context) => otp_verify(),
      'profile' : (context) => profile()
    },
  ));
}



