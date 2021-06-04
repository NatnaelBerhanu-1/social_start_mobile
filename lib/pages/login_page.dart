import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart' as usr;
import 'package:social_start/pages/main_page.dart';
import 'package:social_start/pages/signup_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/widgets/circular_logo.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  static final String pageName = "login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _showPassword = false;

  String _email = "";
  String _password = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: kPrimaryColor,
              height: kScreenHeight(context),
              width: kScreenWidth(context),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child:
                  CircularLogoWidget()
              ),
            ),
            Positioned(
              top: 130,
              height: kScreenHeight(context),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                padding: EdgeInsets.all(20.0),
                width: kScreenWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log-in',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    ),
                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                _email = value;
                              });
                            },
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'This field is required';
                              }else if(!isEmail(value)){
                                return 'Invalid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(fontSize: 16)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'This field is required';
                              }
                              return null;
                            },
                            onChanged: (value){
                              setState(() {
                                _password = value;
                              });
                            },
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 16),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  icon: Icon(_showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextButton(
                              onPressed: () async {

                                if(_formKey.currentState.validate()){
                                  Utility.showProgressAlertDialog(context, "Please wait");
                                  AuthController authController = AuthController();
                                  UserController userController = UserController();
                                  try{
                                    String uid = await authController.signIn(_email, _password);
                                    // TODO: get user from fireStore
                                    usr.User user = await userController.getUser(uid);
                                    var appCacheBox = Hive.lazyBox(kAppCacheDBName);
                                    appCacheBox.put("user", user);
                                    Navigator.pushNamedAndRemoveUntil(context, MainPage.pageName, (route) => false);
                                  }catch(e, stc){
                                    print("error: $e");
                                    print(stc);
                                    Navigator.pop(context);
                                    Utility.showSnackBar(context, "Login failed, try again");
                                  }
                                }
                              },
                              child: Container(
                                width: kScreenWidth(context),
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: kAccentColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account ? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SignUpPage.pageName);
                              },
                              child: Text(
                                "Sign-up",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
