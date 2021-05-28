import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/pages/main_page.dart';
import 'package:social_start/utils/constants.dart';

class SplashScreenPage extends StatefulWidget{
  final bool openMain;
  SplashScreenPage(this.openMain);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with TickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), (){
      print("finished");
      if(widget.openMain){
        if(FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacementNamed(context, LoginPage.pageName);
        }
        else{
          Navigator.pushReplacementNamed(context, MainPage.pageName);
        }
      }
    });
    return Scaffold(
      body: SizedBox(
        width: kScreenWidth(context),
        height: kScreenHeight(context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Center(child: Image(image: AssetImage("assets/images/logo.png"), width: 400,))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SpinKitWave(
                color: kAccentColor,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}