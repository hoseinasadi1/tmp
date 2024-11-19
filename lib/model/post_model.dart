import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postTitle;
  String? postDescription;
  String? postUrl;
  String? postLocation;
  String? firstName;
  String? lastName;
  String? userName;
  String? imageUrl;
  String? userId;
  String? objectType;
  String? postId;
  String? lat;
  String? lng;
  String? oneSignalId;
  DocumentReference<Map<String, dynamic>>? doc_ref;
  String? date_time;
  PostModel(
      {this.postDescription,
      this.postLocation,
      this.postTitle,
      this.postUrl,
      this.userName,
      this.firstName,
      this.imageUrl,
      this.lastName,
      this.objectType,
      this.userId,
      this.postId,
      this.lat,
      this.oneSignalId,
      this.lng,
        this.doc_ref,
        this.date_time,
      });
  PostModel.fromSnamshot(DocumentSnapshot<Map<String, dynamic>> data) {
    postId = data.id;
    // try {
    //   date_time = data.data()!["date_time"] ?? '';
    // } catch (e) {
    //   print("errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    //   print(e);
    // }
    date_time = data.data()!["date_time"].toString() ?? '';
    userId = data.data()!["user_id"] ?? "";
    userName = data.data()!["userName"] ?? "";
    imageUrl = data.data()!["photoUrl"] ?? "";
    firstName = data.data()!["firstname"] ?? "";
    lastName = data.data()!["lastname"] ?? '';
    postUrl = data.data()!["post_photoUrl"] ?? "";
    postDescription = data.data()!["post_description"] ?? "";
    postLocation = data.data()!["post_location"] ?? "";
    postTitle = data.data()!["post_title"] ?? '';
    objectType = data.data()!["object_Type"] ?? '';
    lat = data.data()!["lat"] ?? '';
    lng = data.data()!["lng"] ?? '';
    oneSignalId = data.data()!['oneSinalId'] ?? '';
    log('post url ${postUrl} ');
    doc_ref = data.reference;

  }
}
