import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:social_start/utils/service_locator.dart';
import 'package:social_start/viewmodels/post_viewmodel.dart';
import 'package:social_start/viewmodels/user_viewmodel.dart';
import 'package:social_start/widgets/post_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController _postController = PostController();
  final UserController _userController = getIt<UserController>();

  List<Post> allPosts;
  List<Post> filteredPosts;
  Future posts;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    // posts =  _postController.getPosts("picture");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var postViewModel = Provider.of<PostViewModel>(context, listen: false);
      if(postViewModel.postState == PostState.Init){
        Provider.of<PostViewModel>(context, listen: false).filterPost("popular", null);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
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
                    color: Theme.of(context).primaryColor,
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
        Expanded(
          flex: 1,
          child: Consumer<UserViewModel>(
            builder: (context,userViewModel, child) {
              if(userViewModel.userStatus == UserStatus.failed){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Something went wrong",style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),
                    TextButton(onPressed: (){}, child: Text('try again',style: TextStyle(color: kAccentColor),))
                  ],
                );
              }
              if (userViewModel.userStatus == UserStatus.success) {
                lusr.User user = userViewModel.user;
                return Consumer<PostViewModel>(
                    builder: (context, postViewModel ,child){
                      // if(postViewModel.postState == PostState.Error){
                      //   return Center(child: Text("Something went wrong"));
                      // }
                      // if(postViewModel.postState == PostState.Fetched) {
                      //   var posts = postViewModel.posts;
                        return SingleChildScrollView(
                          child: Column(
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
                              postViewModel.postState == PostState.Fetched ? postViewModel.posts.isEmpty ?
                              Center(child: Text("No posts available", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color)),) :
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: postViewModel.posts.length,
                                  itemBuilder: (context, index) =>
                                      PostItem(padding: 8.0,
                                        post: postViewModel.posts[index],
                                        user: user,
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, PostDetailPage.pageName,
                                              arguments: PostDetailPageArgs(
                                                  postViewModel.posts[index],
                                                  user
                                              ));
                                        },)):postViewModel.postState == PostState.Error ?
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Something went wrong",style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),),
                                  TextButton(onPressed: (){}, child: Text('try again',style: TextStyle(color: kAccentColor),))
                                ],
                              ):Center(child: SpinKitFadingCircle(size: 30, color: Theme.of(context).primaryColor,),),
                            ],
                          ),
                        );
                      // }
                      // return Center(child: CircularProgressIndicator());

                    });
              }
              return Center(child: Text("loading"));
            }
          ),
        ),
        // PostItem(padding: 0.0,),
      ],
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
                color: Theme.of(context).primaryColor
            ),
          ),
          active ?Container(
            margin: EdgeInsets.only(top: 6),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
