import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/comment.dart';
import 'package:social_start/utils/constants.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  CommentWidget({@required this.comment});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: kPrimaryLightColor,
                ),
              borderRadius: BorderRadius.circular(50),

            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: comment.userProfilePic != null ? CachedNetworkImage(
                  imageUrl: comment.userProfilePic, width: 40, height: 40, fit: BoxFit.cover,)
                : Container(
                  width: 40,
                  height: 40,
                  color: kBorderColor,
                ),

            ),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${comment.userName}', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text('${_parsedDateTime().day}-${_parsedDateTime().month}-${_parsedDateTime().year} at ${_parsedDateTime().hour}:${_parsedDateTime().minute}', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0,)),
                SizedBox(height: 10,),
                Text('${comment.content}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0), )
              ],
            ),
          )
        ],
      ),
    );
  }

  DateTime _parsedDateTime(){
   return DateTime.parse(comment.createdAt);
  }
}