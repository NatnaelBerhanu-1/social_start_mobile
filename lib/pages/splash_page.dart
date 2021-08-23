import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/pages/main_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';

class SplashScreenPage extends StatefulWidget{
  static final pageName = "splashScreen";
  final bool openMain;
  SplashScreenPage(this.openMain);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser == null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 3), (){
          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.pageName, (route) => false);
        });
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 3), (){
          Provider.of<UserViewModel>(context, listen: false).getUser();
          // Provider.of<UserViewModel>(context, listen: false).checkSubscription();
        });
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
            Consumer<UserViewModel>(
              builder: (context, userViewModel, child){
                print(userViewModel.userStatus);
                if(userViewModel.userStatus == UserStatus.success){
                  print(userViewModel.user.toJson());
                  if(userViewModel.user.blocked == true){
                    return Text(
                      "Your account has been blocked, please try again later",
                    );
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(MainPage.pageName, (route) => false, arguments: userViewModel.user.uid);
                  });
                }
                if(userViewModel.userStatus == UserStatus.failed){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Something went wrong!!',
                      ),
                      TextButton(onPressed: (){
                        Provider.of<UserViewModel>(context, listen: false).getUser();
                      }, child: Text('retry', style: TextStyle(color: kAccentColor),))
                    ]
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SpinKitFadingCircle(
                    color: kAccentColor,
                    size: 25,
                  ),
                );
              },

            )
          ],
        ),
      ),
    );
  }
}