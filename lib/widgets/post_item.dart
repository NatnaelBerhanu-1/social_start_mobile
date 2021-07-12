import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/models/user_like.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/service_locator.dart';
import 'package:social_start/utils/utility.dart';
import 'package:video_player/video_player.dart';

class PostItem extends StatefulWidget {
  final double padding;
  final Post post;
  final User user;
  final Function onPressed;
  PostItem(
      {@required this.padding,
      @required this.post,
      @required this.user,
      @required this.onPressed})
      : assert(padding != null);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostController _postController = PostController();
  UserController _userController = getIt<UserController>();

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    if (widget.post.type == "video") {
      _initializeVideo();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.post.type == "video") {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(widget.padding),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${widget.post.caption}'),
          ),
          GestureDetector(
            onTap: widget.onPressed,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0)),
                width: kScreenWidth(context),
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                child: Center(
                  child: widget.post.type == "picture"
                      ? _buildImage()
                      : _buildVideo(),
                ),
              ),
            ),
          ),
          _buildBottom(),
          Divider(
            height: 5.0,
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
                print(widget.post.userId);
                Navigator.pushNamed(context, ProfilePage.pageName, arguments: widget.post.userId);
              },
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(
                  color: kAccentColor,
                  width: 2.0
                )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: CachedNetworkImage(
                      imageUrl: widget.post.user.profileUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover),
              ),
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
                '${widget.post.user.firstName} ',
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
          widget.user.following.indexOf(widget.post.userId) == -1
              ? Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          child: GestureDetector(
                              onTap: () {
                                _userController
                                    .followUser(
                                        widget.user.uid, widget.post.userId)
                                    .then((value) {
                                  print("Then: here");
                                  setState(() {
                                    widget.user.following
                                        .add(widget.post.userId);
                                  });
                                });
                              },
                              child: Text(
                                'follow +',
                                style: TextStyle(
                                    color: kAccentColor, fontSize: 14.0),
                              )))))
              : Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          child: Text(
                        'following',
                        style: TextStyle(color: Colors.black45, fontSize: 14.0),
                      ))))
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
              SizedBox(
                width: 10,
              ),
              // _buildPostActions(Icons.mode_comment_outlined, "123", (){print("comment pressed");}),
              // SizedBox(width: 10,),
              // _buildPostActions(Icons.visibility, "123", (){print("view pressed");}),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){
                        showModalBottomSheet(
                          enableDrag: true,
                          builder: (BuildContext context){
                            return Wrap(
                              children: [Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: ()async{
                                        try {
                                          await _postController.awardPoint(
                                              widget.post.id);
                                          Utility.showSnackBar(context, "Points awarded +1");
                                          Navigator.pop(context);
                                        }catch(error){
                                          print("HERE");
                                          Utility.showSnackBar(context, error);
                                          Navigator.pop(context);
                                        }
                                      },
                                      title: Text("Award social point"),
                                      leading: Icon(
                                        Icons.bookmark_add
                                      ),
                                      horizontalTitleGap: 1.0,
                                    ),
                                    Divider(),
                                    ListTile(
                                      leading: Icon(
                            Icons.message,
                            ),
                                      title: Text("Message"),
                                      horizontalTitleGap: 1.0,
                                      onTap: () async{
                                        print("${Utility.getUserId()} ${widget.post.userId}");
                                        if(Utility.getUserId() == widget.post.userId){
                                          return;
                                        }
                                        var chatId = await _userController.getChatId(Utility.getUserId(), widget.post.userId);
                                        if(chatId == null){
                                          chatId = "";
                                        }
                                        Chat chat = Chat(
                                          id: chatId,
                                          user1Id: Utility.getUserId(),
                                          user2Id: widget.post.user.uid,
                                          user1name: widget.user.firstName,
                                          user2name: widget.post.user.firstName,
                                        );
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context, ChatPage.pageName, arguments: chat);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]
                            );
                          }, context: context
                        );
                      },
                      icon: Icon(
                        Icons.bookmark,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      '${widget.post.points}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kPrimaryColor),
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(height: 10,),
          Text(
            '${widget.post.views} views',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPostActions(IconData icon, String label, Function onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: kPrimaryColor,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            '$label',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  _buildLikeButton() {
    var user = widget.user;
    var post = widget.post;
    return GestureDetector(
      onTap: () async{
        if (user.likedPosts.indexOf(widget.post.id) == -1) {
          setState(() {
            user.likedPosts.add(widget.post.id);
            post.likes++;
          });
          await _postController
              .likePost(UserLike(postId: widget.post.id, user: user));
        } else {
          setState(() {
            user.likedPosts.remove(widget.post.id);
            post.likes--;
          });
          await _postController
              .dislikePost(UserLike(postId: widget.post.id, user: user));
        }
      },
      child: Row(
        children: [
          Icon(
            widget.user.likedPosts.indexOf(widget.post.id) == -1
                ? Icons.favorite_outline
                : Icons.favorite,
            size: 25,
            color: widget.user.likedPosts.indexOf(widget.post.id) == -1
                ? kPrimaryColor
                : kAccentColor,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            '${post.likes} likes',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kPrimaryColor),
          ),
        ],
      ),
    );
  }

  _initializeVideo() async {
    print(widget.post.fileUrl);
    _videoPlayerController = VideoPlayerController.network(widget.post.fileUrl);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        showControls: true,
        autoPlay: false,
        placeholder: Container(
          color: Colors.black,
        ));
    setState(() {});
  }

  _buildVideo() {
    return _chewieController != null &&
            _chewieController.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController)
        : CircularProgressIndicator();
  }

  _buildImage() {
    return CachedNetworkImage(
      width: kScreenWidth(context),
      fit: BoxFit.contain,
      imageUrl: widget.post.fileUrl,
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
        strokeWidth: 1.0,
      )),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
