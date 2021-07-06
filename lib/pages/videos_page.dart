import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/pages/post_detail_page.dart';
import 'package:social_start/widgets/custom_appbar.dart';
import 'package:social_start/models/user.dart' as lusr;
import 'package:social_start/widgets/post_item.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final PostController _postController = PostController();
  final UserController _userController = UserController();

  Future posts;
  Future<lusr.User> user;

  @override
  void initState() {
    posts =  _postController.getPosts("video", 'views');
    user = _userController.getUser(FirebaseAuth.instance.currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(showBackArrow: false,title: "Videos"),
              FutureBuilder(
                  future: user,
                  builder: (context,AsyncSnapshot<lusr.User> userSnapshot) {
                    if(userSnapshot.hasError){
                      return Text("Something went wrong");
                    }
                    if (userSnapshot.connectionState == ConnectionState.done) {
                      print("User Data ${userSnapshot.data}");
                      lusr.User user = userSnapshot.data;
                      return FutureBuilder<QuerySnapshot>(
                          future: posts,
                          builder: (context, snapshot){
                            if(snapshot.hasError){
                              return Text("Something went wrong");
                            }
                            if (snapshot.hasData && snapshot.data.size == 0) {
                              return Center(child: Text("No posts available"));
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              List<Post> posts = snapshot.data.docs.map((e) {
                                var post = Post.fromJson(e.data());
                                post.id = e.id;
                                return post;
                              }).toList();
                              print(posts);
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: posts.length,
                                  itemBuilder: (context, index)=>PostItem(padding: 8.0, post: posts[index], user:user,onPressed: (){
                                    Navigator.pushNamed(context, PostDetailPage.pageName,arguments: PostDetailPageArgs(
                                        posts[index],
                                        user
                                    ));
                                  },));
                            }
                            return Center(child: CircularProgressIndicator());
                          });
                    }
                    return Center(child: Text("loading"));
                  }
              ),
            ],
          ),
        ),
      )
    );
  }
}