import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../services/callingService/SignallingService.dart';
import '../services/chat/chat_Service.dart';

class CallingScreen extends StatefulWidget {
  final SignallingService signallingService;
  final RTCVideoRenderer localVideoRenderer;
  final RTCVideoRenderer remoteVideoRenderer;
  const CallingScreen({
    super.key,
    required this.signallingService,
    required this.localVideoRenderer,
    required this.remoteVideoRenderer,
  });

  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  chatService _chatservice = chatService();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.localVideoRenderer.dispose();
    widget.remoteVideoRenderer.dispose();
    widget.signallingService.hangUp(widget.localVideoRenderer);
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to End the Call?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  widget.signallingService.hangUp(widget.localVideoRenderer);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Call END")));
                  Navigator.pop(context);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
            ],
          ),
        ) ??
        false; // Return false by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: _onBackPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.0),
            Container(
              height: 50,
              child: Card(
                elevation: 3,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Call ID : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          SelectableText(
                            '${widget.signallingService.roomID}',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: _showUserlist,
                        icon: Icon(Icons.send_rounded, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            _buildCallStatusSteam(),
            // _buildConnectionSteam(),
            SizedBox(height: 5.0),
            Expanded(
              child: Stack(
                children: [
                  _buildRemoteRTCVideo(),
                  _buildLocalRTCVideo(),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.signallingService.hangUp(widget.localVideoRenderer);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Call END")));
                Navigator.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Hang Up'),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildRemoteRTCVideo() {
    return StreamBuilder<MediaStream>(
      stream: widget.signallingService.remoteStreamStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          widget.remoteVideoRenderer.srcObject = snapshot.data;
        }

        return RTCVideoView(widget.remoteVideoRenderer);
      },
    );
  }

  Widget _buildLocalRTCVideo() {
    return StreamBuilder<MediaStream>(
      stream: widget.signallingService.localStreamStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: 80,
            height: 160,
            alignment: Alignment.bottomRight,
            child: Center(child: Text("Error")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              width: 80,
              height: 160,
              alignment: Alignment.bottomRight,
              child: Center(
                child: CircularProgressIndicator(),
              ));
        }

        if (snapshot.hasData) {
          widget.localVideoRenderer.srcObject = snapshot.data;
        }

        return Container(
          width: 80,
          height: 160,
          alignment: Alignment.bottomRight,
          child: RTCVideoView(
            widget.localVideoRenderer,
            mirror: true,
          ),
        );
      },
    );
  }

  Widget _buildCallStatusSteam() {
    return StreamBuilder<CallStatus>(
        stream: widget.signallingService.CallStatusStreamStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text(
                "Waiting...",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data == CallStatus.disconnected) {
              return Center(
                child: Text(
                  "Disconnected",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (snapshot.data == CallStatus.connecting) {
              return Center(
                child: Text(
                  "Connecting",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              );
            }
            if (snapshot.data == CallStatus.connected) {
              return Center(
                child: Text(
                  "connected",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              );
            }
          }
          return Container(
            height: 0,
          );
        });
  }

  // Widget _buildConnectionSteam(){
  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance
  //           .collection('rooms')
  //           .doc('${widget.signallingService.roomID}')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData &&
  //             snapshot.data != null &&
  //             snapshot.data!.exists) {
  //           return Container(
  //             height: 0,
  //           );
  //         } else {
  //           return Center(
  //             child: Text(
  //               "Disconnected",
  //               style: TextStyle(
  //                   fontSize: 15, fontWeight: FontWeight.bold),
  //             ),
  //           );
  //         }
  //       });
  // }

  void _showUserlist() async {
    print("user list : ");
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> userlist = snapshot.docs
        .map((document) => document.data() as Map<String, dynamic>)
        .where((data) =>
            FirebaseAuth.instance.currentUser!.phoneNumber !=
            data['phoneNumber'])
        .toList();

    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Send Call ID"),
              icon: Icon(Icons.send_rounded),
              iconColor: Theme.of(context).primaryColorDark,
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userlist.length,
                  itemBuilder: (context, i) => _buildUserListItem(userlist[i],context),
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'cancel');
                    },
                    child: const Text('Close'))
              ],
            ));
  }

  Widget _buildUserListItem(Map<String, dynamic> data, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black12,
        child: Icon(
          Icons.person,
          size: 30,
          color: Colors.black,
        ),
      ),
      title: Text(data['name']),
      subtitle: Text(data['phoneNumber']),
      onTap: () async {
        await _chatservice.sendMessage(
            data['uid'],'To Join The Call Click On the Join Call', '${widget.signallingService.roomID}',true);
        Navigator.pop(context, 'cancel');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Call ID => ${widget.signallingService.roomID} is Send To ${data['name']}")));
      },
    );
  }
}
