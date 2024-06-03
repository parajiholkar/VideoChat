// import 'package:assignment/services/auth/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:provider/provider.dart';
// import 'SignallingService.dart';
//
// class JoinScreen extends StatefulWidget {
//   @override
//   _JoinScreenState createState() => _JoinScreenState();
// }
//
// class _JoinScreenState extends State<JoinScreen> {
//   final TextEditingController _nameController = TextEditingController(text: '');
//   SignallingService _signallingService = SignallingService();
//   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   String? roomId;
//
//   @override
//   void initState() {
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();
//
//     _signallingService.onAddRemoteStream = ((stream) {
//       _remoteRenderer.srcObject = stream;
//       setState(() {});
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _signallingService.hangUp(_localRenderer);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   int i = await _signallingService.openUserMedia(_localRenderer, _remoteRenderer);
//                   roomId = await _signallingService.createRoom(_remoteRenderer);
//                   _nameController.text = roomId!;
//                   setState(() {});
//                 },
//                 child: Text("Create Call"),
//               ),
//               SizedBox(
//                 width: 6,
//               ),
//               ElevatedButton(
//                 onPressed: () async{
//                   int i = await _signallingService.openUserMedia(_localRenderer, _remoteRenderer);
//                   _signallingService.joinRoom(
//                     _nameController.text.trim(),
//                     _remoteRenderer,
//                   );
//                 },
//                 child: Text("Join call"),
//               ),
//               SizedBox(
//                 width: 6,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _signallingService.hangUp(_localRenderer);
//                 },
//                 child: Text("Hangup"),
//               )
//             ],
//           ),
//           SizedBox(height: 6),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Call Joining Code: "),
//                 Flexible(
//                   child: TextFormField(
//                     controller: _nameController,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 5),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
//                   Expanded(child: RTCVideoView(_remoteRenderer)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import 'CallingScreen.dart';
import '../services/callingService/SignallingService.dart';
import 'HomePage.dart';

class JoiningScreen extends StatefulWidget {
  @override
  _JoiningScreenState createState() => _JoiningScreenState();
}

class _JoiningScreenState extends State<JoiningScreen> {
  final TextEditingController _roomIdController = TextEditingController();
  SignallingService _signallingService = SignallingService();
  RTCVideoRenderer remotevideorenderer = RTCVideoRenderer();
  RTCVideoRenderer localvideorenderer = RTCVideoRenderer();

  @override
  void initState() {
    remotevideorenderer.initialize();
    localvideorenderer.initialize();
    super.initState();
  }

  void _joinRoom() async {
    if (_roomIdController.text.isNotEmpty) {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        DocumentReference roomRef =
            db.collection('rooms').doc('${_roomIdController.text}');
        var roomSnapshot = await roomRef.get();

        if (roomSnapshot.exists) {
          try {
            await _signallingService.openUserMedia(
                localvideorenderer, remotevideorenderer);
            String roomId = _roomIdController.text;
            await _signallingService.joinRoom(roomId);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            // Navigate to the calling screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CallingScreen(
                          signallingService: _signallingService,
                          localVideoRenderer: localvideorenderer,
                          remoteVideoRenderer: remotevideorenderer,
                        )));
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Some thing is wrong")));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Call is not exists, Create New Call!")));
        }
      } else {
        showDialogBox();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Room ID")));
    }
  }

  void showDialogBox() {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12.0),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 15),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _roomIdController,
                      decoration: InputDecoration(
                          hintText: 'Enter Call ID', border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _joinRoom,
                        child: Text('Join Call'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool internetConnection =
                          await InternetConnectionChecker().hasConnection;
                          if (internetConnection) {
                            await _signallingService.openUserMedia(
                                localvideorenderer, remotevideorenderer);
                            _roomIdController.text =
                            await _signallingService.createRoom();
                            setState(() {});
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => HomePage()));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CallingScreen(
                                      signallingService: _signallingService,
                                      localVideoRenderer: localvideorenderer,
                                      remoteVideoRenderer: remotevideorenderer,
                                    )));
                          } else {
                            showDialogBox();
                          }
                        },
                        child: Text("Create Call"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15,right: 15),
                    child: Image.asset(
                      'assets/Video call-bro.png',
                    ),
                  ),
                  // CircleAvatar(
                  //   radius: 80,
                  //   backgroundColor: Colors.transparent,
                  //   child: Container(
                  //       height: 200,
                  //       width: 300,
                  //       child: ClipOval(
                  //         child: Image.asset(
                  //           'assets/phoneNumberScreen.jpg',
                  //           fit: BoxFit.fill,
                  //         ),
                  //       )),
                  // ),
                  SizedBox(height: 20.0),
                  Text(
                    "Let's Make a Video Call",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Click On Create Call Button and Share Call ID",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
