import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chooseAvatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PhoneNumbercontroller = TextEditingController(text: 'Phone Number');
  final Namecontroller = TextEditingController(text: 'Name');
  final Emailcontroller = TextEditingController(text: 'Email ID ');
  final DOBcontroller = TextEditingController(text: 'Date of Birth');
  final Gendercontroller = TextEditingController(text: 'Gender');
  String selectedPic = "assets/image 21.png" ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Center(
            child: Text(
              'YOUR PROFILE',
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                (AppBar().preferredSize.height * 2),
            width: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                selectedPic,
                                fit: BoxFit.cover,
                                width: 110,
                                height: 110,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChooseAvatarPage(
                                              onAvatarSelected: (avatar) {
                                                setState(() {
                                                  selectedPic =
                                                      avatar;
                                                });
                                              },
                                            )));
                              },
                              child: Image.asset(
                                'assets/Vector1.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                spreadRadius: 1.5,
                                blurRadius: 1.5)
                          ]),
                      child: TextFormField(
                        controller: PhoneNumbercontroller,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Image.asset('assets/Vector2.png')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                spreadRadius: 1.5,
                                blurRadius: 1.5)
                          ]),
                      child: TextFormField(
                        controller: Namecontroller,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Image.asset('assets/Vector2.png')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                spreadRadius: 1.5,
                                blurRadius: 1.5)
                          ]),
                      child: TextFormField(
                        controller: Emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Image.asset('assets/Vector2.png')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                spreadRadius: 1.5,
                                blurRadius: 1.5)
                          ]),
                      child: TextFormField(
                        controller: DOBcontroller,
                        keyboardType: TextInputType.datetime,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Image.asset('assets/Vector2.png')),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                spreadRadius: 1.5,
                                blurRadius: 1.5)
                          ]),
                      child: TextFormField(
                        controller: Gendercontroller,
                        style: GoogleFonts.sniglet(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            suffix: Image.asset('assets/Vector2.png')),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Update Profile',
                      style: GoogleFonts.sniglet(
                          fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(255, 22, 22, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
