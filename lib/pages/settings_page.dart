import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/purchase_products_page.dart';
import 'package:social_start/pages/purchase_socialpoint.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/custom_appbar.dart';

import 'EditProfilePage.dart';
import 'change_password_page.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  static final pageName = "settings";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthController _authController = AuthController();
  UserController _userController = UserController();

  var userFuture;

  @override
  void initState() {
    userFuture = _userController.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: "Settings"),
            SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: userFuture,
                    builder: (context, AsyncSnapshot<User> snapshot) {
                      var socialPoint = "----";
                      if(snapshot.hasData){
                        socialPoint = "${snapshot.data.socialPoint.daily + snapshot.data.socialPoint.permanent}";
                      }
                      return Container(
                        width: kScreenWidth(context),
                        margin: EdgeInsets.all(16.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: kBorderColor
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/images/gold_medal.png', width: 80, height: 100,),
                            Text(
                              "$socialPoint",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                fontSize: 24.0
                              ),
                            ),
                            Text(
                              "Social Points",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal
                              ),
                            ),
                            TextButton(onPressed: (){
                              Navigator.pushNamed(context, PurchaseProductsPage.pageName);

                            }, child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text("Purchase", style: TextStyle(color: Colors.white),),
                            ))
                          ],
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 20.0,),
                  _buildSettingItems(icon: Icons.person, title: "Edit profile", onPressed: (){
                    Navigator.pushNamed(context, EditProfilePage.pageName);
                  }),
                  _buildSettingItems(icon: Icons.vpn_key, title: "Change password", onPressed: (){
                    Navigator.pushNamed(context, ChangePasswordPage.pageName);
                  }),
                  _buildSettingItems(icon: Icons.logout, title: "Logout", onPressed: (){
                    showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext mContext){
                                return AlertDialog(
                                  title: Text("Do you wan't to logout?"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                            Navigator.of(mContext).pop();
                                },
                                      child: Text("No", ),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        _authController.signOut();
                                        Navigator.pushNamedAndRemoveUntil(context, LoginPage.pageName, (route) => false);
                                      },
                                      child: Text("Yes",style:TextStyle(color: Colors.black26),),
                                    )
                                  ],
                                );
                              }
                            );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildSettingItems({IconData icon, String title, Function() onPressed}) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black26,),
            SizedBox(width: 10.0,),
            Text("$title", style: TextStyle(fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }
}