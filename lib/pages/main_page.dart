import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/pages/chats_list.dart';
import 'package:social_start/pages/home_page.dart';
import 'package:social_start/pages/post_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/pages/search_page.dart';
import 'package:social_start/pages/settings_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/custom_appbar.dart';

import 'login_page.dart';
import 'new_post_page.dart';
import 'videos_page.dart';

class MainPage extends StatefulWidget {
  static final String pageName = "main";
  final String userId;
  MainPage({@required this.userId}) : assert(userId != null);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> pages = [];
  AuthController _authController = AuthController();

  @override
  void initState() {
    pages = [
      ProfilePage(
        userId: widget.userId,
      ),
      HomePage(),
      PostPage(),
      // VideosPage(),
      ChatList(),
      SettingsPage(),
      // HomePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("SocialStart", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),
        //   centerTitle: true,
        //   backgroundColor: Theme.of(context).backgroundColor,
        //   elevation: 0.0,
        // ),
        appBar: PreferredSize(
          child: CustomAppBar(
            title: "SocialStart",
            showBackArrow: false,
          ),
          preferredSize: Size.fromHeight(100),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(child: pages[_selectedIndex]),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomNavItem(index: 0, icon: Icons.person, label: "Profile"),
                _bottomNavItem(index: 1, icon: Icons.search, label: "Search"),
                _bottomNavItem(index: 2, icon: Icons.camera_alt, label: "Post"),
                // _bottomNavItem(
                // index: 3, icon: Icons.video_call_rounded, label: "Videos"),
                _bottomNavItem(index: 3, icon: Icons.message, label: "Inbox"),
                _bottomNavItem(
                    index: 4, icon: Icons.settings, label: "Settings"),
                // _bottomNavItem(
                //     index: 4, icon: Icons.notifications, label: "Notif"),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, NewPostPage.pageName);
        //   },
        //   backgroundColor: kPrimaryColor,
        //   elevation: 2.0,
        //   tooltip: "Post",
        //   child: Icon(
        //     Icons.camera,
        //     color: Colors.white,
        //     size: 40.0,
        //   ),
        // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  _bottomNavItem({int index, IconData icon, String label}) {
    Color color = _selectedIndex == index
        ? Colors.red
        : Theme.of(context).accentIconTheme.color;
    FontWeight fontWeight =
        _selectedIndex == index ? FontWeight.bold : FontWeight.normal;
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
            Text(
              '$label',
              style: TextStyle(color: color, fontWeight: fontWeight),
            )
          ],
        ),
      ),
    );
  }
}
