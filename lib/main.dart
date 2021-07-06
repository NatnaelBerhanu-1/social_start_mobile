import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/EditProfilePage.dart';
import 'package:social_start/pages/change_password_page.dart';
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/pages/main_page.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/new_post_page.dart';
import 'package:social_start/pages/post_detail_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/pages/purchase_products_page.dart';
import 'package:social_start/pages/purchase_socialpoint.dart';
import 'package:social_start/pages/settings_page.dart';
import 'package:social_start/pages/signup_page.dart';
import 'package:social_start/pages/splash_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/viewmodels/post_viewmodel.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';


void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openLazyBox(kAppCacheDBName);
  await Firebase.initializeApp();
  Hive.registerAdapter(UserAdapter());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PostViewModel())
    ],
    child: MyApp(),
  ));
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocialStart',
      onGenerateRoute: (settings) {
        var args = settings.arguments;
        if (settings.name == SignUpPage.pageName) {
          return MaterialPageRoute(builder: (context) => SignUpPage());
        } else if (settings.name == LoginPage.pageName) {
          return MaterialPageRoute(builder: (context) => LoginPage());
        } else if (settings.name == MainPage.pageName) {
          return MaterialPageRoute(builder: (context) => MainPage());
        } else if (settings.name == ProfilePage.pageName) {
          String pageArgs = settings.arguments as String;
          return MaterialPageRoute(builder: (context) => ProfilePage(userId: pageArgs,));
        } else if (settings.name == NewPostPage.pageName) {
          return MaterialPageRoute(builder: (context) => NewPostPage());
        } else if (settings.name == ChatPage.pageName) {
          Chat args = settings.arguments;
          return MaterialPageRoute(builder: (context) => ChatPage(chat: args, receiverId: args.user2Id, chatId: args.id,));
        } else if (settings.name == EditProfilePage.pageName) {
          return MaterialPageRoute(builder: (context) => EditProfilePage());
        }else if (settings.name == PostDetailPage.pageName){
          PostDetailPageArgs pageArgs = settings.arguments as PostDetailPageArgs;
          return MaterialPageRoute(builder: (context) => PostDetailPage(post: pageArgs.post, user: pageArgs.user));
        }else if (settings.name == SettingsPage.pageName){
          return MaterialPageRoute(builder: (context) => SettingsPage());
        }else if (settings.name == PurchaseSocialPointPage.pageName){
          return MaterialPageRoute(builder: (context) => PurchaseSocialPointPage());
        }else if (settings.name == ChangePasswordPage.pageName){
          return MaterialPageRoute(builder: (context) => ChangePasswordPage());
        }else if (settings.name == PurchaseProductsPage.pageName){
          return MaterialPageRoute(builder: (context) => PurchaseProductsPage());
        }
        return null;
      },
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
        ),
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
