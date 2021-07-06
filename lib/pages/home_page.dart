import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart' as lusr;
import 'package:social_start/pages/post_detail_page.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/pages/settings_page.dart';
import 'package:social_start/services/firebase_auth.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/viewmodels/post_viewmodel.dart';
import 'package:social_start/widgets/post_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController _postController = PostController();
  final UserController _userController = UserController();

  List<Post> allPosts;
  List<Post> filteredPosts;
  Future posts;
  Future<lusr.User> user;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    // posts =  _postController.getPosts("picture");
    user = _userController.getUser(FirebaseAuth.instance.currentUser.uid);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PostViewModel>(context, listen: false).filterPost("popular", null);
    });
  }


  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushNamed(context, SettingsPage.pageName);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child:  Icon(
                      Icons.settings_outlined,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          FutureBuilder(
            future: user,
            builder: (context,AsyncSnapshot<lusr.User> userSnapshot) {
              if(userSnapshot.hasError){
                return Text("Something went wrong");
              }
              if (userSnapshot.connectionState == ConnectionState.done) {
                print("User Data ${userSnapshot.data}");
                lusr.User user = userSnapshot.data;
                return Consumer<PostViewModel>(
                    builder: (context, postViewModel ,child){
                      if(postViewModel.postState == PostState.Error){
                        return Center(child: Text("Something went wrong"));
                      }
                      if(postViewModel.postState == PostState.Fetched) {
                        var posts = postViewModel.posts;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _postTypeStyle("Popular", _activeTab == 0,
                                          () => tabItemPressed("popular", user, 0)),
                                  SizedBox(width: 16,),
                                  _postTypeStyle("Following", _activeTab == 1,
                                          () => tabItemPressed("following", user, 1)),
                                  SizedBox(width: 16,),
                                  _postTypeStyle("Nearby", _activeTab == 2,
                                          () =>  tabItemPressed("nearby", user, 2)),
                                ],
                              ),
                            ),
                            posts.isEmpty ?
                            Center(child: Text("No posts available"),) :
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) =>
                                    PostItem(padding: 8.0,
                                      post: posts[index],
                                      user: user,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, PostDetailPage.pageName,
                                            arguments: PostDetailPageArgs(
                                                posts[index],
                                                user
                                            ));
                                      },)),
                          ],
                        );
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

  Widget _postTypeStyle(title, active, onPressed) {
    return GestureDetector(
      onTap: ()=>onPressed(),
      child: Column(
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
      ),
    );
  }

  tabItemPressed(String s, user, index) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _activeTab = index;
      });
    });
    Provider.of<PostViewModel>(context,listen: false).filterPost(s, user);
  }

}
