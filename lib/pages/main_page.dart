import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/pages/chats_list.dart';
import 'package:social_start/pages/home_page.dart';
import 'package:social_start/pages/search_page.dart';
import 'package:social_start/utils/constants.dart';

import 'login_page.dart';
import 'new_post_page.dart';
import 'videos_page.dart';

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
    VideosPage(),
    ChatList(),
    // HomePage(),
  ];
  AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child:pages[_selectedIndex]),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
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
        backgroundColor: kPrimaryColor,
        elevation: 2.0,
        tooltip: "Post",
        child: Icon(
          Icons.camera,
          color: Colors.white,
          size: 40.0,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  _bottomNavItem({int index, IconData icon, String label}) {
    Color color = _selectedIndex == index ? Theme.of(context).primaryColor : Theme.of(context).accentIconTheme.color;
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
