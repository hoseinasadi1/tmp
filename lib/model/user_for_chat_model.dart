import 'package:cloud_firestore/cloud_firestore.dart';

class UserForChat {
  String? userName;
  String? userEmail;
  String? userPhotoUrl;
  String? id;
  String? token;
  String? unreadMessage;
  String? lastMessage;
  UserForChat(
      {this.userEmail,
      this.userName,
      this.userPhotoUrl,
      this.id,
      this.token,
      this.unreadMessage});

  UserForChat.fromSnapSHot(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    id = data.id;
    userName = data["user_name"] ?? "";
    userEmail = data["user_email"] ?? "";
    userPhotoUrl = data["user_image"] ?? '';
    token = data["token"] ?? '';
    unreadMessage = data["un_read_message"].toString();
    lastMessage = data["lastMessage"];

    print('photo url is $userPhotoUrl');
  }
}
