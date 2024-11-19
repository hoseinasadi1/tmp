import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/model/notification_model.dart';
import 'package:lostandfound/view/notification/notification_page.dart';

class NotificationController extends GetxController {
  Rx<List<NotificationModel>> notification = Rx<List<NotificationModel>>([]);

  List<NotificationModel> get getNotification => notification.value;

  AuthenticationController authController = Get.put(AuthenticationController());
  @override
  void onInit() {
    super.onInit();
    notification
        .bindStream(getNotificationtStream(authController.getUserData.userId!));
  }

  // getUserNotification(String userID) {
  //   notification.bindStream(getNotificationtStream(userID));
  // }

  Stream<List<NotificationModel>> getNotificationtStream(String userId) {
    print('user notification');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notification')
        .snapshots()
        .map((event) {
      List<NotificationModel> retVal = [];
      for (var element in event.docs) {
        retVal.add(NotificationModel.fromSnapSHot(element));
      }
      print('notification list is    ${retVal.length}');
      return retVal;
      //return event;
    });
  }

  Stream<List<NotificationModel>> getUnReadNotificationtStream(String userId) {
    print('user notification');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('is_read', isEqualTo: false)
        .snapshots()
        .map((event) {
      List<NotificationModel> retVal = [];
      for (var element in event.docs) {
        retVal.add(NotificationModel.fromSnapSHot(element));
      }
      print('unread notification list is    ${retVal.length}');
      return retVal;
      //return event;
    });
  }

  makeNotificaitonAsRead(String userId, String notificationID) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationID)
        .update({'is_read': true}).then((value) {
      print('notification seen');
    });
  }
}
