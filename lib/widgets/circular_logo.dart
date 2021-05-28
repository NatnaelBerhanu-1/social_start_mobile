import 'package:flutter/material.dart';

class CircularLogoWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(
                Radius.circular(100)
            )
        ),
        child: Image.asset("assets/images/logo.png", fit: BoxFit.cover, width: 80));
  }
}