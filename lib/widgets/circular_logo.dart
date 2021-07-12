import 'package:flutter/material.dart';

class CircularLogoWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(100)
            )
        ),
        child: Image.asset("assets/images/logo.png", fit: BoxFit.cover, width: 80));
  }
}