import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/view/authentication_pages/login_page.dart';
import 'package:lostandfound/view/bottom_navbar/bottom_nav_bar_page.dart';

class InitialRoot extends StatelessWidget {
  const InitialRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthenticationController>(
      initState: (_) {
        Get.put<AuthenticationController>(AuthenticationController());
      },
      builder: (_) {
        if (Get.find<AuthenticationController>().firebaseUser.value != null) {
          return const BottomNavBarPage();
        } else {
          return const LoginPage(); //LoginWidget();
        }
      },
    );
  }
}
