import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostandfound/bindings/auth_bindings.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/initial_root/initial_root.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  // This widget is the root of your application.

  @override
  void initState() {
    authenticationController.configOneSignel();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        initialBinding: AuthBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Lost and found',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InitialRoot(),
      );
    });
  }
}
