import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/comment.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class AddComment extends StatefulWidget {
  final String postId;
  final String userId;

  AddComment({this.postId, this.userId});

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  PostController _postController = PostController();
  String comment= "";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext buildContext) {
    // TODO: implement build
    return Container(
      height: 70,
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value){
                  setState(() {
                    comment = value;
                  });
                },
                autofocus: true,
                decoration: InputDecoration(
                  border: _inputBorder(),
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  filled: true,
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(kPrimaryColor),
                  hintText: "Add comment...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              )
          ),
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  var user = context.read<UserViewModel>().user;
                  if(comment.isNotEmpty){
                    _postController.addComment(Comment(
                      postId: widget.postId,
                      userName: user.firstName + " " + user.lastName,
                      createdAt: Timestamp.now().toDate().toString(),
                      content: comment,
                      userId: widget.userId,
                      userProfilePic: user.profileUrl
                    )).then((value) {
                      Utility.showSnackBar(context, "comment posted");
                      setState(() {
                        comment = "";
                        _controller.clear();
                      });
                    })
                    .onError((error, stackTrace){
                      Utility.showSnackBar(context, "posting comment failed");
                    });
                  }
                },
                icon: Center(
                  child: Icon(
                    Icons.comment_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _inputBorder([color=kBorderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(
        color: color,
        width: 1.0
      ),
    );
  }
}