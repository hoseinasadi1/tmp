import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lostandfound/app_constants/constants.dart';
import 'package:lostandfound/controller/authentication_controller.dart';
import 'package:lostandfound/profile_page/profile_page.dart';
import 'package:lostandfound/view/chat_page/all_users_for_chat.dart';
import 'package:lostandfound/view/chat_page/chat_page.dart';
import 'package:lostandfound/view/home_page/home_page.dart';
import 'package:lostandfound/view/mape_page/map_page.dart';
import 'package:lostandfound/view/notification/notification_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int selexetedIndex = 0;
  List<Widget> pages = [
    HomePage(),
    AllUsersPage(),
    GoogleMapScreen(),
    NotificationPage(),
    ProfilePage()
  ];
  AuthenticationController auth = AuthenticationController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await auth.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selexetedIndex],
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            // <-- HERE
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on), label: 'Location'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Notifications'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                label: 'Profile',
              )
            ],
            currentIndex: selexetedIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: kprimaryColor,
            onTap: _onItemTapped)
        // body: SafeArea(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Expanded(child: pages[selexetedIndex]),
        //          Row(
        //           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             IconWidget(Icons.home, 0),
        //            // IconWidget(Icons.chat, 1),
        //            // IconWidget(Icons.notifications, 2),
        //             IconWidget(Icons.person, 3)
        //           ],
        //         ),
        //
        //     ],
        //   ),
        // ),
        );
  }

  void _onItemTapped(int index) {
    setState(() {
      selexetedIndex = index;
    });
  }
}
//   Widget IconWidget(IconData iconData, int index) {
//     return IconButton(
//         onPressed: () {
//           setState(() {
//             selexetedIndex = index;
//           });
//         },
//         icon: Icon(
//           iconData,
//           color: selexetedIndex == index ? Colors.deepPurple : kprimaryColor,
//           size: Adaptive.px(30),
//         ));
//   }
// }
