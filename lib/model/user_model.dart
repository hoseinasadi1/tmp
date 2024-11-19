import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? userName;
  String? imageUrl;
  String? userId;
  String? oneSinalId;
  UserModel(
      {this.userName,
      this.firstName,
      this.imageUrl,
      this.lastName,
      this.userId,
      this.oneSinalId});
  UserModel.fromSnamshot(DocumentSnapshot<Map<String, dynamic>> data) {
    userId = data.id;

    userName = data.data()!["userName"] ?? "";
    imageUrl = data.data()!["photoUrl"] ?? "";
    firstName = data.data()!["firstname"] ?? "";

    lastName = data.data()!["lastname"] ?? '';
    oneSinalId = data.data()!["oneSinalId"] ?? '';

    log('user emial is $userName');
    log('user first is $firstName');
  }
}
