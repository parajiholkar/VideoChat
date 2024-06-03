import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseAvatarPage extends StatefulWidget {
  final Function(String) onAvatarSelected;
  const ChooseAvatarPage({super.key, required this.onAvatarSelected});

  @override
  State<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends State<ChooseAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 252, 252, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Center(
            child: Text(
              'CHOOSE AVATAR',
              textAlign: TextAlign.center,
              style: GoogleFonts.sniglet(fontSize: 18),
            ),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/Arrow---Right-Circle.png',
                width: 30,
                height: 30,
              )),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){
                          widget.onAvatarSelected('assets/image 28 (1).png');
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image 28 (1).png',
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.onAvatarSelected('assets/image 27 (1).png');
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image 27 (1).png',
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){
                          widget.onAvatarSelected('assets/image 28.png');
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image 28.png',
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.onAvatarSelected('assets/image 27.png');
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/image 27.png',
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
