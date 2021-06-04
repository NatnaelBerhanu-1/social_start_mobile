import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/models/user_like.dart';
import 'package:social_start/utils/constants.dart';

class PostItem extends StatefulWidget {
  final double padding;
  final Post post;
  final User user;
  final Function onPressed;
  PostItem({@required this.padding, @required this.post, @required this.user,@required this.onPressed}):assert(padding!=null);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostController _postController = PostController();
  UserController _userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(widget.padding),
      margin: EdgeInsets.symmetric(vertical:8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0),
            child: Text('${widget.post.caption}'),
          ),
          GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              color: Colors.black,
              width: kScreenWidth(context),
              constraints: BoxConstraints(
                maxHeight: 400
              ),
              child: Center(
                child: CachedNetworkImage(
                  width: kScreenWidth(context),
                  fit: BoxFit.contain,
                imageUrl: widget.post.fileUrl,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                  )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
              ),
            ),
          ),
          _buildBottom(),
          Divider(height: 5.0,color: Colors.black12,)
        ],
      ),
    );
  }

  Widget _buildTop(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/sample_profile_pic.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                '${widget.user.totalFollowers} followers',
                style: TextStyle(fontSize: 12.0, color: kPrimaryLightColor),
              )
            ],
          ),

          widget.user.following.indexOf(widget.post.userId) == -1 ? Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(child: GestureDetector(
                      onTap: (){
                        _userController.followUser(widget.user.uid,widget.post.userId)
                        .then((value){
                          setState((){
                            widget.user.following.add(widget.post.userId);
                          });
                        });

                      },
                      child: Text('follow +', style: TextStyle(color: kAccentColor),))))):
              SizedBox()
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLikeButton(),
            SizedBox(width: 10,),
            // _buildPostActions(Icons.mode_comment_outlined, "123", (){print("comment pressed");}),
              // SizedBox(width: 10,),
              // _buildPostActions(Icons.visibility, "123", (){print("view pressed");}),
              Expanded(child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '123 views',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor),
                ),
              ))
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildPostActions(IconData icon, String label, Function onPressed) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: kPrimaryColor,
          ),
          SizedBox(width: 3,),
          Text(
            '$label',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  _buildLikeButton() {
    var user = widget.user;
    return GestureDetector(
      onTap: (){
        if(user.likedPosts.indexOf(widget.post.id) == -1) {
          setState(() {
            user.likedPosts.add(widget.post.id);
          });
          _postController.likePost(UserLike(postId: widget.post.id, user: user));

        }else{
          setState(() {
            user.likedPosts.remove(widget.post.id);
          });
          _postController.dislikePost(UserLike(postId: widget.post.id, user: user));
        }
      },
      child: Row(
        children: [
          Icon(
            widget.user.likedPosts.indexOf(widget.post.id) == -1 ? Icons.favorite_outline :Icons.favorite,
            size: 25,
            color: widget.user.likedPosts.indexOf(widget.post.id) == -1 ? kPrimaryColor : kAccentColor,
          ),
          SizedBox(width: 3,),
          Text(
            'likes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
