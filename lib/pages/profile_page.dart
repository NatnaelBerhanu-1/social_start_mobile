import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/auth_controller.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/pages/EditProfilePage.dart';
import 'package:social_start/pages/message_page.dart';
import 'package:social_start/pages/settings_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/widgets/custom_appbar.dart';
import 'package:social_start/widgets/post_item.dart';

import 'post_detail_page.dart';

class ProfilePage extends StatefulWidget {
  static final String pageName = "profile";
  final String userId;
  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController _userController = UserController();
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
      backgroundColor: kBackgroundColor,
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
                      CustomAppBar(
                        title:
                            "${snapshot.data.firstName} ${snapshot.data.lastName}",
                        actionIcon: Utility.getUserId() == widget.userId ? Icons.person : null,
                        actionPressed: Utility.getUserId()  == widget.userId ? () {
                          Navigator.pushNamed(context, SettingsPage.pageName);
                        } : null,
                      ),
                      Container(
                        color: Colors.white,
                        width: kScreenWidth(context),
                        height: 180,
                        child: Stack(
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                      color: kAccentColor,
                                      width: 2,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: snapshot.data.profileUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: snapshot.data.profileUrl,
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
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: kScreenWidth(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${snapshot.data.firstName} ${snapshot.data.lastName}",
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Single",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${snapshot.data.totalFollowers}",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${snapshot.data.totalFollowing}",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            snapshot.data.uid != Utility.getUserId()
                                ? FutureBuilder(
                                    future: _userController.getUser(),
                                    builder: (context,
                                        AsyncSnapshot<User> userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        print(Utility.getUserId());
                                        print(userSnapshot.data.following);
                                        bool following = userSnapshot.data.following
                                                .indexOf(widget.userId) !=
                                            -1;
                                        print("Following $following");
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            following ? TextButton(
                                              onPressed: () async {
                                                // do something
                                                var chatId = await _userController.getChatId(Utility.getUserId(), widget.userId);
                                                if(chatId == null){
                                                  chatId = "";
                                                }
                                                Chat chat = Chat(
                                                  id: chatId,
                                                  user1Id: Utility.getUserId(),
                                                  user2Id: widget.userId,
                                                  user1name: userSnapshot.data.firstName,
                                                  user2name: snapshot.data.firstName,
                                                );
                                                Navigator.pushNamed(context, ChatPage.pageName, arguments: chat);
                                              },
                                              child: Container(
                                                child: Text(
                                                  "message"
                                                ),
                                              ),
                                            ): SizedBox(),
                                            GestureDetector(
                                              onTap: () {
                                                if (following) {
                                                  _userController.unFollowUser(
                                                      userSnapshot.data.uid,
                                                      widget.userId).then((value){
                                                        setState(() {
                                                          following = false;
                                                        });
                                                  });
                                                } else {
                                                  // Utility.showSnackBar(_scaffoldKey.currentContext, "Following");
                                                  _userController.followUser(
                                                      userSnapshot.data.uid,
                                                      widget.userId).then((value){
                                                    setState(() {
                                                      following = true;
                                                    });
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  color: following ? Colors.white : kAccentColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  border: following ? Border.all(
                                                    color: kBorderColor,
                                                    width: 1,
                                                  ):null
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    !following
                                                        ? Icon(
                                                            Icons
                                                                .person_add_alt_1_rounded,
                                                            color: Colors.white,
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
                                                              ? Colors.black26
                                                              : Colors.white),
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
                            SizedBox(
                              height: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${snapshot.data.bio != null ? snapshot.data.bio : '------'}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            )
                          ],
                        ),
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
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: posts.length,
                                          itemBuilder: (context, index) =>
                                              PostItem(
                                                padding: 8.0,
                                                post: posts[index],
                                                user: user,
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      PostDetailPage.pageName,
                                                      arguments:
                                                          PostDetailPageArgs(
                                                              posts[index],
                                                              user));
                                                },
                                              ));
                                    }

                                    return Center(
                                        child: CircularProgressIndicator());
                                  });
                            }

                            return Center(child: Text("loading"));
                          }),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
