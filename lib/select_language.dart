import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class select_language extends StatefulWidget {
  const select_language({super.key});

  @override
  State<select_language> createState() => _select_languageState();
}

class _select_languageState extends State<select_language> {

  var valuechoose  ;
  List items = ['English','Hindi'] ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25,right: 25,top: 75),
        child: Column(
          children: [
            Container(
              height: 55,
                width: 55,
                margin: EdgeInsets.only(bottom: 15),
                child: Image.asset('assets/image.png')
            ),
            Text(
            "Please select your Language",
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
          ),
            SizedBox(
              height: 15,
            ),
            Text('You can change the language\nat any time',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(left: 25,right: 25),
              margin: EdgeInsets.only(left: 45,right: 45),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5,color: Colors.black)
              ),
              child: DropdownButton(
                isExpanded: true,
                hint: Text('${items.first}'),
                icon: Icon(Icons.arrow_drop_down_sharp),
                  items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                child: Text(item),
              );
              }).toList() ,value: valuechoose, onChanged: (newvalue){
                setState(() {
                  valuechoose = newvalue ;
                });
              }),

            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 45,right: 45),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, 'phone_number') ;

                }, child: Text('NEXT',style: TextStyle(fontSize: 20),),style: ElevatedButton.styleFrom(
                    primary: Color.alphaBlend(Colors.blue.shade900
                        , Colors.blue.shade500),shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero
                )
                ),),
              ),
            ),
          ],
        ),
      ),
    ) ;
  }
}
