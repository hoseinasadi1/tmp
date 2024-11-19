import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/model/user_model.dart';
import 'package:lostandfound/view/widgets/input_field.dart';
import 'package:lostandfound/view/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key, required this.userModel});

  UserModel userModel;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<Image> convertFileToImage(File picture) async {
    List<int> imageBase64 = picture.readAsBytesSync();
    String imageAsString = base64Encode(imageBase64);
    Uint8List uint8list = base64.decode(imageAsString);
    Image image = Image.memory(uint8list);
    setState(() {
      myImage = image;
    });
    print('MY image is $myImage');
    return image;
  }

  File? image;
  Image? myImage;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageTemporary = File(image.path);
        setState(() {
          this.image = imageTemporary;
        });
        await convertFileToImage(File(image.path));
      }
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('failed to pick image: $e');
    }
  }

  @override
  void initState() {
    authenticationController.firstNameController.text =
        widget.userModel.firstName!;
    authenticationController.lastnameController.text =
        widget.userModel.lastName!;
    authenticationController.userNameController.text =
        widget.userModel.userName!;

    super.initState();
  }

  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    TextTheme ktextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Alert'),
                content: const Text('Are you sure you want to cancel?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel',style: TextStyle(color: kprimaryColor),),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                      Navigator.of(context).pop(),
                      //Get.back(),
                    },
                    child: const Text('OK',style: TextStyle(color: kprimaryColor),),
                  ),
                ],
              ),
            ),
            //Navigator.of(context).pop(),
          ),
          title: Text(
            'Edit Profile',
            style: ktextTheme.titleLarge?.copyWith(color: kbackgroundColor),
          ),
          backgroundColor: kprimaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   height: Adaptive.h(8),
                //   width: Adaptive.w(100),
                //   decoration: BoxDecoration(color: kprimaryColor),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       IconButton(
                //         onPressed: () {
                //           Get.back();
                //         },
                //         icon: Icon(
                //           Icons.arrow_back_ios_new,
                //           color: kbackgroundColor,
                //         ),
                //       ),
                //       Text(
                //         'Edit Profile',
                //         style: ktextTheme.titleLarge
                //             ?.copyWith(color: kbackgroundColor),
                //       ),
                //       SizedBox()
                //     ],
                //   ),
                // ),
                //undoooo
                SizedBox(
                  height: Adaptive.h(2),
                ),
                myImage != null
                    ? Container(
                  height: Adaptive.h(28),
                  width: Adaptive.w(50),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kprimaryColor,
                      image: DecorationImage(
                          image: myImage!.image, fit: BoxFit.cover)),
                )
                    : widget.userModel.imageUrl!.isNotEmpty
                    ? Container(
                  height: Adaptive.h(28),
                  width: Adaptive.w(50),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kprimaryColor,
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.userModel.imageUrl!,
                          ),
                          fit: BoxFit.cover)),
                )
                    : Container(
                  height: Adaptive.h(28),
                  width: Adaptive.w(50),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kprimaryColor,
                  ),
                ),

                // widget.userModel.imageUrl!.isEmpty
                //     ? const CircleAvatar(
                //         backgroundColor: kprimaryColor,
                //         radius: 90,
                //       )
                //     : CircleAvatar(
                //         radius: 90,
                //         backgroundImage: NetworkImage(widget.userModel.imageUrl!),
                //       ),
                TextButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Text(
                      'Edit profile picture',
                      style: ktextTheme.subtitle1?.copyWith(color: kprimaryColor),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'First Name',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),
                      EditTextFiled(
                          textEditingController:
                          authenticationController.firstNameController),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Last Name',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),
                      EditTextFiled(
                          textEditingController:
                          authenticationController.lastnameController),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'UserName',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),
                      EditTextFiled(
                          readOnly: true,
                          textEditingController:
                          authenticationController.userNameController),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Obx(
                            () => authenticationController.isprofileupdated.value
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: kprimaryColor,
                          ),
                        )
                            : PrimaryButtion(
                          buttonText: 'Update',
                          onPressed: () {
                            if (image != null) {
                              authenticationController
                                  .updateUserProfileData(image: image);
                            } else {
                              authenticationController
                                  .updateUserProfileData();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
