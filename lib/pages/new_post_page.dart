import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/models/category.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/services/firebase_services.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class NewPostPage extends StatefulWidget {
  static final String pageName = "newPost";

  // final FirebaseServices firebaseServices;
  // NewPostPage({@required this.firebaseServices});
  PostController postController = PostController();


  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final List<Category> categories = [
    Category(name: "Community and Business", id: "939954ff-8141-4d8c-a527-65aec7885dab"),
    Category(name: "Beauty and fashion", id: "2eb5033e-8b3f-41d4-b63f-d6a3ea810703"),
    Category(name: "Gaming", id: "95e4a650-118a-4463-acd8-84a6edcc71a8"),
    Category(name: "Funny", id: "14e14c47-6839-4211-8b18-1fa55ac8295f"),
  ];

  VideoPlayerController _controller;

  File _postImage;
  File _postVideo;

  bool isPhoto = true;

  final _picker = ImagePicker();

  Post _newPost = Post();

  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text("New Post"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async{
              _newPost.userId = Utility.getUserId();
              try{
                Utility.showProgressAlertDialog(context, "Posting");
                File file;
                if(isPhoto){
                  file = _postImage;
                }else{
                  file = _postVideo;
                }
                print(p.extension(file.path));
                await widget.postController.createPost(post: _newPost, file: file, extension: p.extension(file.path));
                Navigator.of(context).pop();
                showSnackBar("Successfully posted");
                setState(() {
                  _newPost = Post();
                });
              }catch(error){
                Navigator.of(context).pop();
                showSnackBar("Something went wrong try again!");
              }
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isPhoto = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 4.0),
                      decoration: isPhoto ? BoxDecoration(
                        color: kAccentColor,
                        borderRadius: BorderRadius.circular(20.0)
                      ):null,
                      child: Text("Photo", style:TextStyle(color: isPhoto ? Colors.white : Colors.black38)),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isPhoto = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 4.0),
                      decoration: !isPhoto ? BoxDecoration(
                          color: kAccentColor,
                          borderRadius: BorderRadius.circular(20.0)
                      ):null,
                      child: Text("Video", style:TextStyle(color: !isPhoto ? Colors.white : Colors.black38)),
                    ),
                  ),
                ],
              ),
              isPhoto ? Card(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      _selectImage(context);
                    },
                    child: Container(
                      color: kBackgroundDark,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Select a picture to post",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Card(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      _pickVideo();
                    },
                    child: Container(
                      color: kBackgroundDark,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Select a video to post",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //       onTap: (){
              //         _pickVideo();
              //       },
              //       child: Text("Post a video", style: Theme.of(context).textTheme.headline5.copyWith(color:kPrimaryColor, fontWeight: FontWeight.bold),)),
              // ),
              Card(
                color: Colors.white,
                child: Container(
                  width: kScreenWidth(context),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add caption",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      TextField(
                        maxLength: 150,
                        maxLines: null,
                        onChanged: (value){
                          setState(() {
                            _newPost.caption = value;
                          });
                        },
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.go,
                      )
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Container(
                  width: kScreenWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select category",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black87),
                          ),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return _buildCategoriesDialog(context);
                                    });
                              },
                              child: Text("select",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(color: kPrimaryLightColor)))
                        ],
                      ),
                      _newPost.categoryId != null
                          ? Container(
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                color: kPrimaryColor,
                              ),
                              child: Text(
                                categories
                                    .firstWhere((element) =>
                                        element.id == _newPost.categoryId)
                                    .name,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
              _postImage != null ? Card(child: Container(
                width: kScreenWidth(context),
                padding: const EdgeInsets.all(8.0),
                child: Image.file(_postImage, fit: BoxFit.contain,),
              )):SizedBox(),
              _postVideo != null ? Card(child: Container(
                width: kScreenWidth(context),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller)),
                    _controller.value.isPlaying ?
                    IconButton(icon: Icon(Icons.pause_circle_filled, color: kPrimaryColor,size: 30,), onPressed: (){
                      setState(() {
                        _controller.pause();
                      });})
                        :IconButton(icon: Icon(Icons.play_circle_fill, color: kPrimaryColor, size: 30,), onPressed: (){
                          setState(() {
                            _controller.play();
                          });
                    })
                  ],
                ),
              )):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(20),
      content: Container(
        width: kScreenWidth(context),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _newPost.categoryId = categories[index].id;
                  });
                  print(_newPost.categoryId);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(categories[index].name),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: categories.length),
      ),
    );
  }

  void _selectImage(context) {
    // TODO: add permission to IOS
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        _pickImage(ImageSource.camera);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera, size: 40,),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, size: 40.0,),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  )
                ],
        )));
  }

  Future _pickImage(ImageSource imageSource) async{
    final pickedImage = await _picker.getImage(source: imageSource);
    setState(() {
      if (pickedImage != null) {
        _postImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
    _postVideo = null;
  }

  Future _pickVideo() async{
    final pickedVideo = await _picker.getVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedVideo != null) {
        // _postVideo = File(pickedVideo.path);
        _controller = VideoPlayerController.file(File(pickedVideo.path))..initialize().then((_){
          setState(() {
            _postVideo = File(pickedVideo.path);
          });
        });
        _controller.setLooping(true);
      } else {
        print('No image selected.');
      }
    });
    _postImage = null;
  }

  void showSnackBar(String s) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }
}
