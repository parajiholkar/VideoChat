
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  bool? isckecked1 = false ;
  bool? isckecked2 = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Container(
        margin: EdgeInsets.only(left: 25,right: 25,top: 10),
        //comment
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
