import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Helper{
  static showVideoOrPictureDialog(context, {onVideoSelected, onImageSelected}){showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        onImageSelected();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, size: 40,),
                          Text("Image")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        onVideoSelected();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, size: 40.0,),
                          Text("Video")
                        ],
                      ),
                    ),
                  )
                ],
        )));
  }
}