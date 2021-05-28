import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/utils/constants.dart';

class PostItem extends StatefulWidget {
  final double padding;
  final Post post;
  PostItem({@required this.padding, @required this.post}):assert(padding!=null);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(widget.padding),
      margin: EdgeInsets.symmetric(vertical:8.0),
      child: Column(
        children: [
          _buildTop(),
          Container(
            color: Colors.black45,
            width: kScreenWidth(context),
            constraints: BoxConstraints(
              maxHeight: 400
            ),
            child: Center(
              child: CachedNetworkImage(
                width: kScreenWidth(context),
                fit: BoxFit.contain,
              imageUrl: widget.post.fileUrl,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),

                ),
            ),
          ),
          _buildBottom(),
          Divider(height: 5.0,color: Colors.black12,)
        ],
      ),
    );
  }

  Widget _buildTop(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/images/sample_profile_pic.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                '200 followers',
                style: TextStyle(fontSize: 12.0, color: kPrimaryLightColor),
              )
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(child: Text('follow +', style: TextStyle(color: kAccentColor),))))
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildPostActions(Icons.favorite_outline, "123", (){print("like pressed");}),
            SizedBox(width: 10,),
            _buildPostActions(Icons.mode_comment_outlined, "123", (){print("comment pressed");}),
              // SizedBox(width: 10,),
              // _buildPostActions(Icons.visibility, "123", (){print("view pressed");}),
              Expanded(child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '123 views',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor),
                ),
              ))
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildPostActions(IconData icon, String label, Function onPressed) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: kPrimaryColor,
          ),
          SizedBox(width: 3,),
          Text(
            '$label',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
