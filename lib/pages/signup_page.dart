import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart' as usr;
import 'package:social_start/pages/login_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/widgets/circular_logo.dart';
import 'package:validators/validators.dart';
import 'main_page.dart';

class SignUpPage extends StatefulWidget {
  static final String pageName = "signUp";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _showPassword = false;
  var _showCPassword = false;

  usr.User _newUser = usr.User();
  String _cPassword = "";

  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
    ));
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                child: CircularLogoWidget()

              ),
            ),
            Positioned(
              top: 130,
              child: Container(
                height: kScreenHeight(context)-165,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                padding: EdgeInsets.only(left:20.0, right:20, top:20, bottom:
                MediaQuery.of(context).viewInsets.bottom),
                width: kScreenWidth(context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign-up',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Form(
                        key: _signUpFormKey,
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  _newUser.email = value;
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
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  _newUser.firstName = value;
                                });
                              },
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'This field is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'First name',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  _newUser.lastName = value;
                                });
                              },
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'This field is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Last name',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              obscureText: !_showPassword,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'This field is required';
                                }
                                if(value.length < 8){
                                  return 'Minimum length must be 8';
                                }
                                if(matches(value, RegExp('''^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}\$''').pattern)){
                                  return 'Password must have at least one uppercase letter, one lowercase letter, one digit and one special character.';
                                }
                                return null;
                              },
                              onChanged: (value){
                                setState(() {
                                  _newUser.password = value;
                                });
                              },
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              obscureText: !_showCPassword,
                              onChanged: (value){
                                setState(() {
                                  _cPassword = value;
                                });
                              },
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'This field is required';
                                }if(value != _newUser.password){
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Confirm password',
                                  labelStyle: TextStyle(fontSize: 16),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showCPassword = !_showCPassword;
                                      });
                                    },
                                    icon: Icon(_showCPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextButton(
                                onPressed: () async{
                                  if(_signUpFormKey.currentState.validate()){
                                    // TODO: create the user account
                                    try{
                                      Utility.showProgressAlertDialog(context, "Please wait");
                                      AuthController authController = AuthController();
                                      UserController userController = UserController();
                                      String uid = await authController.signUp(_newUser.email, _newUser.password);
                                      _newUser.uid = uid;
                                      await userController.createUser(user:_newUser);
                                      print("uid: $uid");
                                      Navigator.of(context).pushNamedAndRemoveUntil(MainPage.pageName, (Route<dynamic> route) => false);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        print('The password provided is too weak.');
                                        Utility.showSnackBar(_scaffoldKey.currentContext, "Weak Password");
                                      } else if (e.code == 'email-already-in-use') {
                                        print('The account already exists for that email.');
                                        Utility.showSnackBar(_scaffoldKey.currentContext, "Email in use");
                                      }
                                    } catch (e) {
                                      print(e);
                                      Utility.showSnackBar(_scaffoldKey.currentContext, "Failed creating account");
                                    }
                                  }
                                  // Navigator.pushNamedAndRemoveUntil(context, MainPage.pageName, (Route<dynamic> route)=>false);
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
                                      'Signup',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account ? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, LoginPage.pageName);
                                  },
                                  child: Text(
                                    "Log-in",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
