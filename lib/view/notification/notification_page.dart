import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/notification_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  NotificationController notificationController =
      Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        title: const Text(
          "Notifications",
          style: TextStyle(color: kbackgroundColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              GetX<NotificationController>(
                  init: Get.put(NotificationController()),
                  builder: (con) {
                    if (con.getNotification.length == 0) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: Adaptive.h(40),
                            ),
                            Text(
                              'Notification is not available ',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: con.getNotification.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            //  color: Colors.amber,
                            padding: EdgeInsets.symmetric(
                                vertical: Adaptive.h(1),
                                horizontal: Adaptive.w(2)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    con.getNotification[index].imageUrl!
                                            .isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(con
                                                .getNotification[index]
                                                .imageUrl!),
                                          )
                                        : CircleAvatar(),
                                    SizedBox(
                                      width: Adaptive.w(4),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          con.getNotification[index].email!,
                                          style: TextStyle(
                                              fontSize: Adaptive.px(17),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          con.getNotification[index].content!,
                                          style: TextStyle(
                                            fontSize: Adaptive.px(16),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        }));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
