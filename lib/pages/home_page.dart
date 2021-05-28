import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/pages/profile_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/post_item.dart';

class HomePage extends StatelessWidget {
  final PostController _postController = PostController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 10.0, bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore",
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
          FutureBuilder<QuerySnapshot>(
              future: _postController.getPosts(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && snapshot.data.size == 0) {
                  return Text("No posts available");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<Post> posts = snapshot.data.docs.map((e) => Post(id: e.id, fileUrl: e.get("file_url"),caption: e.get("caption"))).toList();
                  print(posts[0].fileUrl);
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                      itemBuilder: (context, index)=>PostItem(padding: 0.0, post: posts[index],));
                }

                return Center(child: Text("loading"));

              }),
          // PostItem(padding: 0.0,),
        ],
      ),
    );
  }
}
