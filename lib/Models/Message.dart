import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderPhoneNumber;
  final String receiverID;
  final String read;
  final String message;
  final String callID;
  final bool iscallID ;
  final Timestamp timestamp ;

  Message(
      {required this.senderID,
      required this.senderPhoneNumber,
      required this.receiverID,
      required this.read,
      required this.timestamp,
      required this.message,
      required this.callID,
      required this.iscallID
      });


  Map<String, dynamic> toMap(){
    return{
      'senderID': senderID,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverID': receiverID,
      'read' : read,
      'message': message,
      'callID' : callID,
      'iscallID' : iscallID,
      'timestamp': timestamp
    };
  }
}
