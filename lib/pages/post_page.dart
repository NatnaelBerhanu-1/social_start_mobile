import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_start/pages/new_post_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/helper.dart';

class _ButtonModel {
  final String title;
  final Function onPressed;

  _ButtonModel({@required this.title, @required this.onPressed});
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ImagePicker _picker = ImagePicker();
  List<_ButtonModel> _buttons = [];

  @override
  void initState() {
    _buttons = [
      _ButtonModel(
          title: "Take picture or video",
          onPressed: () => _takePictureOrVideo(context)),
      _ButtonModel(
          title: "Upload picture",
          onPressed: () =>
              _pickFile(imageSource: ImageSource.gallery, isVideo: false)),
      _ButtonModel(
          title: "Upload video",
          onPressed: () =>
              _pickFile(imageSource: ImageSource.gallery, isVideo: true)),
      _ButtonModel(
          title: "Upload video shorter than 45 seconds",
          onPressed: () => _pickFile(
              imageSource: ImageSource.gallery,
              isVideo: true,
              lessThan45: true)),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kScreenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buttons.map((e) => _postButtonItem(e)).toList(),
      ),
    );
  }

  Widget _postButtonItem(_ButtonModel btnModel) {
    return Container(
      width: kScreenWidth(context),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextButton(
        onPressed: () {
          btnModel.onPressed();
        },
        child: Text(
          btnModel.title,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  _takePictureOrVideo(BuildContext context) {
    Helper.showVideoOrPictureDialog(context,
        onImageSelected: () => _pickFile(imageSource: ImageSource.camera),
        onVideoSelected: () =>
            _pickFile(imageSource: ImageSource.camera, isVideo: true));
  }

  _pickFile(
      {ImageSource imageSource = ImageSource.gallery,
      isVideo = false,
      lessThan45 = false}) async {
    var _file;
    if (lessThan45) {
      _file = await _picker.getVideo(
          source: imageSource, maxDuration: Duration(seconds: 45));
    } else if (imageSource == ImageSource.gallery && !isVideo) {
      /// pick image from gallery
      _file = await _picker.getImage(source: imageSource);
    } else if (imageSource == ImageSource.gallery && isVideo) {
      /// pick video from gallery
      _file = await _picker.getVideo(source: imageSource);
    } else if (imageSource == ImageSource.camera && !isVideo) {
      /// take picture
      _file = await _picker.getImage(source: ImageSource.camera);
    } else if (imageSource == ImageSource.camera && isVideo) {
      /// take video
      _file = await _picker.getVideo(source: ImageSource.camera);
    }

    if (_file != null) {
      // check if video or audio
        Navigator.pushNamed(context, NewPostPage.pageName, arguments: {"isVideo": isVideo, "file": _file});
    }
  }
}
