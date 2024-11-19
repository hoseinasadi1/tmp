import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? senderId;
  String? senderName;
  String? email;
  String? imageUrl;
  String? dateTime;
  String? senderToken;
  String? id;
  String? txtMessage;
  String? content;

  NotificationModel(
      {this.dateTime,
      this.id,
      this.email,
      this.imageUrl,
      this.senderId,
      this.content,
      this.txtMessage,
      this.senderName,
      this.senderToken});

  NotificationModel.fromSnapSHot(
      QueryDocumentSnapshot<Map<String, dynamic>> data) {
    id = data.id;
    senderId = data["sender_id"] ?? "";
    senderName = data["name"] ?? "";
    email = data["email"] ?? '';
    imageUrl = data["image_url"] ?? '';
    senderToken = data["sender_token"] ?? '';
    txtMessage = data["txt_message"] ?? '';
    content = data["content"];
  }
}
