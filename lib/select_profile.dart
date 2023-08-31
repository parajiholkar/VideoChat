import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class select_profile extends StatefulWidget {
  const select_profile({super.key});

  @override
  State<select_profile> createState() => _select_profileState();
}

class _select_profileState extends State<select_profile> {
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
        margin: EdgeInsets.only(left: 25,right: 25,top: 75),
        child: Column(
          children: [Text(
            "Please select your profile",
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
          ),
            SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5,color: Colors.black)
              ),
              child: Container(
                child: Row(
                  children: [
                    Checkbox(
                        value: isckecked1, onChanged: (newbool){
                      setState(() {
                        isckecked1 = newbool ;
                        if(isckecked1 == true ){
                          isckecked2 = false ;
                        }else{
                          isckecked2 = true ;
                        }
                      });
                    },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),),
                    Container(
                      height: 72,
                      width: 72,
                      child: Image.asset('assets/icons8-country-house-50.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                    Row(
                    children: [Text("Shipper" , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,)],
                ),
                        Text("lorem ipsum dorol sit amet,\nconsectetur adipiscing" , style: TextStyle(fontSize: 13),)
                      ],
                    )

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5,color: Colors.black)
              ),
              child: Container(
                child: Row(
                  children: [
                    Checkbox(
                      value: isckecked2, onChanged: (newbool){
                      setState(() {
                        isckecked2 = newbool ;
                        if(isckecked2 == true ){
                          isckecked1 = false ;
                        }else{
                          isckecked1 = true ;
                        }
                      });
                    },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      child: Image.asset('assets/truck.png'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                        children: [
                          Row(
                            children: [Text("Transporter" , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,)],
                          ),
                          Text("lorem ipsum dorol sit amet,\nconsectetur adipiscing" , style: TextStyle(fontSize: 13),)
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () {
                if(isckecked1 == true){
                  print("done1");
                }
                else if(isckecked2 == true){
                  print("done2");
                }
                else{
                  print('wrong') ;
                }

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
