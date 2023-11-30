import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../services/callingService/SignallingService.dart';
import '../services/chat/chat_Service.dart';
import 'CallingScreen.dart';

class ChatingPage extends StatefulWidget {
  final String receiverUserPhoneNumber;
  final String receiverUserName;
  final String receiverUserId;
  const ChatingPage(
      {super.key,
      required this.receiverUserPhoneNumber,
      required this.receiverUserName,
      required this.receiverUserId});

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  SignallingService _signallingService = SignallingService();
  RTCVideoRenderer _remotevideorenderer = RTCVideoRenderer();
  RTCVideoRenderer _localvideorenderer = RTCVideoRenderer();
  final TextEditingController _messageController = TextEditingController();
  final chatService _chatService = chatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isProcessing = false;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text, '', false);
      _messageController.clear();
    }
  }

  void _joinRoom(String roomId) async {
    if (roomId.isNotEmpty) {
      bool internetConnection = await InternetConnectionChecker().hasConnection;
      if (internetConnection) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        DocumentReference roomRef = db.collection('rooms').doc('${roomId}');
        var roomSnapshot = await roomRef.get();

        if (roomSnapshot.exists) {
          try {
            await _remotevideorenderer.initialize();
            await _localvideorenderer.initialize();
            await _signallingService.openUserMedia(
                _localvideorenderer, _remotevideorenderer);
            await _signallingService.joinRoom(roomId);
            setState(() {
              isProcessing = false;
            });

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatingPage(
                          receiverUserPhoneNumber:
                              widget.receiverUserPhoneNumber,
                          receiverUserName: widget.receiverUserName,
                          receiverUserId: widget.receiverUserId,
                        )));
            // Navigate to the calling screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CallingScreen(
                          signallingService: _signallingService,
                          localVideoRenderer: _localvideorenderer,
                          remoteVideoRenderer: _remotevideorenderer,
                        )));
          } catch (e) {
            isProcessing = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Some thing is wrong")));
          }
        } else {
          isProcessing = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Call is not exists, Create New Call!")));
        }
      } else {
        isProcessing = false;
        showDialogBox();
      }
    } else {
      isProcessing = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Room ID")));
    }
  }

  void showDialogBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(
                Icons.person,
                size: 25,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverUserName),
                Text(
                  widget.receiverUserPhoneNumber,
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
          widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            "Error${snapshot.error}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> messages = snapshot.data!.docs
            .map((document) => document.data() as Map<String, dynamic>)
            .toList();

        return _buildGroupedList(messages);
      },
    );
  }

  Widget _buildGroupedList(List<Map<String, dynamic>> messages) {
    return GroupedListView<dynamic, DateTime>(
        elements: messages,
        groupBy: (message) {
          Timestamp timestamp = message['timestamp'];
          DateTime datetime = timestamp.toDate();
          return DateTime(datetime.year, datetime.month, datetime.day);
        },
        order: GroupedListOrder.DESC,
        reverse: true,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (DateTime date) => SizedBox(
              height: 35,
              child: Center(
                child: Card(
                  color: Theme.of(context).hintColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_numberToMonthMap[date.month]} ${date.day}, ${date.year}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        itemBuilder: (context, dynamic message) => Align(
              alignment: (message['senderID'] == _firebaseAuth.currentUser!.uid)
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: _buildMessageItem(message),
            ));
  }

  Widget _buildMessageItem(dynamic message) {
    var margin = (message['senderID'] == _firebaseAuth.currentUser!.uid)
        ? EdgeInsets.only(left: 80, top: 5, right: 10)
        : EdgeInsets.only(left: 10, top: 5, right: 80);

    Timestamp timestamp = message['timestamp'];
    DateTime dateTime = timestamp.toDate();

    return Container(
      margin: margin,
      child: Card(
        elevation: 3,
        color: (message['senderID'] == _firebaseAuth.currentUser!.uid)
            ? Theme.of(context).primaryColorDark
            : Colors.white,
        shape: (message['senderID'] == _firebaseAuth.currentUser!.uid)
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)))
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                message['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: (message['senderID'] == _firebaseAuth.currentUser!.uid)
                      ? Colors.white
                      : Theme.of(context).primaryColorDark,
                ),
              ),
              (message['iscallID'] != null && message['iscallID'])
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableText(
                          message['callID'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: (message['senderID'] ==
                                _firebaseAuth.currentUser!.uid)
                                ? Colors.white
                                : Theme.of(context).primaryColorDark,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              if (!isProcessing) {
                                _joinRoom(message['callID']);
                                setState(() {
                                  isProcessing = true;
                                });
                              }
                            },
                            child: Text('Join Call'))
                      ],
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              Text(
                '${TimeOfDay.fromDateTime(dateTime).format(context)}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  var _numberToMonthMap = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  Widget _buildMessageInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 5),
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1.5, color: Colors.grey)),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Message"),
                ),
              ),
            ),
            IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.send_sharp,
                  size: 30,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
