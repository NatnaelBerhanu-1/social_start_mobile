import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/pages/chats_list.dart';
import 'package:social_start/pages/home_page.dart';
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/pages/search_page.dart';
import 'package:social_start/utils/constants.dart';

import 'new_post_page.dart';

class MainPage extends StatefulWidget {
  static final String pageName = "main";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    HomePage(),
    ChatList(),
    // HomePage(),
  ];
  AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: kPrimaryColor,
      //   leading: null,
      //   title: Text('SocialStart'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: (){
      //         showDialog<void>(
      //           context: context,
      //           barrierDismissible: false,
      //           builder: (BuildContext mContext){
      //             return AlertDialog(
      //               title: Text("Do you wan't to logout?"),
      //               actions: [
      //                 TextButton(
      //                   onPressed: (){
      //                         Navigator.of(mContext).pop();
      //             },
      //                   child: Text("No", ),
      //                 ),
      //                 TextButton(
      //                   onPressed: (){
      //                     Navigator.pushNamedAndRemoveUntil(context, LoginPage.pageName, (route) => false);
      //                   },
      //                   child: Text("Yes",style:TextStyle(color: Colors.black26),),
      //                 )
      //               ],
      //             );
      //           }
      //         );
      //         _authController.signOut();
      //       },
      //       icon: Icon(Icons.logout,semanticLabel: "logout",),
      //     )
      //   ],
      // ),
      body: SafeArea(child:pages[_selectedIndex]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bottomNavItem(index: 0, icon: Icons.home, label: "Home"),
              _bottomNavItem(index: 1, icon: Icons.search, label: "Search"),
              Expanded(
                child: SizedBox(),
              ),
              _bottomNavItem(
                  index: 2, icon: Icons.video_call_rounded, label: "Videos"),
              _bottomNavItem(index: 3, icon: Icons.message, label: "Messages"),
              // _bottomNavItem(
              //     index: 4, icon: Icons.notifications, label: "Notif"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewPostPage.pageName);
        },
        backgroundColor: kAccentColor,
        elevation: 2.0,
        tooltip: "Post",
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  _bottomNavItem({int index, IconData icon, String label}) {
    Color color = _selectedIndex == index ? kPrimaryColor : Colors.black12;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
            ),
            // Text('$label', style: TextStyle(color: color),)
          ],
        ),
      ),
    );
  }
}
