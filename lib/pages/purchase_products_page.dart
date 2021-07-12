import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseProductsPage extends StatefulWidget{
  static final String pageName = "purchaseProductsPage";
  @override
  _PurchaseProductsPageState createState() => _PurchaseProductsPageState();
}

class _PurchaseProductsPageState extends State<PurchaseProductsPage> {
  /// Is the API available on the device
  bool _available = true;
  InAppPurchase _iab = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _available = await _iab.isAvailable();

    if(!_available){
      print("In app not purchase available");
      _available = await _iab.isAvailable();
      print("Await finished");
      if(!_available){
        print("In app purchase not available");
      }else{
        print("In app purchase Available");
      }
    }else{
      print("In app purchase available");
    }
  }

  @override
  void dispose() async{
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("App"),
      ),
    );
  }
}


