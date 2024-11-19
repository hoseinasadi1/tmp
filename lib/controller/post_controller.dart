import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/model/comment_model.dart';
import 'package:lostandfound/model/post_model.dart';
import 'package:lostandfound/model/user_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../view/home_page/home_page.dart';
import 'package:confetti/confetti.dart';

final confetti_cont = ConfettiController(
    duration: const Duration(seconds: 3)); //celebration animation

class PostController extends GetxController {
  TextEditingController titleCont = TextEditingController();
  TextEditingController desCont = TextEditingController();
  TextEditingController distanceCont = TextEditingController();

  Rx<List<PostModel>> postlist = Rx<List<PostModel>>([]);
  List<PostModel> get getpostlist => postlist.value;

  Rx<List<PostModel>> userpostlist = Rx<List<PostModel>>([]);
  List<PostModel> get getUserpostlist => userpostlist.value;

  Rx<List<CommentModel>> commentList = Rx<List<CommentModel>>([]);
  List<CommentModel> get getCommentList => commentList.value;

  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  RxString pickOrLostLocation = ''.obs;

  double lat = 0.0;
  double lng = 0.0;

  Rx<List<Marker>> marker = Rx<List<Marker>>([]);
  List<Marker> get getMarker => marker.value;

  RxBool isLost = false.obs;
  RxBool isMostComment = false.obs;
  RxBool isFound = false.obs;
  RxString timeRange = '1 Day'.obs;

  @override
  void onInit() {
    super.onInit();
    postlist.bindStream(getPostStream());
  }

  getMylist(String userId) {
    userpostlist.bindStream(getUserPostStream(userId));
  }

