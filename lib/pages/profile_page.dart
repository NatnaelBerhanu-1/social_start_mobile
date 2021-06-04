import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/pages/EditProfilePage.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/post_item.dart';

class ProfilePage extends StatelessWidget {
  static final String pageName = "profile";

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: kBackgroundColor,
    // ));
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed:
          (){
            Navigator.pushNamed(context, EditProfilePage.pageName);
          }
          )
        ],
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: kScreenWidth(context),
              height: 210,
              child: Stack(
                children: [
                  Image.asset('assets/images/sample_banner.jpg', fit: BoxFit.cover, height: 150, width: kScreenWidth(context),),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/images/sample_profile_pic.jpg', fit: BoxFit.cover,),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "John Doe",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: kAccentColor,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_alt_1_rounded,color: Colors.white,
                        ),
                        SizedBox(width: 5,),
                        Text("Follow", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    "Single",
                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 4,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                PostItem(padding: 0.0,post: Post(caption: "caption", fileUrl: "https://i.picsum.photos/id/607/200/300.jpg?hmac=ZEvzqI62NudR3rgqTkRZzFnlEeOt9z-b_i8VdLoTgoI", ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
