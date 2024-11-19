import 'package:confetti/confetti.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:lostandfound/model/post_model.dart';
import 'package:lostandfound/view/chat_page/chat_page.dart';
import 'package:lostandfound/view/home_page/show_map.dart';
import 'package:lostandfound/view/post_page/post_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lostandfound/controller/post_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'package:confetti/confetti.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  //HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool confetti_play = false;

  PostController postController = Get.put(PostController());
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  Animation<double>? animation;
  AnimationController? animationController;
  @override
  void dispose() {
    //confetti_cont.dispose();
    //super.dispose();
  }
  @override
  void initState() {
    super.initState();
    //confetti_cont.play();
    confetti_cont.addListener(() {
      setState(() {
        confetti_play =
            confetti_cont.state == ConfettiControllerState.stopped; // playing;
      });
    });
    authenticationController.getUser();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  bool isSearch = false;

  TextEditingController search = TextEditingController();

  TextEditingController commentText = TextEditingController();
  var timeList = [
    '1 Day',
    '5 Days',
    '10 Day',
    '15 Days',
    '30 Day',
  ];

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

  @override
  Widget build(BuildContext context) {
    TextTheme ktextTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).unfocus(),
        if (animationController!.isCompleted)
          {
            animationController!.reverse(),
          },
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            backgroundColor: kbackgroundColor,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

            floatingActionButton: FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: "Found",
                  iconColor: kprimaryColor,
                  bubbleColor: kprimaryColor,
                  icon: Icons.people,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    animationController!.reverse();
                    //confetti_cont.play();
                    Get.to(() => PostPage(
                          isLost: false,
                        ));

                    //sleep(Duration(seconds:3));
                    //confetti_cont.stop();
                  },
                ),
                //Floating action menu item
                Bubble(
                  title: "Lost",
                  iconColor: kprimaryColor,
                  bubbleColor: kprimaryColor,
                  icon: Icons.home,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Get.to(() => PostPage(
                          isLost: true,
                        ));
                    // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                    // animationController!.reverse();
                  },
                ),
              ],

              // animation controller
              animation: animation!,

              // On pressed change animation state
              onPress: () => animationController!.isCompleted
                  ? animationController!.reverse()
                  : animationController!.forward(),

              // Floating Action button Icon color
              iconColor: Colors.white,

              // Flaoting Action button Icon
              iconData: Icons.add,
              backGroundColor: kprimaryColor,
            ),

            // FloatingActionButton(
            //   backgroundColor: kprimaryColor,
            //   onPressed: () {
            //     Get.to(() => PostPage(
            //           isLost: true,
            //         ));
            //   },
            //   child: Icon(Icons.add),
            // ),
            appBar: AppBar(
              leading: postController.get_redirected_from_map()
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => {
                            postController.set_redirected_from_map(false),
                            Get.back()
                          }
                      //Navigator.of(context).pop(),
                      )
                  : null,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    isSearch
                        ? Expanded(
                            //  width: Adaptive.w(55),
                            child: TextField(
                            controller: search,
                            onChanged: ((value) {
                              setState(() {});
                            }),
                          ))
                        : Text(
                            'Lost & Found',
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
                postController.get_redirected_from_map()
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                            search.clear();
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.search,
                          color: kbackgroundColor,
                          size: Adaptive.px(20),
                        )),
                postController.get_redirected_from_map()
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          postFilterDialog();
                        },
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          color: kbackgroundColor,
                          size: Adaptive.px(20),
                        )),
                SizedBox(
                  width: Adaptive.px(20),
                )
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshott) {
                        if (streamSnapshott.hasData) {
                          return Column(
                            children: [
                              GetX<PostController>(
                                  init: Get.put(PostController()),
                                  builder: (cont) {
                                    if (cont.getpostlist.length == 0) {
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
                                        itemCount: cont.getpostlist.length,
                                        itemBuilder: ((context, index) {
                                          final DocumentSnapshot
                                              documentSnapshott =
                                              streamSnapshott.data!.docs[index];
                                          //final List<String> colors = s.split(' ');
                                          return (postController.get_redirected_from_map() &&
                                                      cont.getpostlist[index].date_time!.trim() ==
                                                          postController
                                                              .get_redirected_from_map_date()
                                                              .trim() &&
                                                      cont.getpostlist[index].userName!.trim() ==
                                                          postController
                                                              .get_redirected_from_map_user()
                                                              .trim() &&
                                                      cont.getpostlist[index]
                                                              .postTitle!
                                                              .trim() ==
                                                          postController
                                                              .get_redirected_from_map_title()
                                                              .trim()) ||
                                                  (postController.get_redirected_from_map() == false &&
                                                      (cont.getpostlist[index]
                                                              .userName!
                                                              .toUpperCase()
                                                              .contains(search
                                                                  .text
                                                                  .toUpperCase()) ||
                                                          cont.getpostlist[index]
                                                              .postDescription!
                                                              .toUpperCase()
                                                              .contains(search.text.toUpperCase()) ||
                                                          cont.getpostlist[index].postTitle!.toUpperCase().contains(search.text.toUpperCase()) ||
                                                          cont.getpostlist[index].postLocation!.toUpperCase().contains(search.text.toUpperCase()) ||
                                                          contains_list(cont.getpostlist[index].postDescription!.toUpperCase(), search.text.toUpperCase()) ||
                                                          contains_list(cont.getpostlist[index].postTitle!.toUpperCase(), search.text.toUpperCase()) ||
                                                          contains_list(cont.getpostlist[index].postLocation!.toUpperCase(), search.text.toUpperCase()) ||
                                                          contains_list(cont.getpostlist[index].userName!.toUpperCase(), search.text.toUpperCase())))
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Adaptive.w(5),
                                                      vertical: Adaptive.h(2)),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //       blurRadius: 2,
                                                      //       color: Colors.black12)
                                                      // ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          cont
                                                                  .getpostlist[
                                                                      index]
                                                                  .imageUrl!
                                                                  .isNotEmpty
                                                              ? CircleAvatar(
                                                                  backgroundImage: NetworkImage(cont
                                                                      .getpostlist[
                                                                          index]
                                                                      .imageUrl!),
                                                                )
                                                              : const CircleAvatar(
                                                                  backgroundColor:
                                                                      kprimaryColor,
                                                                  child: Icon(Icons
                                                                      .person),
                                                                ),
                                                          SizedBox(
                                                            width:
                                                                Adaptive.w(1.5),
                                                          ),
                                                          Text(
                                                            "${cont.getpostlist[index].objectType!} by ",
                                                            style: ktextTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                    color:
                                                                        kprimaryColor),
                                                          ),
                                                          SubstringHighlight(
                                                            text: cont
                                                                .getpostlist[
                                                                    index]
                                                                .userName!,
                                                            // search result string from database or something
                                                            term: search.text,
                                                            // user typed "et"
                                                            textStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            textStyleHighlight:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .yellow),
                                                          ),
                                                          /*Text(

                                                ' ${cont.getpostlist[index]
                                                    .userName!}',
                                                style: ktextTheme
                                                    .bodyLarge
                                                    ?.copyWith(),
                                              ),*/
                                                          Spacer(),
                                                          authenticationController
                                                                      .getUserData
                                                                      .userId ==
                                                                  cont
                                                                      .getpostlist[
                                                                          index]
                                                                      .userId
                                                              ? PopupMenuButton(
                                                                  onSelected:
                                                                      (value) {
                                                                  if (value ==
                                                                      'Edit') {
                                                                    updatePost(
                                                                        cont
                                                                            .getpostlist[
                                                                                index]
                                                                            .doc_ref,
                                                                        cont.getpostlist[index]
                                                                            .postTitle);
                                                                  } else {
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
                                                                            const Text('Are you sure you want to delete?'),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, 'Cancel'),
                                                                            child:
                                                                                const Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: kprimaryColor),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                {
                                                                              Navigator.pop(context, 'OK'),
                                                                              //Navigator.of(context).pop(),
                                                                              deletePost(cont.getpostlist[index].doc_ref),
                                                                              //Get.back(),
                                                                            },
                                                                            child:
                                                                                const Text(
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
                                                                      child: Text(
                                                                          'Edit Post'),
                                                                      value:
                                                                          'Edit',
                                                                    ),
                                                                    PopupMenuItem(
                                                                      child: Text(
                                                                          'Delete Post'),
                                                                      value:
                                                                          'Delete',
                                                                    )
                                                                  ];
                                                                })
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left:
                                                                    Adaptive.w(
                                                                        12)),
                                                        child: Row(
                                                          children: [
                                                            cont
                                                                    .getpostlist[
                                                                        index]
                                                                    .postUrl!
                                                                    .isNotEmpty
                                                                ? Container(
                                                                    height:
                                                                        Adaptive.h(
                                                                            10),
                                                                    width:
                                                                        Adaptive.w(
                                                                            15),
                                                                    child: Image
                                                                        .network(
                                                                      cont
                                                                          .getpostlist[
                                                                              index]
                                                                          .postUrl!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    color:
                                                                        kprimaryColor,
                                                                  )
                                                                : Container(
                                                                    height:
                                                                        Adaptive.h(
                                                                            10),
                                                                    width:
                                                                        Adaptive.w(
                                                                            15),
                                                                  ),
                                                            SizedBox(
                                                              width:
                                                                  Adaptive.w(3),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      Adaptive.w(
                                                                          50),
                                                                  child:
                                                                      SubstringHighlight(
                                                                    text: cont
                                                                        .getpostlist[
                                                                            index]
                                                                        .postTitle!, // search result string from database or something
                                                                    term: search
                                                                        .text, // user typed "et"
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textStyleHighlight:
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.yellow),
                                                                  ), /*Text(
                                                              cont
                                                                  .getpostlist[
                                                                      index]
                                                                  .postTitle!,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: ktextTheme
                                                                  .headline5,
                                                            ),*/
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      Adaptive
                                                                          .h(2),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      Adaptive.w(
                                                                          50),
                                                                  child:
                                                                      SubstringHighlight(
                                                                    text: cont
                                                                        .getpostlist[
                                                                            index]
                                                                        .postDescription!, // search result string from database or something
                                                                    term: search
                                                                        .text, // user typed "et"
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textStyleHighlight:
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.yellow),
                                                                  ), /*Text(
                                                              cont
                                                                  .getpostlist[
                                                                      index]
                                                                  .postDescription!,
                                                              maxLines: 4,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: ktextTheme
                                                                  .bodyLarge,
                                                            ),*/
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      Adaptive.w(
                                                                          50),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Get.to(() =>
                                                                          ShowMap(
                                                                              postModel: cont.getpostlist[index]));
                                                                    },
                                                                    child:
                                                                        SubstringHighlight(
                                                                      text:
                                                                          '${cont.getpostlist[index].objectType!} at ${cont.getpostlist[index].postLocation!}', // search result string from database or something
                                                                      term: search.text.toLowerCase() ==
                                                                              'found'.toLowerCase()
                                                                          ? ''
                                                                          : search.text, // user typed "et"
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: Colors.black),
                                                                      textStyleHighlight:
                                                                          const TextStyle(
                                                                              color: Colors.yellow),
                                                                    ), /*Text(
                                                                ' -  ${cont.getpostlist[index].objectType!} at ${cont.getpostlist[index].postLocation!}',
                                                                style: ktextTheme
                                                                    .bodyLarge,
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),*/
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Adaptive.h(2),
                                                      ),
                                                      const Divider(
                                                        thickness: 2,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: authenticationController
                                                            .getUserData
                                                            .userId ==
                                                            cont
                                                                .getpostlist[
                                                            index]
                                                                .userId
                                                            ? MainAxisAlignment
                                                            .center
                                                            : MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                dialoger(
                                                                    context,
                                                                    cont
                                                                        .getpostlist[
                                                                            index]
                                                                        .postId!,
                                                                    cont.getpostlist[
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
                                                                    width:
                                                                        Adaptive
                                                                            .w(2),
                                                                  ),
                                                                  Text(
                                                                    'Comment',
                                                                    style: ktextTheme
                                                                        .headline6,
                                                                  ),
                                                                ],
                                                              )),
                                                          authenticationController
                                                                      .getUserData
                                                                      .userId ==
                                                                  cont
                                                                      .getpostlist[
                                                                          index]
                                                                      .userId
                                                              ? SizedBox()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(() =>
                                                                        Chat(
                                                                          isDirectChat:
                                                                              true,
                                                                          receiverToken: cont
                                                                              .getpostlist[index]
                                                                              .oneSignalId!,
                                                                          isFormNotification:
                                                                              false,
                                                                          notificationId:
                                                                              '',
                                                                          receiverEmail: cont
                                                                              .getpostlist[index]
                                                                              .userName!,
                                                                          receiverID: cont
                                                                              .getpostlist[index]
                                                                              .userId!,
                                                                          receiverImage: cont
                                                                              .getpostlist[index]
                                                                              .imageUrl!,
                                                                          receiverName: cont
                                                                              .getpostlist[index]
                                                                              .firstName!,
                                                                          senderEmail: authenticationController
                                                                              .getUserData
                                                                              .userName,
                                                                          senderID: authenticationController
                                                                              .getUserData
                                                                              .userId,
                                                                          senderImage: authenticationController
                                                                              .getUserData
                                                                              .imageUrl,
                                                                          senderName: authenticationController
                                                                              .getUserData
                                                                              .firstName,
                                                                        ));
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .mail,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      SizedBox(
                                                                        width: Adaptive
                                                                            .w(2),
                                                                      ),
                                                                      Text(
                                                                        'Chat',
                                                                        style: ktextTheme
                                                                            .headline6,
                                                                      ),
                                                                    ],
                                                                  )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox();
                                        }));
                                  })
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      })),
            ),
          ),
          //cofetti here
          ConfettiWidget(
            confettiController: confetti_cont,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 200,
            colors: const [
              kprimaryColor,
              kbackgroundColor,
              //Colors.yellow,
              Colors.black,
            ],
          )
        ],
      ),
    );
  }

  postFilterDialog() {
    Get.dialog(Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Container(
              height: Adaptive.h(44),
              width: Adaptive.w(80),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Adaptive.w(5), vertical: Adaptive.h(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post type',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: kprimaryColor),
                    ),
                    SizedBox(
                      height: Adaptive.h(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Lost Posts',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kprimaryColor),
                        ),
                        Obx(
                          () => Checkbox(
                            value: postController.isLost.value,
                            onChanged: (bool? value) {
                              postController.isLost.value = value!;

                              // setState(() {
                              //   this.value = value;
                              // });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Found Posts',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kprimaryColor),
                        ),
                        Obx(
                          () => Checkbox(
                            value: postController.isFound.value,
                            onChanged: (bool? value) {
                              postController.isFound.value = value!;

                              // setState(() {
                              //   this.value = value;
                              // });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Most commented Post',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kprimaryColor),
                        ),
                        Obx(
                          () => Checkbox(
                            value: postController.isMostComment.value,
                            onChanged: (bool? value) {
                              postController.isMostComment.value = value!;

                              // setState(() {
                              //   this.value = value;
                              // });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time range',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: kprimaryColor),
                        ),
                        Obx(
                          () => DropdownButton(
                            // Initial Value
                            value: postController.timeRange.value,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: timeList.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              postController.timeRange.value = newValue!;
                            },
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              postController
                                  .getFilterStream(true)
                                  .then((value) {
                                Get.back();
                              });
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: kprimaryColor),
                            )),
                        TextButton(
                            onPressed: () {
                              postController
                                  .getFilterStream(false)
                                  .then((value) {
                                Get.back();
                              });
                            },
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: kprimaryColor),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));
  }

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

  bool contains_list(String post, String text) {
    //aux for 245
    //cont.getpostlist[index].userName!
    //         .toUpperCase()
    //        .contains(search.text.toUpperCase())
    if (postController.get_redirected_from_map()) {
      return false;
    }
    var list = text.toUpperCase().split(' ');
    bool result = false;
    for (var element in list) {
      if (post.toUpperCase().contains(element)) {
        result = true;
      }
    }
    return result;
  }
}
