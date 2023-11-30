import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../Models/Message.dart';

class chatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String receiverID, String NMessage, String callID, bool iscallID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String phoneNumber =
        _firebaseAuth.currentUser!.phoneNumber.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentUserID,
        senderPhoneNumber: phoneNumber,
        receiverID: receiverID,
        timestamp: timestamp,
        message: NMessage,
        callID: callID,
        iscallID: iscallID,
        read: '');

    // construct chatRoomID from current userID and ReceiverID ( sorted to ensure uniqueness )
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    // add massage to database
    await _firestore
        .collection("chatRoom")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
        .collection("chatRoom")
        .doc(chatRoomID)
        .collection("message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
