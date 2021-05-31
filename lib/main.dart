import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/EditProfilePage.dart';
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/pages/main_page.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/new_post_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/pages/signup_page.dart';
import 'package:social_start/pages/splash_page.dart';
import 'package:social_start/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openLazyBox(kAppCacheDBName);
  await Firebase.initializeApp();
  Hive.registerAdapter(UserAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social start',
      onGenerateRoute: (settings) {
        var args = settings.arguments;
        if (settings.name == SignUpPage.pageName) {
          return MaterialPageRoute(builder: (context) => SignUpPage());
        } else if (settings.name == LoginPage.pageName) {
          return MaterialPageRoute(builder: (context) => LoginPage());
        } else if (settings.name == MainPage.pageName) {
          return MaterialPageRoute(builder: (context) => MainPage());
        } else if (settings.name == ProfilePage.pageName) {
          return MaterialPageRoute(builder: (context) => ProfilePage());
        } else if (settings.name == NewPostPage.pageName) {
          return MaterialPageRoute(builder: (context) => NewPostPage());
        } else if (settings.name == ChatPage.pageName) {
          return MaterialPageRoute(builder: (context) => ChatPage());
        } else if (settings.name == EditProfilePage.pageName) {
          return MaterialPageRoute(builder: (context) => EditProfilePage());
        }
        return null;
      },
      theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          primaryColor: kPrimaryColor,
          fontFamily: 'Roboto',
          textTheme: TextTheme(
              bodyText2: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.normal),
              headline1: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
              headline4: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
              headline5: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryLightColor))),
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // return error widget
            }
            if (snapshot.connectionState == ConnectionState.done) {
              // return success widget
              return SplashScreenPage(true);
            }
            return SplashScreenPage(false);
          }),
    );
  }
}
