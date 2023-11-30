import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller ;
  final String hinttext ;
  final bool obscureText ;
  const MyTextField({super.key, required this.controller, required this.hinttext, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 20),
      decoration: BoxDecoration(
          border: Border.all(width: 1.5,color: Colors.black),
      ),
      child:TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none,hintText: hinttext),
      ),
    );
  }
}
