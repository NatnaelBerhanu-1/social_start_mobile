import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/utils/constants.dart';
import 'package:video_player/video_player.dart';

class ViewContentPage extends StatefulWidget {
  static final String pageName = "viewContent";

  final Post post;
  ViewContentPage({this.post});

  @override
  _ViewContentPageState createState() => _ViewContentPageState();
}

class _ViewContentPageState extends State<ViewContentPage> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool loading = true;

  @override
  void initState() {
    _initializeVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
            child: widget.post.type == "picture"
                ? _buildImageWidget(context)
                : _buildVideo()));
  }

  _buildImageWidget(context) {
    return Image.network(
      widget.post.fileUrl,
      fit: BoxFit.fitWidth,
      width: kScreenWidth(context),
    );
  }

  _initializeVideo() async {
    print(widget.post.fileUrl);
    _videoPlayerController = VideoPlayerController.network(widget.post.fileUrl);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        showControls: true,
        autoPlay: false,
        placeholder: Container(
          color: Colors.black,
        ));
    setState(() {});
  }

  _buildVideo() {
    return _chewieController != null &&
            _chewieController.videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController)
        : Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
