import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart' as lusr;
import 'package:social_start/pages/post_detail_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/services/firebase_auth.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/post_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController _postController = PostController();
  final UserController _userController = UserController();

  Future posts;

  @override
  void initState() {
    posts =  _postController.getPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 16.0, bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Socialstart",
                  style: Theme.of(context).textTheme.headline1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.pageName);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/sample_profile_pic.jpg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _postTypeStyle("Following", true),
                SizedBox(width: 16,),
              _postTypeStyle("Popular", false),
                SizedBox(width: 16,),
              _postTypeStyle("Nearby", false),
              ],
            ),
          ),
          FutureBuilder(
            future: _userController.getUser(FirebaseAuth.instance.currentUser.uid),
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
                        return Text("No posts available");
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
          // PostItem(padding: 0.0,),
        ],
      ),
    );
  }

  Widget _postTypeStyle(title, active) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.w400,
              color: kPrimaryColor
          ),
        ),
        active ?Container(
          margin: EdgeInsets.only(top: 6),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(4)
          ),
        ): SizedBox(
          height: 8,
        )
      ],
    );
  }
}
