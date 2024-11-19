import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/view/widgets/input_field.dart';
import 'package:lostandfound/view/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('form is invalid');
    }
  }

  @override
  void initState() {
    authenticationController.isSignUp.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kprimaryColor,
            title: Text(
              'Sign Up',
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
                            authenticationController.signUpEmail,
                            FontAwesomeIcons.user),
                        Container(
                          height: Adaptive.h(0.2),
                          width: Adaptive.w(100),
                          color: Colors.grey.shade400,
                        ),

                        SizedBox(
                          height: Adaptive.h(3),
                        ),

                        // Password text filed
                        textfiledTile(
                            'Password',
                            '*******************',
                            authenticationController.signUpPassword,
                            FontAwesomeIcons.lock),
                        Container(
                          height: Adaptive.h(0.2),
                          width: Adaptive.w(100),
                          color: Colors.grey.shade400,
                        ),

                        SizedBox(
                          height: Adaptive.h(3),
                        ),

                        // Confirm Password text filed
                        textfiledTile(
                            'Confirm password',
                            '*******************',
                            authenticationController.confirmPassword,
                            FontAwesomeIcons.lock),
                        Container(
                          height: Adaptive.h(0.2),
                          width: Adaptive.w(100),
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          height: Adaptive.h(3),
                        ),

                        // Sign In Button

                        Obx(
                              () => authenticationController.isSignUp.value
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: kprimaryColor,
                            ),
                          )
                              : PrimaryButtion(
                            buttonText: 'SIGN Up',
                            onPressed: () {
                              if (authenticationController
                                  .signUpEmail.text.isEmpty ||
                                  authenticationController
                                      .signUpPassword.text.isEmpty ||
                                  authenticationController
                                      .confirmPassword.text.isEmpty) {
                                // Get.snackbar('Failed',
                                //     'Please fill all the mandatory filleds',
                                //     backgroundColor: kprimaryColor,
                                //     colorText: kbackgroundColor);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  //duration: Duration(milliseconds : 1000),
                                  content: Text(
                                      'Please fill all the mandatory filleds'),
                                  behavior: SnackBarBehavior
                                      .floating, // Add this line
                                ));
                              } else if (authenticationController
                                  .confirmPassword.text !=
                                  authenticationController
                                      .signUpPassword.text) {
                                // Get.snackbar('Failed', 'Password not match',
                                //     backgroundColor: kprimaryColor,
                                //     colorText: kbackgroundColor);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Password not match'),
                                  behavior: SnackBarBehavior
                                      .floating, // Add this line
                                ));
                              } else {
                                authenticationController.signUP();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: Adaptive.h(1),
                        ),

                        // Text(
                        //   'or',
                        //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //       color: Colors.black, fontSize: Adaptive.px(20)),
                        // ),
                        //
                        // SizedBox(
                        //   height: Adaptive.h(5),
                        // ),

                        /// gmail Icon
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       FontAwesomeIcons.google,
                        //       color: kprimaryColor,
                        //     ))
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
