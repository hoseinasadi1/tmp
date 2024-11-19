import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/view/authentication_pages/sign_up_page.dart';
import 'package:lostandfound/view/widgets/input_field.dart';
import 'package:lostandfound/view/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<ResetPasswordPage> {
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
              'Reset Password',
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
                  Text(
                    'Enter your mail to reset the password',
                    style: Theme.of(context).textTheme.headline6?.copyWith(),
                  ),
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
                        PrimaryButtion(
                          buttonText: 'RESET',
                          onPressed: () async {
                            var email = authenticationController.loginEmail.text.trim();

                            FocusManager.instance.primaryFocus?.unfocus();
                            //print(email);
                            //var email = auth_cont.loginEmail.text;
                            //auth_cont.loginEmail.Clear();
                            if (email != "") {
                              try
                              {

                                //bool sent = await authenticationController. .resetPassword(email);
                                authenticationController.loginEmail.clear();
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                bool sent = true;
                                //print(sent);
                                authenticationController.loginEmail.clear();

                                AlertDialog alert = AlertDialog(
                                  title: const Text("Email sent"),
                                  content: const Text("check your inbox!"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                        },
                                        child: const Text("OK"))
                                  ],
                                );

                                if (sent) {
                                  showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return alert;
                                      });
                                } else {
                                  throw Exception;
                                }
                              }
                              catch(_){
                                //const snackBar =SnackBar(content: Text('There was a problem sending the email'));
                                //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                // Get.snackbar('Error',
                                //     'There was a problem sending the email',
                                //     backgroundColor: kprimaryColor,
                                //     colorText: kbackgroundColor ,
                                // /*snackPosition: SnackPosition.BOTTOM*/ );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('There was a problem sending the email'),
                                  behavior: SnackBarBehavior.floating, // Add this line
                                ));
                                authenticationController.loginEmail.clear();

                              }
                            }
                            else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('please enter your mail'),
                                behavior: SnackBarBehavior
                                    .floating, // Add this line
                              ));
                            }
                          },
                        ),
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
                validator: (val) {
                  if (val!.isEmpty) {
                    return '*required';
                  } else {
                    return null;
                  }
                },
                hintText: hinttext,
                textEditingController: textEditingController)
          ],
        )
      ],
    );
  }
}
