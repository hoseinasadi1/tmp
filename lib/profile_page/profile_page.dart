import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:lostandfound/model/post_model.dart';
import 'package:lostandfound/model/user_model.dart';
import 'package:lostandfound/profile_page/edit_profile.dart';
import 'package:lostandfound/view/home_page/show_map.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthenticationController authenticationController =
  Get.find<AuthenticationController>();
  PostController postController = Get.put(PostController());

  TextEditingController commentText = TextEditingController();

  //(AuthenticationController());
  @override
  void initState() {
    postController.postlist.bindStream(postController.getPostStream());
    authenticationController.getUser();
    postController.getMylist(authenticationController.getUserData.userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme ktextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        body: SafeArea(
          child: GetX<AuthenticationController>(
              init: authenticationController,
              builder: (auth) {
                return auth.getUserData.firstName != null
                    ? SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      // profile header
                      headerTile(context, auth.getUserData.firstName!,
                          auth.getUserData),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            auth.getUserData.imageUrl!.isNotEmpty
                                ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  auth.getUserData.imageUrl!),
                              backgroundColor: kprimaryColor,
                            )
                                : CircleAvatar(
                              radius: 50,
                              backgroundColor: kprimaryColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            //Column(
                            // children: [
                            // Text(
                            //   auth.getUserData.userName!,
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Text(
                              auth.getUserData.firstName! +
                                  " " +
                                  auth.getUserData.lastName!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                            //],
                            // ),
                            // Column(
                            //   children: [
                            //     Obx(
                            //       () => Text(
                            //         postController.getUserpostlist.length
                            //             .toString(),
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .headline6,
                            //       ),
                            //     ),
                            //     Text(
                            //       'post',
                            //       style:
                            //           Theme.of(context).textTheme.headline6,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox()
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: Adaptive.h(6),
                        width: Adaptive.h(100),
                        color: kprimaryColor,
                        child: Text(
                          postController.getUserpostlist.length
                              .toString() +
                              " " +
                              'Posts',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),

                          // style: ktextTheme.headline6
                          //     ?.copyWith(color: kbackgroundColor),
                        ),
                      ),

                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot>
                              streamSnapshott) {
                            if (streamSnapshott.hasData) {
                              return Column(
                                children: [
                                  GetX<PostController>(
                                      init: Get.put(PostController()),
                                      builder: (cont) {
                                        if (cont.getpostlist.length ==
                                            0) {
                                          return Center(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: Adaptive.h(40),
                                                ),
                                                Text(
                                                  'No post to show ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            itemCount: cont
                                                .getUserpostlist.length,
                                            itemBuilder:
                                            ((context, index) {
                                              return Container(
                                                margin:
                                                const EdgeInsets.all(
                                                    10),
                                                padding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                    Adaptive.w(5),
                                                    vertical:
                                                    Adaptive.h(
                                                        2)),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //       blurRadius: 2,
                                                    //       color: Colors.black12)
                                                    // ],
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20)),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        cont
                                                            .getUserpostlist[
                                                        index]
                                                            .imageUrl!
                                                            .isNotEmpty
                                                            ? CircleAvatar(
                                                          backgroundImage: NetworkImage(cont
                                                              .getUserpostlist[
                                                          index]
                                                              .imageUrl!),
                                                        )
                                                            : const CircleAvatar(
                                                          backgroundColor:
                                                          kprimaryColor,
                                                          child: Icon(
                                                              Icons
                                                                  .person),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                          Adaptive.w(
                                                              1.5),
                                                        ),
                                                        Text(
                                                          "${cont.getUserpostlist[index].objectType!} by",
                                                          style: ktextTheme
                                                              .bodyLarge
                                                              ?.copyWith(
                                                              color:
                                                              kprimaryColor),
                                                        ),
                                                        Text(
                                                          ' ${cont.getUserpostlist[index].userName!}',
                                                          style: ktextTheme
                                                              .bodyLarge
                                                              ?.copyWith(),
                                                        ),
                                                        Spacer(),
                                                        authenticationController
                                                            .getUserData
                                                            .userId ==
                                                            cont
                                                                .getUserpostlist[
                                                            index]
                                                                .userId
                                                            ? PopupMenuButton(onSelected:
                                                            (value) {
                                                          if (value ==
                                                              'Edit') {
                                                            updatePost(
                                                                cont.getUserpostlist[index].doc_ref,
                                                                cont.getUserpostlist[index].postTitle);
                                                          } else {
                                                            showDialog<
                                                                String>(
                                                              context:
                                                              context,
                                                              builder: (BuildContext context) =>
                                                                  AlertDialog(
                                                                    title:
                                                                    const Text('Alert'),
                                                                    content:
                                                                    const Text('Are you sure you want to cancel?'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text(
                                                                          'Cancel',
                                                                          style: TextStyle(color: kprimaryColor),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => {
                                                                          Navigator.pop(context, 'OK'),
                                                                          //Navigator.of(context).pop(),
                                                                          deletePost(cont.getUserpostlist[index].doc_ref),
                                                                          //Get.back(),
                                                                        },
                                                                        child: const Text(
                                                                          'OK',
                                                                          style: TextStyle(color: kprimaryColor),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            );
                                                          }
                                                        }, itemBuilder:
                                                            (BuildContext
                                                        bc) {
                                                          return [
                                                            PopupMenuItem(
                                                              child:
                                                              Text('Edit Post'),
                                                              value:
                                                              'Edit',
                                                            ),
                                                            PopupMenuItem(
                                                              child:
                                                              Text('Delete Post'),
                                                              value:
                                                              'Delete',
                                                            )
                                                          ];
                                                        })
                                                        // IconButton(
                                                        //     icon: const Icon(Icons.edit),
                                                        //     onPressed: () =>
                                                        //          updatePost(cont.getUserpostlist[index].doc_ref,cont.getUserpostlist[index].postTitle)) : SizedBox()
                                                        // ,
                                                        // authenticationController
                                                        //     .getUserData.userId ==
                                                        //     cont.getUserpostlist[index].userId ?
                                                        // IconButton(
                                                        //
                                                        //     icon: const Icon(Icons.delete),
                                                        //     onPressed: () =>
                                                        //         deletePost(cont.getUserpostlist[index].doc_ref))
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: Adaptive
                                                              .w(12)),
                                                      child: Row(
                                                        children: [
                                                          cont
                                                              .getUserpostlist[
                                                          index]
                                                              .postUrl!
                                                              .isNotEmpty
                                                              ? Container(
                                                            height:
                                                            Adaptive.h(10),
                                                            width: Adaptive.w(
                                                                15),
                                                            child: Image
                                                                .network(
                                                              cont.getUserpostlist[index]
                                                                  .postUrl!,
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                            color:
                                                            kprimaryColor,
                                                          )
                                                              : Container(
                                                            height:
                                                            Adaptive.h(10),
                                                            width: Adaptive.w(
                                                                15),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                            Adaptive
                                                                .w(3),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              SizedBox(
                                                                width: Adaptive
                                                                    .w(50),
                                                                child:
                                                                Text(
                                                                  cont.getUserpostlist[index]
                                                                      .postTitle!,
                                                                  maxLines:
                                                                  2,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  style: ktextTheme
                                                                      .headline5,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                Adaptive.h(
                                                                    2),
                                                              ),
                                                              SizedBox(
                                                                width: Adaptive
                                                                    .w(50),
                                                                child:
                                                                Text(
                                                                  cont.getUserpostlist[index]
                                                                      .postDescription!,
                                                                  maxLines:
                                                                  4,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  style: ktextTheme
                                                                      .bodyLarge,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: Adaptive
                                                                    .w(50),
                                                                child:
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    Get.to(() =>
                                                                        ShowMap(postModel: cont.getpostlist[index]));
                                                                  },
                                                                  child:
                                                                  Text(
                                                                    '${cont.getUserpostlist[index].objectType!} at ${cont.getUserpostlist[index].postLocation!}',
                                                                    style:
                                                                    ktextTheme.bodyLarge,
                                                                    maxLines:
                                                                    3,
                                                                    overflow:
                                                                    TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      Adaptive.h(2),
                                                    ),
                                                    const Divider(
                                                      thickness: 2,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              dialoger(
                                                                  context,
                                                                  cont
                                                                      .getUserpostlist[
                                                                  index]
                                                                      .postId!,
                                                                  cont.getUserpostlist[
                                                                  index]);
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .comment,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                SizedBox(
                                                                  width: Adaptive
                                                                      .w(2),
                                                                ),
                                                                Text(
                                                                  'Comment',
                                                                  style: ktextTheme
                                                                      .headline6,
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }));
                                      })
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          })
                    ],
                  ),
                )
                    : const Center(
                  child: CircularProgressIndicator(
                    color: kprimaryColor,
                  ),
                );
              }),
        ),
      ),
    );
  }

  AppBar headerTile(
      BuildContext context, String userName, UserModel userModel) {
    return AppBar(
      title: Text("Profile"),
      backgroundColor: kprimaryColor,
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          color: kbackgroundColor,
          onPressed: () {
            Get.to(EditProfilePage(
              userModel: userModel,
            ));
          },
        ),
        IconButton(
          icon: Icon(Icons.logout),
          color: kbackgroundColor,
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Alert'),
                content: const Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: kprimaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                      authenticationController.signOut(),
                      //Navigator.of(context).pop(),
                      //Get.back(),
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: kprimaryColor),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],

      // height: Adaptive.h(8),
      // width: Adaptive.w(100),
      // decoration: const BoxDecoration(color: kprimaryColor),
      // child: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const SizedBox(),
      //       Text(
      //         "$userName's Profile",
      //         style: Theme
      //             .of(context)
      //             .textTheme
      //             .headline5
      //             ?.copyWith(color: kbackgroundColor),
      //       ),
      //       Row(
      //         children: [
      //           GestureDetector(
      //             onTap: () {
      //               Get.to(EditProfilePage(
      //                 userModel: userModel,
      //               ));
      //             },
      //             child: Icon(
      //               Icons.edit,
      //               color: kbackgroundColor,
      //               size: Adaptive.px(18),
      //             ),
      //           ),
      //           SizedBox(
      //             width: Adaptive.w(3),
      //           ),
      //           GestureDetector(
      //             onTap: () {
      //               authenticationController.signOut();
      //             },
      //             child: Icon(
      //               Icons.logout,
      //               color: kbackgroundColor,
      //               size: Adaptive.px(18),
      //             ),
      //           )
      //         ],
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  dynamic dialoger(BuildContext context, String postId, PostModel postModel) {
    postController.getComments(postId);
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            title: Text("Comments"),
            content: SizedBox(
              width: double.maxFinite,
              height: 351,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 351,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return Column(
                            children: [
                              Expanded(
                                // height:
                                //     Adaptive.h(40),
                                child: GetX<PostController>(
                                    init: Get.put(PostController()),
                                    builder: (con) {
                                      if (con.getCommentList.length == 0) {
                                        return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'No comment to show',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ],
                                        );
                                      }

                                      return ListView.builder(
                                          itemCount: con.getCommentList.length,
                                          itemBuilder: ((context, index) {
                                            final DocumentSnapshot
                                            documentSnapshot =
                                            streamSnapshot
                                                .data!.docs[index];
                                            return Container(
                                              //margin: const EdgeInsets.all(11),

                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(con
                                                        .getCommentList[
                                                    index]
                                                        .imageUrl!),
                                                  ),
                                                  SizedBox(
                                                    width: Adaptive.w(2),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: authenticationController
                                                            .getUserData
                                                            .userId ==
                                                            con
                                                                .getCommentList[
                                                            index]
                                                                .userId
                                                            ? Adaptive.w(35)
                                                            : Adaptive.w(55),
                                                        child: Text(
                                                          con
                                                              .getCommentList[
                                                          index]
                                                              .userName!,
                                                          maxLines: 8,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              color:
                                                              kprimaryColor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Adaptive.w(2),
                                                      ),
                                                      SizedBox(
                                                        width: authenticationController
                                                            .getUserData
                                                            .userId ==
                                                            con
                                                                .getCommentList[
                                                            index]
                                                                .userId
                                                            ? Adaptive.w(35)
                                                            : Adaptive.w(55),
                                                        child: Text(
                                                          con
                                                              .getCommentList[
                                                          index]
                                                              .commentText!,
                                                          maxLines: 8,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //Spacer(),
                                                  Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width: Adaptive.w(0.1),
                                                      ),
                                                      IconButton(
                                                        //constraints: BoxConstraints.tight(Size.fromWidth(1)),
                                                          padding:
                                                          EdgeInsets.all(0),
                                                          icon: con
                                                              .getCommentList[
                                                          index]
                                                              .pinned!
                                                              ? Icon(Icons.push_pin,
                                                              size: 17)
                                                              : const Icon(
                                                              Icons
                                                                  .push_pin_outlined,
                                                              size: 17),
                                                          onPressed:
                                                              () async => {
                                                            setState(
                                                                    () async {
                                                                  bool not_pinned = con
                                                                      .getCommentList[index]
                                                                      .pinned!
                                                                      ? false
                                                                      : true;
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                      'posts')
                                                                      .doc(postModel
                                                                      .postId)
                                                                      .collection(
                                                                      'comments')
                                                                      .doc(con
                                                                      .getCommentList[
                                                                  index]
                                                                      .doc_ref!
                                                                      .id)
                                                                      .update({
                                                                    authenticationController
                                                                        .getUserData
                                                                        .userId!: not_pinned
                                                                  });
                                                                })
                                                            //print(con.getCommentList[index].doc_ref)
                                                            //updateComment(postModel,con.getCommentList[index].doc_ref,con.getCommentList[index].commentText)
                                                          }),
                                                      authenticationController
                                                          .getUserData
                                                          .userId ==
                                                          con
                                                              .getCommentList[
                                                          index]
                                                              .userId
                                                          ?

                                                      //   ? IconButton(
                                                      // //constraints: BoxConstraints.tight(Size.fromWidth(1)),
                                                      //   padding: EdgeInsets.all(0),
                                                      //   icon: const Icon(Icons.edit,
                                                      //       size: 17),
                                                      //   onPressed: () async =>
                                                      //   {
                                                      //     //print(con.getCommentList[index].doc_ref)
                                                      //     updateComment(
                                                      //         postModel,
                                                      //         con
                                                      //             .getCommentList[
                                                      //         index]
                                                      //             .doc_ref,
                                                      //         con
                                                      //             .getCommentList[
                                                      //         index]
                                                      //             .commentText)
                                                      //   })
                                                      PopupMenuButton(
                                                          onSelected:
                                                              (value) {
                                                            if (value ==
                                                                'Edit') {
                                                              updateComment(
                                                                  postModel,
                                                                  con
                                                                      .getCommentList[
                                                                  index]
                                                                      .doc_ref,
                                                                  con
                                                                      .getCommentList[
                                                                  index]
                                                                      .commentText);
                                                            } else if (value ==
                                                                'Delete') {
                                                              showDialog<
                                                                  String>(
                                                                context:
                                                                context,
                                                                builder: (BuildContext
                                                                context) =>
                                                                    AlertDialog(
                                                                      title: const Text(
                                                                          'Alert'),
                                                                      content:
                                                                      const Text(
                                                                          'Are you sure you want to delete?'),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Cancel'),
                                                                          child:
                                                                          const Text(
                                                                            'Cancel',
                                                                            style:
                                                                            TextStyle(color: kprimaryColor),
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () =>
                                                                          {
                                                                            Navigator.pop(
                                                                                context,
                                                                                'OK'),
                                                                            //Navigator.of(context).pop(),
                                                                            deleteComment(
                                                                                documentSnapshot.id,
                                                                                postModel,
                                                                                con.getCommentList[index].doc_ref),
                                                                            //Get.back(),
                                                                          },
                                                                          child:
                                                                          const Text(
                                                                            'OK',
                                                                            style:
                                                                            TextStyle(color: kprimaryColor),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              );
                                                            }
                                                            //// pin comment
                                                            else {}
                                                          }, itemBuilder:
                                                          (BuildContext
                                                      bc) {
                                                        return [
                                                          PopupMenuItem(
                                                            child: Text(
                                                                'Edit Comment'),
                                                            value: 'Edit',
                                                          ),
                                                          PopupMenuItem(
                                                            child: Text(
                                                                'Delete Comment'),
                                                            value:
                                                            'Delete',
                                                          )
                                                        ];
                                                      })
                                                          : SizedBox(),
                                                      // authenticationController
                                                      //     .getUserData.userId ==
                                                      //     con.getCommentList[index]
                                                      //         .userId
                                                      //     ? IconButton(
                                                      //   //constraints: BoxConstraints.tight(Size.fromWidth(1)),
                                                      //     padding: EdgeInsets.all(0),
                                                      //     icon: const Icon(
                                                      //         Icons.delete,
                                                      //         size: 17),
                                                      //     onPressed: () =>
                                                      //        )
                                                      //     : SizedBox(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }));
                                    }),
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: kprimaryColor))),
                                controller: commentText,
                                style: const TextStyle(height: 0.2),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (commentText.text.trim() != "") {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text('Alert'),
                                                content: const Text(
                                                    'Are you sure you want to cancel?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(
                                                        context, 'Cancel'),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: kprimaryColor),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => {
                                                      Navigator.pop(context, 'OK'),
                                                      // Navigator.of(context).pop(),
                                                      Get.back(),
                                                      //Get.back(),
                                                    },
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                          color: kprimaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      } else {
                                        Get.back();
                                      }
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: kprimaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (commentText.text.trim() != "") {
                                        postController
                                            .commentOntPost(
                                          authenticationController.getUserData,
                                          postModel,
                                          commentText.text,
                                        )
                                            .then((value) {
                                          commentText.clear();
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Comment',
                                      style: TextStyle(color: kprimaryColor),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//   void dialog(String postId, PostModel postModel) {
//     postController.getComments(postId);
//     Get.dialog(Scaffold(
//         backgroundColor: Colors.transparent,
//         body: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () => Navigator.pop(context),
//             child: Center(
//                 child: Container(
//               height: Adaptive.h(50),
//               width: Adaptive.w(100),
//               color: Colors.white,
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('posts')
//                     .doc(postId)
//                     .collection('comments')
//                     .snapshots(),
//                 builder:
//                     (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//                   if (streamSnapshot.hasData) {
//                     return Column(
//                       children: [
//                         Expanded(
//                           // height:
//                           //     Adaptive.h(40),
//                           child: GetX<PostController>(
//                               init: Get.put(PostController()),
//                               builder: (con) {
//                                 if (con.getCommentList.length == 0) {
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'No comment to show',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .subtitle1,
//                                       ),
//                                     ],
//                                   );
//                                 }

//                                 return ListView.builder(
//                                     itemCount: con.getCommentList.length,
//                                     itemBuilder: ((context, index) {
//                                       final DocumentSnapshot documentSnapshot =
//                                           streamSnapshot.data!.docs[index];
//                                       return Container(
//                                         //margin: const EdgeInsets.all(11),

//                                         child: Row(
//                                           children: [
//                                             CircleAvatar(
//                                               backgroundImage: NetworkImage(con
//                                                   .getCommentList[index]
//                                                   .imageUrl!),
//                                             ),
//                                             SizedBox(
//                                               width: Adaptive.w(3),
//                                             ),
//                                             Column(
//                                               children: [
//                                                 SizedBox(
//                                                   width: Adaptive.w(40),
//                                                   child: Text(
//                                                     con.getCommentList[index]
//                                                         .userName!,
//                                                     maxLines: 8,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                         color: kprimaryColor,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: Adaptive.w(2),
//                                                 ),
//                                                 SizedBox(
//                                                   width: Adaptive.w(60),
//                                                   child: Text(
//                                                     con.getCommentList[index]
//                                                         .commentText!,
//                                                     maxLines: 8,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             authenticationController
//                                                         .getUserData.userId ==
//                                                     con.getCommentList[index]
//                                                         .userId
//                                                 ? IconButton(
//                                                     icon:
//                                                         const Icon(Icons.edit),
//                                                     onPressed: () async => {
//                                                           //print(con.getCommentList[index].doc_ref)
//                                                           updateComment(
//                                                               postModel,
//                                                               con
//                                                                   .getCommentList[
//                                                                       index]
//                                                                   .doc_ref,
//                                                               con
//                                                                   .getCommentList[
//                                                                       index]
//                                                                   .commentText)
//                                                         })
//                                                 : SizedBox(),
//                                             authenticationController
//                                                         .getUserData.userId ==
//                                                     con.getCommentList[index]
//                                                         .userId
//                                                 ? IconButton(
//                                                     icon: const Icon(
//                                                         Icons.delete),
//                                                     onPressed: () => {
//                                                           showDialog<String>(
//                                                             context: context,
//                                                             builder: (BuildContext
//                                                                     context) =>
//                                                                 AlertDialog(
//                                                               title: const Text(
//                                                                   'Alert'),
//                                                               content: const Text(
//                                                                   'Are you sure you want to delete?'),
//                                                               actions: <Widget>[
//                                                                 TextButton(
//                                                                   onPressed: () =>
//                                                                       Navigator.pop(
//                                                                           context,
//                                                                           'Cancel'),
//                                                                   child:
//                                                                       const Text(
//                                                                     'Cancel',
//                                                                     style: TextStyle(
//                                                                         color:
//                                                                             kprimaryColor),
//                                                                   ),
//                                                                 ),
//                                                                 TextButton(
//                                                                   onPressed:
//                                                                       () => {
//                                                                     Navigator.pop(
//                                                                         context,
//                                                                         'OK'),
//                                                                     //Navigator.of(context).pop(),
//                                                                     deleteComment(
//                                                                         documentSnapshot
//                                                                             .id,
//                                                                         postModel,
//                                                                         con.getCommentList[index]
//                                                                             .doc_ref),
//                                                                     //Get.back(),
//                                                                   },
//                                                                   child:
//                                                                       const Text(
//                                                                     'OK',
//                                                                     style: TextStyle(
//                                                                         color:
//                                                                             kprimaryColor),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         })
//                                                 : SizedBox(),
//                                           ],
//                                         ),
//                                       );
//                                     }));
//                               }),
//                         ),
//                         TextField(
//                           decoration: const InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: kprimaryColor))),
//                           controller: commentText,
//                           style: const TextStyle(height: 0.2),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 if (commentText.text.trim() != "") {
//                                   showDialog<String>(
//                                     context: context,
//                                     builder: (BuildContext context) =>
//                                         AlertDialog(
//                                       title: const Text('Alert'),
//                                       content: const Text(
//                                           'Are you sure you want to cancel?'),
//                                       actions: <Widget>[
//                                         TextButton(
//                                           onPressed: () =>
//                                               Navigator.pop(context, 'Cancel'),
//                                           child: const Text(
//                                             'Cancel',
//                                             style:
//                                                 TextStyle(color: kprimaryColor),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () => {
//                                             Navigator.pop(context, 'OK'),
//                                             // Navigator.of(context).pop(),
//                                             Get.back(),
//                                             //Get.back(),
//                                           },
//                                           child: const Text(
//                                             'OK',
//                                             style:
//                                                 TextStyle(color: kprimaryColor),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 } else {
//                                   Get.back();
//                                 }
//                               },
//                               child: const Text(
//                                 'Cancel',
//                                 style: TextStyle(color: kprimaryColor),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 if (commentText.text.trim() != "") {
//                                   postController
//                                       .commentOntPost(
//                                     authenticationController.getUserData,
//                                     postModel,
//                                     commentText.text,
//                                   )
//                                       .then((value) {
//                                     commentText.clear();
//                                   });
//                                 }
//                               },
//                               child: const Text(
//                                 'Comment',
//                                 style: TextStyle(color: kprimaryColor),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     );
//                   }

//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             )))
// ////////////////////////////////////////////////////////////////////////////////
//         ////////////////////////////////////////////////////////////////////////////////
//         ////////////////////////////////////////////////////////////////////////////////
//         ////////////////////////////////////////////////////////////////////////////////
//         // ////////////////////////////////////////////////////////////////////////////////
//         // body: Center(
//         //   child: Container(
//         //     height: Adaptive.h(50),
//         //     width: Adaptive.w(80),
//         //     color: Colors.white,
//         //
//         //     child: Column(
//         //       children: [
//         //         Expanded(
//         //           // height:
//         //           //     Adaptive.h(40),
//         //           child: GetX<PostController>(
//         //               init: Get.put(PostController()),
//         //               builder: (con) {
//         //                 if (con.getCommentList.length == 0) {
//         //                   return Column(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     children: [
//         //                       Text(
//         //                         'No comment to show',
//         //                         style: Theme.of(context).textTheme.subtitle1,
//         //                       ),
//         //                     ],
//         //                   );
//         //                 }
//         //
//         //                 return ListView.builder(
//         //                     itemCount: con.getCommentList.length,
//         //                     itemBuilder: ((context, index) {
//         //                       return Container(
//         //                         margin: EdgeInsets.all(8),
//         //                         child: Row(
//         //                           children: [
//         //                             CircleAvatar(
//         //                               backgroundImage: NetworkImage(
//         //                                   con.getCommentList[index].imageUrl!),
//         //                             ),
//         //                             SizedBox(
//         //                               width: Adaptive.w(5),
//         //                             ),
//         //                             Column(
//         //                               children: [
//         //                                 SizedBox(
//         //                                   width: Adaptive.w(60),
//         //                                   child: Text(
//         //                                     con.getCommentList[index].userName!,
//         //                                     maxLines: 8,
//         //                                     overflow: TextOverflow.ellipsis,
//         //                                     style: const TextStyle(
//         //                                         color: kprimaryColor,
//         //                                         fontWeight: FontWeight.bold),
//         //                                   ),
//         //                                 ),
//         //                                 SizedBox(
//         //                                   height: Adaptive.w(2),
//         //                                 ),
//         //                                 SizedBox(
//         //                                   width: Adaptive.w(60),
//         //                                   child: Text(
//         //                                     con.getCommentList[index]
//         //                                         .commentText!,
//         //                                     maxLines: 8,
//         //                                     overflow: TextOverflow.ellipsis,
//         //                                   ),
//         //                                 )
//         //                               ],
//         //                             )
//         //                           ],
//         //                         ),
//         //                       );
//         //                     }));
//         //               }),
//         //         ),
//         //         TextField(
//         //           decoration: const InputDecoration(
//         //               enabledBorder: OutlineInputBorder(
//         //                   borderSide: BorderSide(color: kprimaryColor))),
//         //           controller: commentText,
//         //           style: const TextStyle(height: 0.2),
//         //         ),
//         //         Row(
//         //           mainAxisAlignment: MainAxisAlignment.end,
//         //           children: [
//         //             TextButton(
//         //               onPressed: () {
//         //                 Get.back();
//         //               },
//         //               child: const Text(
//         //                 'Cancel',
//         //                 style: TextStyle(color: kprimaryColor),
//         //               ),
//         //             ),
//         //             TextButton(
//         //               onPressed: () {
//         //                 if (commentText.text.trim() != "") {
//         //                   postController
//         //                       .commentOntPost(
//         //                     authenticationController.getUserData,
//         //                     postModel,
//         //                     commentText.text,
//         //                   )
//         //                       .then((value) {
//         //                     commentText.clear();
//         //                   });
//         //                 }
//         //               },
//         //               child: const Text(
//         //                 'Comment',
//         //                 style: TextStyle(color: kprimaryColor),
//         //               ),
//         //             )
//         //           ],
//         //         )
//         //       ],
//         //     ),
//         //   ),
//         // ),

//         ));
//   }

  Future<void> deleteComment(String productId, PostModel postModel,
      DocumentReference<Map<String, dynamic>>? documentReference) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
    //.collection('comments').doc(productId).delete();
        .collection('comments')
        .doc(documentReference!.id)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postModel.postId)
          .update({"total_comments": postController.getCommentList.length});
    });

    // ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted a product')));
  }

  Future<void> updateComment(
      PostModel postModel,
      DocumentReference<Map<String, dynamic>>? documentReference,
      String? text) async {
    final TextEditingController nameController = TextEditingController();

    if (text != null) {
      nameController.text = text;
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 25),
                  //decoration: const InputDecoration(labelText: 'edit comment'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                  ),
                  onPressed: () async {
                    final String new_comment = nameController.text;

                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postModel.postId)
                        .collection('comments')
                        .doc(documentReference!.id)
                        .update({"comment_text": new_comment});
                    nameController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> deletePost(
      DocumentReference<Map<String, dynamic>>? documentReference) async {
    await FirebaseFirestore.instance
        .collection('posts')
    //  .doc(postModel.postId)
    //.collection('comments').doc(productId).delete();
    //.collection('comments').
        .doc(documentReference!.id)
        .delete();

    // ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted a product')));
  }

  Future<void> updatePost(
      DocumentReference<Map<String, dynamic>>? documentReference,
      String? text) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController nameController2 = TextEditingController();
    if (text != null) {
      nameController.text = text;
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("post_title:"),
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 25),
                  //decoration: const InputDecoration(labelText: 'edit comment'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("post_description:"),
                TextField(
                  controller: nameController2,
                  style: TextStyle(fontSize: 25),
                  //decoration: const InputDecoration(labelText: 'edit comment'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                  ),
                  onPressed: () async {
                    final String new_post = nameController.text;
                    final String new_post_disc = nameController2.text;
                    if (new_post_disc == "" || new_post == "") {
                      // ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
                      //     content: Text('Empty Fields')));
                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(
                      //   //duration: Duration(milliseconds : 1000),
                      //   content: Text(
                      //       'Please fill all the mandatory filleds'),
                      //   behavior: SnackBarBehavior
                      //       .floating, // Add this line
                      // ));
                      return;
                    }
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(documentReference!.id)
                        .update({
                      "post_title": new_post,
                      "post_description": new_post_disc
                    });
                    nameController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }
}
