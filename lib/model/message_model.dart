import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderid;
  String? txtMessage;
  String? id;
  String? dateTime;

  MessageModel({
    this.senderid,
    this.txtMessage,
    this.dateTime,
  });

  MessageModel.fromSnapSHot(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    id = data.id;
    senderid = data["sender_id"] ?? "";
    dateTime = data["date_time"] ?? "";
    txtMessage = data["txtMessage"] ?? "";
  }
}
