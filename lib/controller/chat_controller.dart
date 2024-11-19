import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lostandfound/model/message_model.dart';
import 'package:lostandfound/model/user_for_chat_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ChatController extends GetxController {
  TextEditingController txtMessageCOn = TextEditingController();

  Rx<List<UserForChat>> userForChatList = Rx<List<UserForChat>>([]);

  List<UserForChat> get getalluserForChat => userForChatList.value;

  Rx<List<UserForChat>> unReaduser = Rx<List<UserForChat>>([]);

  List<UserForChat> get getunReaduser => unReaduser.value;

  Rx<List<MessageModel>> allMessage = Rx<List<MessageModel>>([]);

  List<MessageModel> get getAllMessage => allMessage.value;

  getAllMessageFunc(String userId, String receiverId) {
    allMessage.bindStream(getAllMessageStream(userId, receiverId));
  }

  getallUser(String userID) {
    userForChatList.bindStream(getAllUserforChatStream(userID));
  }

  Stream<List<MessageModel>> getAllMessageStream(
      String userId, String receiverId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('usersForChat')
        .doc(receiverId)
        .collection('chat')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      List<MessageModel> retVal = [];
      for (var element in event.docs) {
        retVal.add(MessageModel.fromSnapSHot(element));
      }
      print('Message list is    ${retVal.length}');
      return retVal;
      //return event;
    });
  }

  setAllRead() {}

  Stream<List<UserForChat>> getAllUserforChatStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('usersForChat')
        .snapshots()
        .map((event) {
      List<UserForChat> retVal = [];
      for (var element in event.docs) {
        retVal.add(UserForChat.fromSnapSHot(element));
      }

      print('user list is    ${retVal.length}');
      return retVal;
      //return event;
    });
  }

  Future sendMessage({
    required String senderID,
    required String senderName,
    required String senderEmail,
    required String senderImage,
    required String receiverID,
    required String receiverName,
    required String receiverEmail,
    required String receiverImage,
    required String txtMessage,
    required String receiverToken,
    required String senderToken,
  }) async {
    print('receiver token is$receiverToken');
    print('sender id is$senderID');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    FirebaseFirestore.instance
        .collection('users')
        .doc(senderID)
        .collection('usersForChat')
        .doc(receiverID)
        .get()
        .then((value) {
      if (value.exists) {
        print('value exist');
        FirebaseFirestore.instance
            .collection('users')
            .doc(senderID)
            .collection('usersForChat')
            .doc(receiverID)
            .collection('chat')
            .add({
          'txtMessage': txtMessage,
          'time': DateTime.now(),
          'sender_id': senderID,
          'is_read': false,
          "date_time": formattedDate,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(senderID)
              .collection('usersForChat')
              .doc(receiverID)
              .update({'lastMessage': txtMessage});

          OneSignal.shared.postNotification(OSCreateNotification(
            additionalData: {
              "sender_id": senderID,
              "name": senderName,
              "email": senderEmail,
              "image_url": senderImage,
              "sender_token": senderToken,
              "txt_message": txtMessage,
              'is_comment': false,
              'receiver_id': receiverID
            },
            heading: "$senderName sent you message",
            // subtitle: dialogNotifiactionTitelController.text,
            playerIds: [receiverToken],
            content: txtMessage,
          ));

          // OneSignal.shared.postNotification(OSCreateNotification(
          //   additionalData: {
          //     "sender_id": senderID,
          //     "name": senderName,
          //     "email": senderEmail,
          //     "image_url": senderImage,
          //     "date_time": formattedDate,
          //     "sender_token": senderToken,
          //     "txt_message": txtMessage,
          //     'is_read': false,
          //   },
          //   heading: "$senderName sent you message",
          //   // subtitle: dialogNotifiactionTitelController.text,
          //   playerIds: [receiverToken],
          //   content: "$txtMessage",
          // ));
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverID)
              .collection('usersForChat')
              .doc(senderID)
              .collection('chat')
              .add({
            'txtMessage': txtMessage,
            'time': DateTime.now(),
            'sender_id': senderID,
            'is_read': false,
            "date_time": formattedDate,
          }).then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(receiverID)
                .collection('usersForChat')
                .doc(senderID)
                .update({'lastMessage': txtMessage});
            // OneSignal.shared.postNotification(OSCreateNotification(
            //   additionalData: {
            //     "sender_id": senderID,
            //     "name": senderName,
            //     "email": senderEmail,
            //     "image_url": senderImage,
            //     "date_time": formattedDate,
            //     "sender_token": senderToken,
            //   },
            //   heading: "$senderName sent you message",
            //   // subtitle: dialogNotifiactionTitelController.text,
            //   playerIds: [receiverToken],
            //   content: "$txtMessage",
            // ));
          });
        });
      } else {
        print('value not exist');
        FirebaseFirestore.instance
            .collection('users')
            .doc(senderID)
            .collection('usersForChat')
            .doc(receiverID)
            .set({
          'user_name': receiverName,
          'user_email': receiverEmail,
          'user_image': receiverImage,
          'dateTime': DateTime.now(),
          'token': receiverToken,
          'un_read_message': 0,
          'lastMessage': txtMessage
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(senderID)
              .collection('usersForChat')
              .doc(receiverID)
              .collection('chat')
              .add({
            'txtMessage': txtMessage,
            'time': DateTime.now(),
            'sender_id': senderID,
            'is_read': false,
            "date_time": formattedDate,
          }).then((value) {
            OneSignal.shared.postNotification(OSCreateNotification(
              additionalData: {
                "sender_id": senderID,
                "name": senderName,
                "email": senderEmail,
                "image_url": senderImage,
                "sender_token": senderToken,
                "txt_message": txtMessage,
                'is_comment': false,
                'receiver_id': receiverID
              },
              heading: "$senderName sent you message",
              // subtitle: dialogNotifiactionTitelController.text,
              playerIds: [receiverToken],
              content: txtMessage,
            ));
            // OneSignal.shared.postNotification(OSCreateNotification(
            //   additionalData: {
            //     "sender_id": senderID,
            //     "name": senderName,
            //     "email": senderEmail,
            //     "image_url": senderImage,
            //     "date_time": formattedDate,
            //     "sender_token": senderToken,
            //     "txt_message": txtMessage,
            //     'is_read': false,
            //   },
            //   heading: "$senderName sent you message",
            //   // subtitle: dialogNotifiactionTitelController.text,
            //   playerIds: [receiverToken],
            //   content: "$txtMessage",
            // ));
          });
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(receiverID)
            .collection('usersForChat')
            .doc(senderID)
            .set({
          'user_name': senderName,
          'user_email': senderEmail,
          'user_image': senderImage,
          'dateTime': DateTime.now(),
          'token': senderToken,
          'un_read_message': 0,
          'lastMessage': txtMessage,
        }).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverID)
              .collection('usersForChat')
              .doc(senderID)
              .collection('chat')
              .add({
            'txtMessage': txtMessage,
            'time': DateTime.now(),
            'sender_id': senderID,
            'is_read': false,
            "date_time": formattedDate,
          }).then((value) {
            // OneSignal.shared.postNotification(OSCreateNotification(
            //   additionalData: {
            //     "sender_id": senderID,
            //     "name": senderName,
            //     "email": senderEmail,
            //     "image_url": senderImage,
            //     "date_time": formattedDate,
            //     "sender_token": senderToken,
            //   },
            //   heading: "$senderName sent you message",
            //   // subtitle: dialogNotifiactionTitelController.text,
            //   playerIds: [receiverToken],
            //   content: "$txtMessage",
            // ));
          });
        });
      }
    });
  }
}
