import 'package:flutter/material.dart';
import 'package:social_start/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData actionIcon;
  final Function actionPressed;
  bool showBackArrow = true;
  CustomAppBar({@required this.title, this.actionIcon, this.actionPressed, this.showBackArrow = true});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.0
          )
        )
      ),
      child: Row(
        children:[
      showBackArrow ?IconButton(
            padding: EdgeInsets.all(10),
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon:
            Icon(
              Icons.arrow_back,
              size: 20,
            ),
          ): SizedBox(width: 20,),
          Expanded(
            child: Center(child: Text('$title', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),))
          ),
          actionIcon == null ? SizedBox(
            width: 40,
          ): IconButton(icon: Icon(actionIcon,), onPressed: actionPressed),
        ],
      ),
    );
  }
}