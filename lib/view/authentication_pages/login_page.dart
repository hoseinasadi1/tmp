import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/view/authentication_pages/reset_passeword_page.dart';
import 'package:lostandfound/view/authentication_pages/sign_up_page.dart';
import 'package:lostandfound/view/widgets/input_field.dart';
import 'package:lostandfound/view/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kprimaryColor,
            title: Text(
              'Sign in',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: kbackgroundColor, fontSize: Adaptive.px(22)),
            ),
          ),
          backgroundColor: kbackgroundColor,
          body: SingleChildScrollView(
            child: SizedBox(
              height: Adaptive.h(100),
              width: Adaptive.w(100),
              child: Column(
                children: [
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Adaptive.w(10)),
                    child: Column(
                      children: [
                        // Email text filed
                        textfiledTile(
                            'Email address',
                            'example@email.com',
                            authenticationController.loginEmail,
                            FontAwesomeIcons.user),
                        Container(
                          height: Adaptive.h(0.2),
                          width: Adaptive.w(100),
                          color: Colors.grey.shade400,
                        ),

                        SizedBox(
                          height: Adaptive.h(5),
                        ),

                        // Password text filed
                        textfiledTile(
                            'Password',
                            '*******************',
                            authenticationController.loginPassword,
                            FontAwesomeIcons.lock),
                        Container(
                          height: Adaptive.h(0.2),
                          width: Adaptive.w(100),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          height: Adaptive.h(5),
                        ),
                        // Sign In Button

                        Obx(
                              () => authenticationController.isLogin.value
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: kprimaryColor,
                            ),
                          )
                              : PrimaryButtion(
                            buttonText: 'SIGN IN',
                            onPressed: () {
                              if (authenticationController
                                  .loginEmail.text.isEmpty ||
                                  authenticationController
                                      .loginPassword.text.isEmpty) {
                                // Get.snackbar('Failed',
                                //     'Please fill all the mandatory filleds',
                                //     backgroundColor: kprimaryColor,
                                //     colorText: kbackgroundColor);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Please fill all the mandatory filleds'),
                                  behavior: SnackBarBehavior.floating, // Add this line
                                ));
                              } else {
                                authenticationController.signIn();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),

                        /// Forgot password
                        TextButton(
                            onPressed: () {
                              Get.to(() => ResetPasswordPage());
                            },
                            child: Text(
                              'Forget Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: kprimaryColor,
                                  fontSize: Adaptive.px(15.5)),
                            )),

                        /// Sign up text
                        TextButton(
                            onPressed: () {
                              Get.to(() => SignUpPage());
                            },
                            child: Text(
                              'Not an existing user ? Click here to sign-up',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: kprimaryColor,
                                  fontSize: Adaptive.px(15.5)),
                            )),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),
                        Text(
                          'or',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black, fontSize: Adaptive.px(20)),
                        ),

                        SizedBox(
                          height: Adaptive.h(2),
                        ),
                        IconButton(
                          onPressed: () {
                            authenticationController.googleLogin();
                          },
                          icon: Image.asset('images/google_logo.png'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textfiledTile(String labelText, String hinttext,
      TextEditingController textEditingController, IconData iconData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          iconData,
          size: Adaptive.px(30),
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Adaptive.w(4)),
              child: Text(
                labelText,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: kprimaryColor, fontSize: Adaptive.px(16)),
              ),
            ),
            InPutFiled(
              hintText: hinttext,
              textEditingController: textEditingController,
              validator: (val) {
                if (val!.isEmpty) {
                  return '*required';
                } else {
                  return null;
                }
              },
            )
          ],
        )
      ],
    );
  }
}
