import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/checkout.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/models/user_like.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/paypal_payment_page.dart';
import 'package:social_start/pages/post_detail_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/pages/view_content_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/helper.dart';
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
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding),
            child: _buildTop(),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: widget.padding),
            child: Text('${widget.post.caption}'),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            width: kScreenWidth(context),
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ViewContentPage.pageName,
                    arguments: widget.post);
              },
              child: Center(
                child: widget.post.type == "picture"
                    ? _buildImage()
                    : _buildVideo(),
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
            onTap: () {
              print(widget.post.userId);
              Navigator.pushNamed(context, ProfilePage.pageName,
                  arguments: widget.post.userId);
            },
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(color: kAccentColor, width: 2.0)),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(
                  '${widget.post.user.firstName} ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                widget.user.following.indexOf(widget.post.userId) == -1
                    ? Align(
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
                                ))))
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            child: Text(
                          'following',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14.0),
                        )))
              ]),
              Text(
                '${widget.user.totalFollowers} followers, ${widget.user.likes} likes',
                style: TextStyle(
                    fontSize: 12.0, color: Theme.of(context).primaryColorLight),
              )
            ],
          ),
          // widget.user.following.indexOf(widget.post.userId) == -1
          //     ? Expanded(
          //         child: Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //                 child: GestureDetector(
          //                     onTap: () {
          //                       _userController
          //                           .followUser(
          //                               widget.user.uid, widget.post.userId)
          //                           .then((value) {
          //                         print("Then: here");
          //                         setState(() {
          //                           widget.user.following
          //                               .add(widget.post.userId);
          //                         });
          //                       });
          //                     },
          //                     child: Text(
          //                       'follow +',
          //                       style: TextStyle(
          //                           color: kAccentColor, fontSize: 14.0),
          //                     )))))
          //     : Expanded(
          //         child: Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //                 child: Text(
          //               'following',
          //               style: TextStyle(
          //                   color: Theme.of(context).primaryColor,
          //                   fontSize: 14.0),
          //             ))))
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLikeButton(),
              // _buildPostActions(Icons.mode_comment_outlined, "123", (){print("comment pressed");}),
              // SizedBox(width: 10,),
              // _buildPostActions(Icons.visibility, "123", (){print("view pressed");}),
              GestureDetector(
                child: Icon(Icons.comment),
                onTap: widget.onPressed,
              ),
              GestureDetector(
                child: Icon(Icons.ios_share),
                onTap: widget.onPressed,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Theme.of(context).backgroundColor,
                      enableDrag: true,
                      builder: (BuildContext context) {
                        return Wrap(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    try {
                                      await _postController
                                          .awardPoint(widget.post.id);
                                      Utility.showSnackBar(
                                          context, "Points awarded +1");
                                      Navigator.pop(context);
                                    } catch (error) {
                                      print("HERE");
                                      Utility.showSnackBar(context, error);
                                      Navigator.pop(context);
                                    }
                                  },
                                  title: Text("Award social point",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .color)),
                                  leading: Icon(
                                    Icons.bookmark_add,
                                    color:
                                        Theme.of(context).accentIconTheme.color,
                                  ),
                                  horizontalTitleGap: 1.0,
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(
                                    Icons.message,
                                    color:
                                        Theme.of(context).accentIconTheme.color,
                                  ),
                                  title: Text(
                                    "Message",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color),
                                  ),
                                  horizontalTitleGap: 1.0,
                                  onTap: () async {
                                    print(
                                        "${Utility.getUserId()} ${widget.post.userId}");
                                    if (Utility.getUserId() ==
                                        widget.post.userId) {
                                      return;
                                    }
                                    var chatId =
                                        await _userController.getChatId(
                                            Utility.getUserId(),
                                            widget.post.userId);
                                    if (chatId == null) {
                                      chatId = "";
                                    }
                                    Chat chat = Chat(
                                      id: chatId,
                                      user1Id: Utility.getUserId(),
                                      user2Id: widget.post.userId,
                                      user2ProfilePic:
                                          widget.post.user.profileUrl,
                                      user1ProfilePic: widget.user.profileUrl,
                                      user1name: widget.user.firstName,
                                      user2name: widget.post.user.firstName,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, ChatPage.pageName,
                                        arguments: chat);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      },
                      context: context);
                },
                icon: Icon(
                  Icons.bookmark,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              _buildTipButton(context)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${widget.post.views} views',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor),
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
      onTap: () async {
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
                ? Theme.of(context).primaryColor
                : kAccentColor,
          ),
          // SizedBox(
          //   width: 3,
          // ),
          // Text(
          //   '${post.likes} likes',
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 14,
          //       color: Theme.of(context).primaryColor),
          // ),
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

  _buildTipButton(BuildContext context) {
    return IconButton(
        onPressed: () => _showTipDialog(context),
        icon: Icon(Icons.attach_money));
  }

  _showTipDialog(BuildContext mContext) {
    var _amountController = TextEditingController();
    var _messageController = TextEditingController();
    var _formKey = GlobalKey<FormState>();
    showDialog(
      context: mContext,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Tip"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _amountController,
                        validator: (value) {
                          if (value.isEmpty || double.parse(value) < 1.0) {
                            return "Invalid input";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        decoration: InputDecoration(
                            focusedBorder: _outlineBorderFocused(),
                            errorBorder: _outlineBorderError(),
                            prefixIcon: Icon(
                              Icons.attach_money,
                              size: 18,
                            ),
                            hintText: "0.00",
                            enabledBorder: _outlineBorder()),
                      )),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                          enabledBorder: _outlineBorder(),
                          focusedBorder: _outlineBorderFocused(),
                          errorBorder: _outlineBorderError(),
                          hintText: "Message")),
                ],
              ),
            ),
            actions: [
              TextButton(
                  child: Text("Send"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _processPayment(double.parse(_amountController.text),
                          _messageController.text);
                    }
                  })
            ]);
      },
    );
  }

  _outlineBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: kBorderColor));
  }

  _outlineBorderFocused() {
    return OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: kPrimaryColor));
  }

  _outlineBorderError() {
    return OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: Colors.red));
  }

  void _processPayment(double amount, String message) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaypalPayment(
            checkoutModel: CheckoutModel(checkoutItems: [
              CheckoutItem(itemName: "Tip", itemPrice: amount, quantity: 1)
            ], totalAmount: amount),
            onFinish: (id) => _paymnetFinished(id, amount, message))));
  }

  _paymnetFinished(String id, [tipAmount, message]) async {
    print("Success with$id");
    User receiver = widget.post.user;
    receiver.uid = widget.post.userId;
    User tipper = widget.user;
    tipper.uid = Utility.getUserId();
    var transactionState =
        await _userController.tipUser(tipper, receiver, tipAmount, id, message);
    Utility.showSnackBar(context, "Tipped successfully");
    Navigator.pop(context);
  }
}
