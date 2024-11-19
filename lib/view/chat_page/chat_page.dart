import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/controller/chat_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Chat extends StatefulWidget {
  const Chat(
      {Key? key,
      required this.isDirectChat,
      this.receiverEmail,
      this.receiverID,
      this.receiverImage,
      this.receiverName,
      this.senderEmail,
      this.notificationId,
      this.senderID,
      this.isFormNotification = false,
      required this.receiverToken,
      this.senderImage,
      this.senderName})
      : super(key: key);
  final bool isDirectChat;
  final String? senderID;
  final String? senderName;
  final String? senderEmail;
  final String? senderImage;
  final String? receiverID;
  final String? receiverName;
  final String? receiverEmail;
  final String? receiverImage;
  final String receiverToken;
  final bool? isFormNotification;
  final String? notificationId;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController txtMessage = TextEditingController();
  ChatController chatController = Get.put(ChatController());
  AuthenticationController authController = Get.put(AuthenticationController());

  @override
  void initState() {
    print('userToken is ${widget.receiverToken}');
    chatController.getAllMessageFunc(widget.senderID!, widget.receiverID!);
    if (widget.isFormNotification!) {
      // notificationController.makeNotificaitonAsRead(
      //     authController.getuser.userId!, widget.notificationId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());

    Widget sentField() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.all(8.0),
            height: 61,
            child: Row(children: <Widget>[
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    // CustomIconButton(
                    //     iconData: FontAwesomeIcons.images, onPressed: () {}),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: chatController.txtMessageCOn,
                          decoration: const InputDecoration(
                              hintText: "Type Something...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                          color: kprimaryColor, shape: BoxShape.circle),
                      child: InkWell(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onTap: () {
                          if (chatController.txtMessageCOn.text.isNotEmpty) {
                            chatController
                                .sendMessage(
                                    senderToken:
                                        authController.getUserData.oneSinalId!,
                                    receiverToken: widget.receiverToken,
                                    senderID: widget.senderID!,
                                    senderName: widget.senderName!,
                                    senderEmail: widget.senderEmail!,
                                    senderImage: widget.senderImage!,
                                    receiverID: widget.receiverID!,
                                    receiverName: widget.receiverName!,
                                    receiverEmail: widget.receiverEmail!,
                                    receiverImage: widget.receiverImage!,
                                    txtMessage:
                                        chatController.txtMessageCOn.text)
                                .then((value) {
                              chatController.txtMessageCOn.clear();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ))
            ])),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimaryColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.receiverImage!),
              ),
              SizedBox(
                width: Adaptive.w(5),
              ),
              Text(
                widget.receiverName!,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: GetX<ChatController>(
                  init: Get.put(ChatController()),
                  builder: (cont) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: cont.getAllMessage.length,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Align(
                            alignment: (authController.getUserData.userId !=
                                cont.getAllMessage[index]
                                    .senderid //message.text != "userid"
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Column(
                              crossAxisAlignment:
                              authController.getUserData.userId !=
                                  cont.getAllMessage[index].senderid
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    authController.getUserData.userId ==
                                        cont.getAllMessage[index].senderid
                                        ? const BorderRadius.only(
                                        topLeft: Radius.circular(23),
                                        bottomRight: Radius.circular(23),
                                        bottomLeft: Radius.circular(23))
                                        : const BorderRadius.only(
                                        topRight: Radius.circular(23),
                                        bottomLeft: Radius.circular(23),
                                        bottomRight: Radius.circular(23)),
                                    color: (authController.getUserData.userId !=
                                        cont.getAllMessage[index].senderid
                                        ? kbackgroundColor
                                        : kprimaryColor),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    cont.getAllMessage[index].txtMessage!,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: authController
                                            .getUserData.userId ==
                                            cont.getAllMessage[index].senderid
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            sentField(),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function()? onPressed;
  final double iconSize;

  const CustomIconButton(
      {Key? key, required this.iconData, this.onPressed, this.iconSize = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(iconData),
      iconSize: iconSize,
      color: Colors.yellow,
    );
  }
}
