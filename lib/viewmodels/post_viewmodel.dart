import 'package:flutter/foundation.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart';

enum PostState {
  Init,
  Fetching,
  Fetched,
  Error
}

class PostViewModel extends ChangeNotifier {
  PostController _postController = PostController();
  List<Post> posts;
  PostState postState = PostState.Init;

  filterPost(filterBy, User user){
    postState = PostState.Fetching;
    notifyListeners();
    var orderBy = 'views';
    if(filterBy == 'nearby'){
      orderBy = 'points';
    }
    _postController.getPosts('picture', orderBy).then((value) {
      posts = value.docs.map((e) {
        var post = Post.fromJson(e.data());
        post.id = e.id;
        return post;
      }).toList();
      print("Filtering by ${filterBy}");
      switch(filterBy){
        case "following":
        filterFollowing(posts, user);
        break;
        case "popular":
        filterPopular(posts, user);
        break;
        case "nearby":
        filterNearby(posts, user);
        break;
      }
      postState = PostState.Fetched;
      notifyListeners();
    }).onError((error, stackTrace){
      print(error);
      print(stackTrace);
      postState = PostState.Error;
      notifyListeners();
    });
  }

  void filterFollowing(List<Post> posts,User user) {
      List<Post> filteredPosts = [];
      posts.forEach((element) {
        if(user.following.indexOf(element.userId) != -1){
          print("hereHere");
          filteredPosts.add(element);
        }
      });
      this.posts = filteredPosts;
  }

  void filterPopular(List<Post> posts, user) {

  }

  void filterNearby(List<Post> posts, user) {

  }
}