  RxBool isPosted = false.obs;
  void uploadPost(
      {File? image,
      required UserModel userModel,
      required String objectType}) async {
    isPosted.value = true;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child(DateTime.now().toString());
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('posts').add({
        "post_title": titleCont.text,
        "post_photoUrl": url,
        "post_description": desCont.text,
        "post_location": pickOrLostLocation.value.trim() == ''
            ? '-did not specify'
            : pickOrLostLocation.value,
        "user_id": userModel.userId,
        "userName": userModel.userName,
        "photoUrl": userModel.imageUrl,
        "firstname": userModel.firstName,
        "lastname": userModel.lastName,
        "object_Type": objectType,
        "date_time": DateTime.now(),
        'oneSinalId': userModel.oneSinalId,
        'lat': lat.toString(),
        'lng': lng.toString(),
        'total_comments': 0
      }).then((value) {
        clearCOnt();
        Get.back();
        // Get.snackbar('Posted', 'Posted Successfully',
        //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Posted Successfully'),
          behavior: SnackBarBehavior.floating,
        ));
        isPosted.value = false;

        //Get.put(UserController()).getUser();
        //
      }).catchError((e) {
        // Get.snackbar('Error', e.toString(),backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ));
        isPosted.value = false;
      });
    } else {
      await FirebaseFirestore.instance.collection('posts').add({
        "post_title": titleCont.text,
        "post_description": desCont.text,
        "post_location": pickOrLostLocation.value.trim() == ''
            ? '-did not specify'
            : pickOrLostLocation.value,
        "post_photoUrl": '',
        "user_id": userModel.userId,
        "userName": userModel.userName,
        "photoUrl": userModel.imageUrl,
        "firstname": userModel.firstName,
        "lastname": userModel.lastName,
        "date_time": DateTime.now(),
        "object_Type": objectType,
        'oneSinalId': userModel.oneSinalId,
        'total_comments': 0,
        'lat': lat.toString(),
        'lng': lng.toString()
      }).then((value) {
        clearCOnt();
        Get.back();
        // Get.snackbar('Posted', 'Posted Successfully',
        //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Posted Successfully'),
          behavior: SnackBarBehavior.floating,
        ));
        isPosted.value = false;
        isPosted.value = false;
      }).catchError((e) {
        isPosted.value = false;
        //Get.snackbar('Error', e.toString(),backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ));
      });
    }
  }

  clearCOnt() {
    titleCont.clear();
    desCont.clear();
    distanceCont.clear();
  }

  Stream<List<PostModel>> getPostStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((event) {
      List<PostModel> retVal = [];
      for (var element in event.docs) {
        getMarker.add(
          Marker(
              icon: element['object_Type'] == 'Found'
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
              markerId: MarkerId(element.id),
              position: LatLng(
                  double.parse(element["lat"]), double.parse(element["lng"])),
              infoWindow: InfoWindow(
                  title: element["post_title"],
                  onTap: () => {
                        redirected_from_map = true,
                        redirected_from_map_date =
                            element["date_time"].toString(),
                        redirected_from_map_user = element["userName"],
                        redirected_from_map_title = element["post_title"],
                        // print("test redire"),
                        //   print(redirected_from_map_key),
                        Get.to(() => HomePage()),
                        //print("yessssssss")
                      })),
        );
        retVal.add(PostModel.fromSnamshot(element));
      }
      log('post Length is ${getpostlist.length}');
      return retVal;
    });
  }

  Future getFilterStream(bool cancel) async {
    if (cancel) {
      postlist.bindStream(getPostStream());
      return;
    }
    postlist.bindStream(getFilterPostStream());
  }

  Stream<List<PostModel>> getFilterPostStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy(isMostComment.value ? 'total_comments' : 'date_time',
            descending: true)
        .snapshots()
        .map((event) {
      List<PostModel> retVal = [];
      for (var element in event.docs) {
        DateTime postTime = (element['date_time'] as Timestamp).toDate();

        Duration? timeDuration;

        DateTime currentTime = DateTime.now();
        timeDuration = currentTime.difference(postTime);
        log('time diffrence is ${timeDuration.inDays}');
        log('time is ${timeRange.value.split(' ').first} ');
        if (isFound.value && isLost.value) {
          if (timeDuration.inDays <=
              int.parse(timeRange.value.split(' ').first)) {
            retVal.add(PostModel.fromSnamshot(element));
          }
        } else if (isFound.value) {
          if (timeDuration.inDays <=
                  int.parse(timeRange.value.split(' ').first) &&
              element['object_Type'] == 'Found') {
            retVal.add(PostModel.fromSnamshot(element));
          }
        } else if (isLost.value) {
          if (timeDuration.inDays <=
                  int.parse(timeRange.value.split(' ').first) &&
              element['object_Type'] == 'Lost') {
            retVal.add(PostModel.fromSnamshot(element));
          }
        }
      }
      log('post Length is ${getpostlist.length}');
      return retVal;
    });
  }

  Stream<List<PostModel>> getUserPostStream(String userId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where("user_id", isEqualTo: userId)
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((event) {
      List<PostModel> retVal = [];
      for (var element in event.docs) {
        retVal.add(PostModel.fromSnamshot(element));
      }
      log('post Length is ${getpostlist.length}');
      return retVal;
    });
  }

  Future commentOntPost(
    UserModel userModel,
    PostModel postModel,
    String commentText,
  ) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('comments')
        .add({
      "comment_text": commentText,
      "userName": userModel.userName,
      "photoUrl": userModel.imageUrl,
      'date_time': DateTime.now(),
      "user_id": userModel.userId
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postModel.postId)
          .update({"total_comments": getCommentList.length});
      OneSignal.shared.postNotification(OSCreateNotification(
        additionalData: {
          "sender_id": userModel.userId,
          "name": userModel.firstName,
          "email": userModel.userName,
          "image_url": userModel.imageUrl,
          "sender_token": userModel.oneSinalId,
          "txt_message": commentText,
          'is_comment': true,
          'receiver_id': postModel.userId
        },
        heading: "${userModel.userName} sent you message",
        // subtitle: dialogNotifiactionTitelController.text,
        playerIds: [postModel.oneSignalId!],
        content: commentText,
      ));
    });
  }

  getComments(String postId) {
    commentList.bindStream(getCommentStream(postId));
  }

  Stream<List<CommentModel>> getCommentStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((event) {
      List<CommentModel> retVal = [];
      List<CommentModel> pinned_list = [];
      for (var element in event.docs) {
        if (CommentModel.fromSnamshot(element).pinned!) {
          pinned_list.add(CommentModel.fromSnamshot(element));
        } else {
          retVal.add(CommentModel.fromSnamshot(element));
        }
      }
      retVal = retVal.reversed.toList();
      pinned_list = pinned_list.reversed.toList();
      log('Comments Length is ${getpostlist.length}');
      List<CommentModel> newList = pinned_list + retVal;
      return newList;
    });
  }

  bool redirected_from_map = false;
  String redirected_from_map_date = '';
  String redirected_from_map_user = '';
  String redirected_from_map_title = '';
  void set_redirected_from_map(bool a) {
    redirected_from_map = a;
  }

  bool get_redirected_from_map() {
    // print("test redire");
    //print(redirected_from_map);
    return redirected_from_map;
  }

  String get_redirected_from_map_date() {
    //print("test redire date");
    // print(redirected_from_map_date);
    //String string = dateFormat.format(DateTime.now());
    return redirected_from_map_date;
  }

  String get_redirected_from_map_user() {
    //print("test redire user");
    //print(redirected_from_map_user);
    return redirected_from_map_user;
  }

  String get_redirected_from_map_title() {
    return redirected_from_map_title;
  }
}
