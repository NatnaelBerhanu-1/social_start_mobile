import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/services/firebase_services.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:validators/validators.dart';

class ForgotPassword extends StatefulWidget{
  static final pageName = "forgotPassword";

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPassword> {
  String email;
  String verCode;

  GlobalKey<FormState> _emailFormKey = GlobalKey();
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Get password reset mail"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _emailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    onChanged: (value){
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return "Field required";
                      }
                      if(!isEmail(value)){
                        return "Invalid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: _enabledBorderStyle(),
                      focusedBorder: _focusedBorderStyle(),
                      hintText: "Enter email"
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  child: Container(
                      color: kPrimaryColor,
                      height: 50,
                      width: kScreenWidth(context),
                      child: Center(child: Text("Get link", style: TextStyle(color: Colors.white),))),
                  onTap: () async {
                    if(_emailFormKey.currentState.validate()){
                      await Utility.showProgressAlertDialog(context, "Please wait..");
                      if(await firebaseServices.checkUser(email)){
                        FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                            .then((value){
                          Utility.showSnackBar(context, "password reset email has been sent");
                          Navigator.pop(context);
                        })
                            .onError((error, stackTrace){
                          print(error);
                          Utility.showSnackBar(context, "Error sending password reset email, try again");
                          Navigator.pop(context);
                        });
                      }else{
                        Utility.showSnackBar(context, "No user found with the provided email");
                        Navigator.pop(context);
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  OutlineInputBorder _enabledBorderStyle(){
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: kBorderColor,
            width: 1
        )
    );
  }

  OutlineInputBorder _focusedBorderStyle(){
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: kAccentColor,
            width: 1
        )
    );
  }
}