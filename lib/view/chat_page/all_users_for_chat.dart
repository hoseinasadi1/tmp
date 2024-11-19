import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/controller/chat_controller.dart';
import 'package:lostandfound/view/chat_page/chat_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllUsersPage extends StatefulWidget {
  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  AuthenticationController authController = Get.put(AuthenticationController());
  bool isSearch_c = false;

  TextEditingController search_c = TextEditingController();
  @override
  void initState() {
    super.initState();
    chatController.getallUser(authController.getUserData.userId!);
  }

  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).unfocus(),
      },
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                isSearch_c
                    ? Expanded(
                        //  width: Adaptive.w(55),
                        child: TextField(
                        controller: search_c,
                        onChanged: ((value) {
                          setState(() {});
                        }),
                      ))
                    : Text(
                        'Chats',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: kbackgroundColor),
                      ),
              ],
            ),
          ),
          backgroundColor: kprimaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearch_c = !isSearch_c;
                    search_c.clear();
                  });
                },
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: kbackgroundColor,
                  size: Adaptive.px(20),
                )),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GetX<ChatController>(
                    init: Get.put(ChatController()),
                    builder: (con) {
                      if (con.getalluserForChat.length == 0) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: Adaptive.h(40),
                              ),
                              Text(
                                'No Chat available yet ',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: con.getalluserForChat.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                con.getalluserForChat[index].userName!
                                            .toUpperCase()
                                            .contains(
                                                search_c.text.toUpperCase()) ||
                                        con.getalluserForChat[index]
                                            .unreadMessage!
                                            .toUpperCase()
                                            .contains(
                                                search_c.text.toUpperCase())
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(() => Chat(
                                                receiverToken: con
                                                    .getalluserForChat[index]
                                                    .token!,
                                                isDirectChat: false,
                                                receiverEmail: con
                                                    .getalluserForChat[index]
                                                    .userEmail,
                                                receiverName: con
                                                    .getalluserForChat[index]
                                                    .userName,
                                                receiverImage: con
                                                    .getalluserForChat[index]
                                                    .userPhotoUrl,
                                                receiverID: con
                                                    .getalluserForChat[index]
                                                    .id,
                                                senderEmail: authController
                                                    .getUserData.userName,
                                                senderID: authController
                                                    .getUserData.userId,
                                                senderImage: authController
                                                    .getUserData.imageUrl,
                                                senderName: authController
                                                        .getUserData
                                                        .firstName! +
                                                    authController
                                                        .getUserData.lastName!,
                                              ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(con
                                                            .getalluserForChat[
                                                                index]
                                                            .userPhotoUrl!),
                                                    radius: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          con
                                                              .getalluserForChat[
                                                                  index]
                                                              .userName!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .black)),
                                                      Text(
                                                          con
                                                              .getalluserForChat[
                                                                  index]
                                                              .lastMessage!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .black))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              con.getalluserForChat[index]
                                                          .unreadMessage ==
                                                      '0'
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        width: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red),
                                                        child: Text(
                                                            con
                                                                .getalluserForChat[
                                                                    index]
                                                                .unreadMessage!,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            );
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllUserModel {
  String? name;
  String? email;
  String? imgPath;
  AllUserModel({this.email, this.imgPath, this.name});
}

List<AllUserModel> allUserModelList = [
  AllUserModel(
      name: 'Julia', imgPath: 'assets/girl.png', email: 'julia@gmail.com'),
  AllUserModel(
      name: 'Anny', imgPath: 'assets/girl.png', email: 'anny@gmail.com'),
  AllUserModel(
      name: 'Sara', imgPath: 'assets/girl.png', email: 'sara@gmail.com'),
  AllUserModel(
      name: 'jolly', imgPath: 'assets/girl.png', email: 'jolly@gmail.com'),
];
