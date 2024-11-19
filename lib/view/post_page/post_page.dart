import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:lostandfound/view/post_page/pick_location_page.dart';
import 'package:lostandfound/view/widgets/input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key, required this.isLost});

  bool isLost;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostController postController = Get.put(PostController());

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
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  Future pickImage(ImageSource imageSource) async {
    if(this.image != null)
    {
      setState(() {
        this.image = null;
      });
      return;
    }
    try {

      final image = await ImagePicker().pickImage(source: imageSource);
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
    authenticationController.getUser();
    postController.pickOrLostLocation.value = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme ktextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child:
      Scaffold(
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
            widget.isLost ? 'Post lost things' : 'Post found things',
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
                //         widget.isLost ? 'Post lost things' : 'Post found things',
                //         style: ktextTheme.titleLarge
                //             ?.copyWith(color: kbackgroundColor),
                //       ),
                //       SizedBox()
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: Adaptive.h(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(10)),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Post title',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),
                      EditTextFiled(
                          textEditingController: postController.titleCont),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Description',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),
                      EditTextFiled(
                          textEditingController: postController.desCont),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Location',
                            style: ktextTheme.titleLarge
                                ?.copyWith(color: kprimaryColor),
                          )),

                      SizedBox(
                        height: Adaptive.h(3),
                      ),

                      Obx(() => Column(
                        children: [
                          Text(postController.pickOrLostLocation.value),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          )
                        ],
                      )),

                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color> (kprimaryColor),shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          onPressed: () {
                            Get.to(() => MapPicker());
                          },
                          child: Text('pick location')),

                      // EditTextFiled(
                      //     textEditingController: postController.distanceCont),
                      SizedBox(
                        height: Adaptive.h(5),
                      ),
                      Container(
                        height: Adaptive.h(25),
                        width: Adaptive.w(70),
                        //color: Colors.red,
                        child: Stack(
                            children: [

                              image != null
                                  ? Image.file(
                                image!,
                              )
                                  : const SizedBox(),
                            ]
                        ),
                      ),
                      // SizedBox(
                      //   height: Adaptive.h(5),
                      // ),
                      SizedBox(
                        height: Adaptive.h(10),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                //  pickImage();
                                if(this.image != null)
                                {
                                  setState(() {
                                    this.image = null;
                                  });
                                  return;
                                }
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text('Gallary'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickImage(ImageSource.gallery);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.camera_alt),
                                            title: const Text('Camera'),
                                            onTap: () {

                                              Navigator.pop(context);
                                              pickImage(ImageSource.camera);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'Attach/detach Photo',
                                style: ktextTheme.subtitle1?.copyWith(
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.bold),
                              )),

                          TextButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Alert'),
                                  content: const Text('Are you sure you want to cancel?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        Navigator.pop(context, 'OK'),
                                        Get.back(),
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              // {
                              //
                              //   Get.back();
                              // },
                              child: Text(
                                'Cancel',
                                style: ktextTheme.subtitle1?.copyWith(
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.bold),
                              )),
                          Obx(
                                () => postController.isPosted.value
                                ? const Center(
                              child: CircularProgressIndicator(
                                color: kprimaryColor,
                              ),
                            )
                                : TextButton(
                                onPressed: () {
                                  if (postController
                                      .titleCont.text.isNotEmpty &&
                                      postController
                                          .desCont.text.isNotEmpty &&
                                      postController
                                          .pickOrLostLocation.isNotEmpty) {
                                    postController.uploadPost(
                                        image: image,
                                        userModel: authenticationController
                                            .getUserData,
                                        objectType:
                                        widget.isLost ? 'Lost' : 'Found');
                                    confetti_cont.play();
                                  } else {
                                    // Get.snackbar('Failed',
                                    //     'Please fill all the mandatory filleds',
                                    //     backgroundColor: kprimaryColor,
                                    //     colorText: kbackgroundColor);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please fill all the mandatory filleds'),
                                      behavior: SnackBarBehavior
                                          .floating, // Add this line
                                    ));
                                  }
                                },
                                child: Text(
                                  'Ok',
                                  style: ktextTheme.subtitle1?.copyWith(
                                      color: kprimaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          // Obx(
                          //   () => TextButton(
                          //       onPressed: () {
                          //         postController.uploadPost(
                          //             userModel:
                          //                 authenticationController.getUserData,
                          //             objectType:
                          //                 widget.isLost ? 'Lost' : 'Found');
                          //       },
                          //       child: Text(
                          //         'Ok',
                          //         style: ktextTheme.subtitle1?.copyWith(
                          //             color: kprimaryColor,
                          //             fontWeight: FontWeight.bold),
                          //       )),
                          // )
                        ],
                      ),
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
