import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/models/comment.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/widgets/add_comment.dart';
import 'package:social_start/widgets/comment.dart';
import 'package:social_start/widgets/post_item.dart';

class PostDetailPageArgs {
  Post post;
  User user;
  PostDetailPageArgs(this.post, this.user);
}

class PostDetailPage extends StatefulWidget {
  static final pageName = "postDetail";
  final Post post;
  final User user;
  PostDetailPage({@required this.post,@required this.user});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostController _postController = PostController();

  Stream<QuerySnapshot> _commentsRef;

  @override
  void initState() {
    _commentsRef = FirebaseFirestore.instance.collection("comments").where("post_id", isEqualTo: widget.post.id).snapshots();
    _postController.countPostView(widget.post.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.post);
    print(widget.user);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor
        ),
        title: Text("${widget.post.user.firstName} ${widget.post.user.lastName}", style: TextStyle(color: Theme.of(context).primaryColor),),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                PostItem(padding: 10.0, post: widget.post, user: widget.user, onPressed: (){},),
                StreamBuilder(
                  stream: _commentsRef,
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.hasError){
                        return Text("Something went wrong");
                        }
                        if(snapshot.hasData && snapshot.data.size == 0){
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("No comments"),
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.active) {
                          List<Comment> comments = snapshot
                          .data
                          .docs
                          .map((e){
                            var comment = Comment.fromJson(e.data());
                            comment.id = e.id;
                            return comment;
                          }).toList();
                          print("Comments $comments");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Comments (${comments.length})', style: TextStyle(fontWeight: FontWeight.w500),),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (context, index){
                                  return CommentWidget(comment: comments[index]);
                                },
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: SingleChildScrollView(),
                        );
                  }
                ),
                SizedBox(height: 70,)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AddComment(postId: widget.post.id, userId: widget.user.uid),
          )
        ],
      ),
    );
  }
}