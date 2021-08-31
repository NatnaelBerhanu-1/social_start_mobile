import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';

import 'dark_mode_switch.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData actionIcon;
  final Function actionPressed;
  bool showBackArrow = true;
  CustomAppBar(
      {@required this.title,
      this.actionIcon,
      this.actionPressed,
      this.showBackArrow = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userVM, child) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          // border:
          //     Border(bottom: BorderSide(color: Colors.black12, width: 1.0))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showBackArrow
                ? IconButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                    ),
                  )
                : SizedBox(
                    width: 10,
                  ),
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Subscribers: ${userVM.user.followers.length}",
                    style: _textStyleAppBarDetail(),
                  ),
                  Text(
                    "Likes: ${userVM.user.likes}",
                    style: _textStyleAppBarDetail(),
                  ),
                  Text(
                    "Views: ${userVM.user.views}",
                    style: _textStyleAppBarDetail(),
                  ),
                  Text(
                    "Social Points: ${userVM.user.socialPoint.daily + userVM.user.socialPoint.permanent}",
                    style: _textStyleAppBarDetail(),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Center(
                    // child: Text(
                    //   '$title',
                    //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    // ),
                    child: Image.asset("assets/images/social_start_header.png",
                        height: 60, fit: BoxFit.fitHeight))),
            SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$0.00",
                    style: _textStyleAppBarDetail(),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "Dark Mode",
                    textAlign: TextAlign.right,
                    style: _textStyleAppBarDetail(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DarkModeSwitch()
                ],
              ),
            ),
            actionIcon == null
                ? SizedBox(width: 10)
                : IconButton(
                    icon: Icon(
                      actionIcon,
                    ),
                    onPressed: actionPressed),
          ],
        ),
      ),
    );
  }

  _textStyleAppBarDetail() {
    return TextStyle(
      fontSize: 12.0,
    );
  }
}
