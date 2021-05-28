import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_start/services/firebase_auth.dart';

class Utility {
  static showSnackBar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$message"))
    );
  }

  static showProgressAlertDialog(context, message){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (mContext){
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text("$message")
              ],
            ),
          );});
  }

  static Future<File> pickImage(ImageSource imageSource) async{
    ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: imageSource);
    if(pickedImage != null){
      return File(pickedImage.path);
    }
    return null;
  }

  static Future<File> selectImage(context) async{
    // TODO: add permission to IOS
    File image;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ()async{
                      image =  await Utility.pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera, size: 40,),
                        Text("Camera")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: ()async{
                      image = await Utility.pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo, size: 40.0,),
                        Text("Gallery")
                      ],
                    ),
                  ),
                )
              ],
            )));
    print("Image Path: ${image.path}");
    return image;
  }

  static getUserId(){
    return FirebaseAuth.instance.currentUser.uid;
  }

}