import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/model/user_model.dart';
import 'package:lostandfound/view/authentication_pages/login_page.dart';
import 'package:lostandfound/view/bottom_navbar/bottom_nav_bar_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthenticationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
  }

  // one signal configuration

  void configOneSignel() {
    print("onedignal congigured");
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("b871281b-d067-47cc-a6d7-607eb37880bc");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    //   print("Accepted permission: $accepted");
    // });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      log(' on foreground Notification');

      FirebaseFirestore.instance
          .collection('users')
          .doc(event.notification.additionalData!["receiver_id"])
          .collection('notification')
          .add({
        "sender_id": event.notification.additionalData!["sender_id"],
        "name": event.notification.additionalData!["name"],
        "email": event.notification.additionalData!["email"],
        "image_url": event.notification.additionalData!["image_url"],
        "sender_token": event.notification.additionalData!["sender_token"],
        "txt_message": event.notification.additionalData!["txt_message"],
        'content': event.notification.additionalData!["is_comment"]
            ? 'Commented on your post'
            : 'Sent you text message',
        'receiver_id': event.notification.additionalData!["sender_id"]
      });

      // eventCreatorId = result.notification.additionalData["eventCreatorId"];
      //chatID = result.notification.additionalData["broadCastChatID"];
      // Will be called whenever a notification is opened/button pressed.
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult event) {
      log('setNotificationOpenedHandler');

      FirebaseFirestore.instance
          .collection('users')
          .doc(event.notification.additionalData!["receiver_id"])
          .collection('notification')
          .add({
        "sender_id": event.notification.additionalData!["sender_id"],
        "name": event.notification.additionalData!["name"],
        "email": event.notification.additionalData!["email"],
        "image_url": event.notification.additionalData!["image_url"],
        "sender_token": event.notification.additionalData!["sender_token"],
        "txt_message": event.notification.additionalData!["txt_message"],
        'content': event.notification.additionalData!["is_comment"]
            ? 'Comment on your post'
            : 'Send you text message',
        'receiver_id': event.notification.additionalData!["sender_id"]
      });
    });
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
    //OneSignal.shared.
  }

  final auth = FirebaseAuth.instance;

  final firebaseUser = Rxn<User>();
  User get users => firebaseUser.value!;

  //sign in Controller
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  //sign up controller

  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  //Edit profile controller controller

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

//========================Sign in method

  RxBool isLogin = false.obs;
  Future<void> signIn() async {
    isLogin.value = true;
    auth
        .signInWithEmailAndPassword(
            email: loginEmail.text.trim(), password: loginPassword.text.trim())
        .then((value) {
      isLogin.value = false;
      clearSignInController();
      Get.offAll(() => const BottomNavBarPage());
    }).catchError((e) {
      isLogin.value = false;
      // Get.snackbar('Failed', e.toString(),
      //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  clearSignInController() {
    loginEmail.clear();
    loginPassword.clear();
  }

  //========================Sign up method

  RxBool isSignUp = false.obs;
  Future<void> signUP() async {
    isSignUp.value = true;
    auth
        .createUserWithEmailAndPassword(
            email: signUpEmail.text.trim(),
            password: signUpPassword.text.trim())
        .then((value) {
      storeUserData(value.user!.uid, signUpEmail.text.split('@').first)
          .then((value) {
        isSignUp.value = false;
        clearSignUpCont();
        Get.offAll(() => const BottomNavBarPage());
      }).catchError((e) {
        isSignUp.value = false;
        // Get.snackbar('Failed', e.toString(),
        //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ));
      });
    }).catchError((e) {
      isSignUp.value = false;
      // Get.snackbar('Failed', e.toString(),
      //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  clearSignUpCont() {
    signUpEmail.clear();
    signUpPassword.clear();
    confirmPassword.clear();
  }

  // store User Data
  Future storeUserData(String userid, String userName) async {
    var status = await OneSignal.shared.getDeviceState();
    String tokenID = status!.userId!;

    Map<String, dynamic> userData = {
      "userName": userName,
      "photoUrl": '',
      "firstname": 'anonymous',
      "lastname": 'anonymous',
      'oneSinalId': tokenID,
    };
    FirebaseFirestore.instance.collection('users').doc(userid).set(userData);
  }

  // get user information

  Rx<UserModel> userData = UserModel().obs;

  UserModel get getUserData => userData.value;
  set getUserData(UserModel value) => userData.value = value;

  Future getUser() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.currentUser?.uid)
          .get();
      userData.value = UserModel.fromSnamshot(doc);
      log('user data iss is ${getUserData.firstName}');
    } catch (e) {
      log('error is ${e.toString()}');
    }
  }

  /// update User profile
  RxBool isprofileupdated = false.obs;
  void updateUserProfileData({File? image}) async {
    isprofileupdated.value = true;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(auth.currentUser!.uid);
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        "userName": userNameController.text,
        "photoUrl": url,
        "firstname": firstNameController.text,
        "lastname": lastnameController.text
      }).then((value) {
        getUser();
        Get.back();
        // Get.snackbar('Updated', 'Profile updated successfully',
        //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(' Profile updated successfully'),
          behavior: SnackBarBehavior.floating,
        ));
        isprofileupdated.value = false;

        //Get.put(UserController()).getUser();
        //
      }).catchError((e) {
        //Get.snackbar('Error', e.toString(),backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ));
        isprofileupdated.value = false;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        "userName": userNameController.text,
        "firstname": firstNameController.text,
        "lastname": lastnameController.text
      }).then((value) {
        getUser();
        Get.back();
        // Get.snackbar('Updated', 'Profile updated successfully',
        //     backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
          behavior: SnackBarBehavior.floating,
        ));
        isprofileupdated.value = false;
      }).catchError((e) {
        isprofileupdated.value = false;
        //Get.snackbar('Error', e.toString(),backgroundColor: kprimaryColor, colorText: kbackgroundColor);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ));
      });
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  void googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      print("user credential ${credential.token}");

      final UserCredential authResult =
          await auth.signInWithCredential(credential);

      if (authResult.additionalUserInfo!.isNewUser) {
        var status = await OneSignal.shared.getDeviceState();
        String tokenID = status!.userId!;

        Map<String, dynamic> userData = {
          "userName": authResult.user!.email!.split('@').first,
          "photoUrl": authResult.user!.photoURL,
          "firstname": authResult.user!.displayName!.split(' ')[0],
          "lastname": authResult.user!.displayName!.split(' ')[1],
          'oneSinalId': tokenID,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .set(userData)
            .then((value) {
          isLogin.value = false;
          Get.offAll(() => const BottomNavBarPage());
        });

        // storeUserData(
        //         auth.currentUser!.uid, authResult.user!.email!.split('@').first)
        //     .then((value) {
        //   isLogin.value = false;
        //   Get.offAll(() => const BottomNavBarPage());
        // });
      } else {
        Get.offAll(() => const BottomNavBarPage());
      }
    } catch (e) {}
  }

  void signOut() {
    auth.signOut().then((value) {
      googleSignIn.signOut().then((value) {
        Get.offAll(() => LoginPage());
      });
    });
  }
}
