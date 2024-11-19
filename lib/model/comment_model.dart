import 'dart:developer';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lostandfound/model/message_model.dart';
import 'package:get/get.dart';
AuthenticationController authenticationController = Get.put(AuthenticationController());
class CommentModel {
  String? commentText;
  String? userName;
  String? imageUrl;
  String? userId;
  bool? pinned;
  DocumentReference<Map<String, dynamic>>? doc_ref;

  CommentModel({
    this.commentText,
    this.userName,
    this.imageUrl,
    this.userId,
    this.doc_ref,
    this.pinned ,
  });
  CommentModel.fromSnamshot(DocumentSnapshot<Map<String, dynamic>> data) {

    userId = data.data()!["user_id"] ?? "";
    userName = data.data()!["userName"] ?? "";
    imageUrl = data.data()!["photoUrl"] ?? "";
    commentText = data.data()!["comment_text"] ?? '';
    doc_ref = data.reference;
    authenticationController.getUser();
    pinned = data.data()![authenticationController.getUserData.userId!] ?? false;
  }
}
