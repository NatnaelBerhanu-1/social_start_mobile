import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/edit_profile_page.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/settings_page.dart';
import 'package:social_start/pages/view_content_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/service_locator.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';
import 'package:social_start/widgets/custom_appbar.dart';
import 'package:social_start/widgets/post_item.dart';
import 'package:video_player/video_player.dart';

import 'post_detail_page.dart';

class ProfilePage extends StatefulWidget {
  static final String pageName = "profile";
  final String userId;
  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController _userController = getIt<UserController>();
  PostController _postController = PostController();
  Future<User> user;

  Future posts;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    user = _userController.getUser(widget.userId);
    posts = _postController.getUserPosts(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      body: SafeArea(
        child: FutureBuilder(
            future: user,
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomAppBar(
                      //   title:
                      //       "${snapshot.data.firstName} ${snapshot.data.lastName}",
                      //   actionIcon: Utility.getUserId() == widget.userId
                      //       ? Icons.person
                      //       : null,
                      //   actionPressed: Utility.getUserId() == widget.userId
                      //       ? () {
                      //           Navigator.pushNamed(
                      //               context, SettingsPage.pageName);
                      //         }
                      //       : null,showBackArrow: false,
                      // ),
                      Container(
                        color: Theme.of(context).backgroundColor,
                        width: kScreenWidth(context),
                        child: Column(
                          children: [
                            snapshot.data.bannerUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: snapshot.data.bannerUrl,
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: kScreenWidth(context),
                                  )
                                : Image.asset(
                                    'assets/images/sample_banner.jpg',
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: kScreenWidth(context),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: snapshot.data.profileUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data.profileUrl,
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: kScreenWidth(context),
                                            )
                                          : Image.asset(
                                              'assets/images/sample_profile_pic.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data.firstName} ${snapshot.data.lastName}",
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          snapshot.data.relationShipStatus !=
                                                  null
                                              ? snapshot.data.relationShipStatus
                                              : '----',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .color),
                                        ),
                                        Text(
                                          "${snapshot.data.bio != null ? snapshot.data.bio : '------'}",
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        snapshot.data.uid != Utility.getUserId()
                                            ? Consumer<UserViewModel>(builder:
                                                (context, userViewModel,
                                                    child) {
                                                if (userViewModel.userStatus ==
                                                    UserStatus.success) {
                                                  bool following = userViewModel
                                                          .user.following
                                                          .indexOf(
                                                              widget.userId) !=
                                                      -1;
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      following
                                                          ? TextButton(
                                                              onPressed:
                                                                  () async {
                                                                // do something
                                                                var chatId = await _userController
                                                                    .getChatId(
                                                                        Utility
                                                                            .getUserId(),
                                                                        widget
                                                                            .userId);
                                                                if (chatId ==
                                                                    null) {
                                                                  chatId = "";
                                                                }
                                                                Chat chat = Chat(
                                                                    id: chatId,
                                                                    user1Id: Utility
                                                                        .getUserId(),
                                                                    user2Id: widget
                                                                        .userId,
                                                                    user1name:
                                                                        userViewModel
                                                                            .user
                                                                            .firstName,
                                                                    user2name:
                                                                        snapshot
                                                                            .data
                                                                            .firstName,
                                                                    user1ProfilePic:
                                                                        userViewModel
                                                                            .user
                                                                            .profileUrl,
                                                                    user2ProfilePic:
                                                                        snapshot
                                                                            .data
                                                                            .profileUrl);
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    ChatPage
                                                                        .pageName,
                                                                    arguments:
                                                                        chat);
                                                              },
                                                              child: Container(
                                                                child: Text(
                                                                  "message",
                                                                  style: TextStyle(
                                                                      color:
                                                                          kAccentColor),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          print(userViewModel
                                                              .user.following);
                                                          if (following) {
                                                            _userController
                                                                .unFollowUser(
                                                                    userViewModel
                                                                        .user
                                                                        .uid,
                                                                    widget
                                                                        .userId)
                                                                .then((value) {
                                                              setState(() {
                                                                following =
                                                                    false;
                                                                userViewModel
                                                                    .user
                                                                    .following
                                                                    .remove(widget
                                                                        .userId);
                                                              });
                                                            });
                                                          } else {
                                                            // Utility.showSnackBar(_scaffoldKey.currentContext, "Following");
                                                            print(userViewModel
                                                                .user
                                                                .toJson());
                                                            _userController
                                                                .followUser(
                                                                    userViewModel
                                                                        .user
                                                                        .uid,
                                                                    widget
                                                                        .userId)
                                                                .then((value) {
                                                              setState(() {
                                                                following =
                                                                    true;
                                                                userViewModel
                                                                    .user
                                                                    .following
                                                                    .add(widget
                                                                        .userId);
                                                              });
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical:
                                                                      4.0),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: following
                                                                      ? Theme.of(
                                                                              context)
                                                                          .backgroundColor
                                                                      : kAccentColor,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4.0)),
                                                                  border: following
                                                                      ? Border.all(
                                                                          color:
                                                                              kBorderColor,
                                                                          width:
                                                                              1,
                                                                        )
                                                                      : null),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              !following
                                                                  ? Icon(
                                                                      Icons
                                                                          .person_add_alt_1_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : SizedBox(),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                following
                                                                    ? "UnFollow"
                                                                    : "Follow",
                                                                style: TextStyle(
                                                                    color: following
                                                                        ? Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText2
                                                                            .color
                                                                        : Colors
                                                                            .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return SizedBox();
                                              })
                                            : SizedBox(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      FutureBuilder(
                          future: user,
                          builder: (context, AsyncSnapshot<User> userSnapshot) {
                            if (userSnapshot.hasError) {
                              return Text("Something went wrong");
                            }
                            if (userSnapshot.connectionState ==
                                ConnectionState.done) {
                              print("User Data ${userSnapshot.data}");
                              User user = userSnapshot.data;
                              return FutureBuilder<QuerySnapshot>(
                                  future: posts,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data.size == 0) {
                                      return Center(
                                          child: Text("No posts available"));
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      List<Post> posts =
                                          snapshot.data.docs.map((e) {
                                        var post = Post.fromJson(e.data());
                                        post.id = e.id;
                                        return post;
                                      }).toList();
                                      print(posts);
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      mainAxisSpacing: 10.0,
                                                      crossAxisSpacing: 10.0),
                                              itemBuilder: (context, index) =>_buildPostWiget(posts[index]),                                                      
                                              itemCount: posts.length,
                                              shrinkWrap: true,
                                            ),
                                          ),
                                          // ListView.builder(
                                          //     shrinkWrap: true,
                                          //     physics:
                                          //         NeverScrollableScrollPhysics(),
                                          //     itemCount: posts.length,
                                          //     itemBuilder: (context, index) =>
                                          //         PostItem(
                                          //           padding: 8.0,
                                          //           post: posts[index],
                                          //           user: user,
                                          //           onPressed: () {
                                          //             Navigator.pushNamed(
                                          //                 context,
                                          //                 PostDetailPage
                                          //                     .pageName,
                                          //                 arguments:
                                          //                     PostDetailPageArgs(
                                          //                         posts[index],
                                          //                         user));
                                          //           },
                                          //         )),
                                        ],
                                      );
                                    }

                                    return Center(
                                        child: SpinKitFadingCircle(
                                      color: kPrimaryColor,
                                      size: 30,
                                    ));
                                  });
                            }

                            return Center(child: Text("loading"));
                          }),
                    ],
                  ),
                );
              }
              return Center(
                  child: SpinKitFadingCircle(
                color: kPrimaryColor,
                size: 30,
              ));
            }),
      ),
    );
  }

  _buildPostWiget(Post post) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ViewContentPage.pageName,arguments: post),
      child: post.type == "picture"
        ? Container(
            color: Colors.black,
            child: Image.network(post.fileUrl),
          )
        : Container(
            color: Colors.black,
            child: Stack(
              children: [
                VideoPlayer(
                    VideoPlayerController.network(post.fileUrl)..initialize()),
                Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_fill)),
              ],
            ),
          ),
    );
  }
}
