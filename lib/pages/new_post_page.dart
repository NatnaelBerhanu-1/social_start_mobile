import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:social_start/controllers/post_controller.dart';
import 'package:social_start/models/category.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/services/firebase_services.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/widgets/custom_appbar.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class NewPostPage extends StatefulWidget {
  static final String pageName = "newPost";

  final bool isVideo;
  final dynamic file;

  NewPostPage({@required this.isVideo, @required this.file});

  // final FirebaseServices firebaseServices;
  // NewPostPage({@required this.firebaseServices});
  PostController postController = PostController();

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  VideoPlayerController _controller;
  TextEditingController _textFieldController = TextEditingController();

  File _postImage;
  File _postVideo;

  bool isPhoto = true;

  final _picker = ImagePicker();

  Post _newPost = Post();

  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Category selectedCategory;

  @override
  void initState() {
    if (widget.isVideo) {
      _setupVideoController(widget.file.path);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "New Post",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).textTheme.bodyText2.color),
          actions: [
            IconButton(
                onPressed: () {
                  _postContent();
                },
                icon: Icon(Icons.check,
                    color: Theme.of(context).textTheme.bodyText2.color))
          ],
          elevation: 1.0,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           isPhoto = true;
                    //           _newPost.type = "picture";
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 8.0, vertical: 4.0),
                    //         decoration: isPhoto
                    //             ? BoxDecoration(
                    //                 color: kAccentColor,
                    //                 borderRadius: BorderRadius.circular(6.0))
                    //             : null,
                    //         child: Text("Photo",
                    //             style: TextStyle(
                    //                 color: isPhoto
                    //                     ? Colors.white
                    //                     : Colors.black38)),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           isPhoto = false;
                    //           _newPost.type = "video";
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 8.0, vertical: 4.0),
                    //         decoration: !isPhoto
                    //             ? BoxDecoration(
                    //                 color: kAccentColor,
                    //                 borderRadius: BorderRadius.circular(6.0))
                    //             : null,
                    //         child: Text("Video",
                    //             style: TextStyle(
                    //                 color: !isPhoto
                    //                     ? Colors.white
                    //                     : Theme.of(context)
                    //                         .textTheme
                    //                         .bodyText2
                    //                         .color)),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // isPhoto
                    //     ? Card(
                    //         color: Theme.of(context).backgroundColor,
                    //         child: Container(
                    //           padding: EdgeInsets.all(8.0),
                    //           height: 100,
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               _selectImage(context);
                    //             },
                    //             child: Container(
                    //               color: kBackgroundDark,
                    //               child: Center(
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Icon(
                    //                       Icons.photo,
                    //                       color: Colors.white,
                    //                       size: 30,
                    //                     ),
                    //                     Text(
                    //                       "Select a picture to post",
                    //                       style: TextStyle(color: Colors.white),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Card(
                    //         color: Theme.of(context).backgroundColor,
                    //         child: Container(
                    //           padding: EdgeInsets.all(8.0),
                    //           height: 100,
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               _pickVideo();
                    //             },
                    //             child: Container(
                    //               color: kBackgroundDark,
                    //               child: Center(
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Icon(
                    //                       Icons.photo,
                    //                       color: Colors.white,
                    //                       size: 30,
                    //                     ),
                    //                     Text(
                    //                       "Select a video to post",
                    //                       style: TextStyle(color: Colors.white),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: GestureDetector(
                    //       onTap: (){
                    //         _pickVideo();
                    //       },
                    //       child: Text("Post a video", style: Theme.of(context).textTheme.headline5.copyWith(color:kPrimaryColor, fontWeight: FontWeight.bold),)),
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          child: !widget.isVideo
                              ? Image.file(File(widget.file.path))
                              : VideoPlayer(_controller),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                            maxLength: 150,
                            maxLines: null,
                            decoration: InputDecoration(
                                helperStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                ),
                                hintText: "Add caption",
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: null,
                                disabledBorder: null),
                            controller: _textFieldController,
                            onChanged: (value) {
                              setState(() {
                                _newPost.caption = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    // Container(
                    //   width: kScreenWidth(context),
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Add caption",
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .headline5
                    //             .copyWith(
                    //                 color: Theme.of(context)
                    //                     .textTheme
                    //                     .bodyText2
                    //                     .color),
                    //       ),
                    //       TextField(
                    //         maxLength: 150,
                    //         maxLines: null,
                    //         style: TextStyle(
                    //           color:
                    //               Theme.of(context).textTheme.bodyText2.color,
                    //         ),
                    //         decoration: InputDecoration(
                    //             helperStyle: TextStyle(
                    //           color:
                    //               Theme.of(context).textTheme.bodyText2.color,
                    //         )),
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _newPost.caption = value;
                    //           });
                    //         },
                    //         textInputAction: TextInputAction.go,
                    //         controller: _textFieldController,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Container(
                      width: kScreenWidth(context),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    var categoryDialog =
                                        await _buildCategoriesDialog(context);
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return categoryDialog;
                                        });
                                  },
                                  child: Text("select",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor)))
                            ],
                          ),
                          _newPost.categoryId != null
                              ? Container(
                                  margin: EdgeInsets.only(top: 8.0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        selectedCategory.name,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedCategory = null;
                                            _newPost.categoryId = null;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    // _postImage != null
                    //     ? Card(
                    //         child: Container(
                    //         width: kScreenWidth(context),
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Image.file(
                    //           _postImage,
                    //           fit: BoxFit.contain,
                    //         ),
                    //       ))
                    //     : SizedBox(),
                    // _postVideo != null
                    //     ? Card(
                    //         child: Container(
                    //         width: kScreenWidth(context),
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           children: [
                    //             AspectRatio(
                    //                 aspectRatio: _controller.value.aspectRatio,
                    //                 child: VideoPlayer(_controller)),
                    //             _controller.value.isPlaying
                    //                 ? IconButton(
                    //                     icon: Icon(
                    //                       Icons.pause_circle_filled,
                    //                       color: Theme.of(context).primaryColor,
                    //                       size: 30,
                    //                     ),
                    //                     onPressed: () {
                    //                       setState(() {
                    //                         _controller.pause();
                    //                       });
                    //                     })
                    //                 : IconButton(
                    //                     icon: Icon(
                    //                       Icons.play_circle_fill,
                    //                       color: Theme.of(context).primaryColor,
                    //                       size: 30,
                    //                     ),
                    //                     onPressed: () {
                    //                       setState(() {
                    //                         _controller.play();
                    //                       });
                    //                     })
                    //           ],
                    //         ),
                    //       ))
                    //     : SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _postContent() async {
    if (_newPost.categoryId == null) {
      showSnackBar("Select category");
      return;
    } else if (_newPost.caption == null || _newPost.caption.isEmpty) {
      showSnackBar("Enter caption");
      return;
    }
    try {
      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      _newPost.userId = Utility.getUserId();
      _newPost.lat = _locationData.latitude;
      _newPost.long = _locationData.longitude;
      if (widget.isVideo) {
        _newPost.type = "video";
      } else {
        _newPost.type = "picture";
      }
      Utility.showProgressAlertDialog(context, "Posting");
      // File file;
      // if (isPhoto) {
      //   file = _postImage;
      // } else {
      //   file = _postVideo;
      // }
      print(p.extension(widget.file.path));
      await widget.postController.createPost(
          post: _newPost,
          file: File(widget.file.path),
          extension: p.extension(widget.file.path));
      Navigator.of(context).pop();
      showSnackBar("Successfully posted");
      // setState(() {
      //   _newPost = Post();
      //   _postImage = null;
      //   _postVideo = null;
      //   _textFieldController.clear();
      // });
      Navigator.pop(context);
    } catch (error, stk) {
      Navigator.of(context).pop();
      print(error);
      print(stk);
      showSnackBar("Something went wrong try again!");
    }
  }

  Future<Widget> _buildCategoriesDialog(BuildContext context) async {
    Future<QuerySnapshot> categoriesRef =
        FirebaseFirestore.instance.collection("categories").get();
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      insetPadding: EdgeInsets.all(20),
      content: Container(
        width: kScreenWidth(context),
        child: FutureBuilder(
            future: categoriesRef,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = snapshot.data.docs.map((e) {
                  Category category = Category();
                  category.id = e.id;
                  category.name = e.get("name");
                  return category;
                }).toList();
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = categories[index];
                            _newPost.categoryId = categories[index].id;
                          });
                          print(_newPost.categoryId);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            categories[index].name,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: categories.length);
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  void _selectImage(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 40,
                        ),
                        Text("Camera")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          size: 40.0,
                        ),
                        Text("Gallery")
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  Future _pickImage(ImageSource imageSource) async {
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

  Future _setupVideoController(path) async {
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {
          _postVideo = File(path);
        });
      });
  }

  Future _pickVideo() async {
    final pickedVideo = await _picker.getVideo(
        source: ImageSource.gallery, maxDuration: Duration(seconds: 45));
    setState(() {
      if (pickedVideo != null) {
        // _postVideo = File(pickedVideo.path);
        _controller = VideoPlayerController.file(File(pickedVideo.path))
          ..initialize().then((_) {
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
