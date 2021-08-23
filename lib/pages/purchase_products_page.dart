import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/utils/revenue_cat_configs.dart';
import 'package:social_start/utils/service_locator.dart';

class PurchaseProductsPage extends StatefulWidget {
  static final String pageName = "purchaseProductsPage";
  @override
  _PurchaseProductsPageState createState() => _PurchaseProductsPageState();
}

class _PurchaseProductsPageState extends State<PurchaseProductsPage> {
  /// Is the API available on the device
  bool _available = true;
  // InAppPurchase _iab = InAppPurchase.instance;
  Future<Offerings> _offerings;
  Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _initialize();
    _offerings = Purchases.getOfferings();
    // _products = Purchases.getProducts(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]);
  }

  void _initialize() async {
    // _available = await _iab.isAvailable();
    //
    // if(!_available){
    //   print("In app not purchase available");
    // }else{
    //   print("In app purchase available");
    //   ProductDetailsResponse response = await _iab.queryProductDetails(['android.test.purchased'].toSet()).catchError((error){
    //     print(error);
    //   }).onError((error, stackTrace) {print(error); return null;});
    //   print("Await finished");
    //   print(response.productDetails);
    // }

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("NcnUDuckfSEmfDirHlKWBkOgzQOnCTvy");

    // try {
    //   Offerings offerings = await Purchases.getOfferings();
    //   if (offerings.current != null) {
    //     print(offerings.all);
    //   } else {
    //     print("Offering not found");
    //   }
    //   // print(products);
    // } on PlatformException catch (e) {
    //   print(e.message);
    // }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder(
          future: _offerings,
          builder: (context, AsyncSnapshot<Offerings> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              print("snapshot has data");
              var packages = snapshot.data.all["standard"].availablePackages;
              return ListView.builder(
                  itemCount: packages.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                        child: ListTile(
                          tileColor: Theme.of(context).backgroundColor,
                          onTap: () async {
                            await _makePurchase(packages[index]);
                          },
                          title: Text(packages[index].identifier +
                              " for " +
                              packages[index].product.priceString),
                        ),
                      ));
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              );
            }
          }),
      // FutureBuilder(
      //     future: _products,
      //     builder: (context, AsyncSnapshot<List<Product>> snapshot) {
      //       print("snapshot: ${snapshot.data}");
      //       if (snapshot.hasData) {
      //         var products = snapshot.data;
      //         return ListView.builder(
      //             itemCount: products.length,
      //             shrinkWrap: true,
      //             itemBuilder: (context, index) => Container(
      //               margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      //               child: ListTile(
      //                 tileColor: Theme.of(context).backgroundColor,
      //                 onTap: ()async{
      //                   await _purchaseProduct(products[index].identifier);
      //                 },
      //                 title: Text(
      //                     products[index].identifier +
      //                         " for " +
      //                         products[index].priceString),
      //               ),
      //             ));
      //       } else {
      //         return Center(
      //           child: CircularProgressIndicator(
      //             color: Theme.of(context).accentColor,
      //           ),
      //         );
      //       }
      //     }),
    ]);
  }

  Future<void> _purchaseProduct(String productID) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchaseProduct(productID);
      print("Purchase successful");
      var isPro =
          purchaserInfo.entitlements.all["my_entitlement_identifier"].isActive;
      if (isPro) {
        // Unlock that great "pro" content
        // puchaseSuccessfull;
      }
    } on PlatformException catch (e) {
      print(e);
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("purchase cancelled");
        print(e);
      }
    }
  }

  Future<void> _makePurchase(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      print("Purchase successful");
      var productDetail = RevenueCatConfigs.packagesInfo[package.identifier];
      if (productDetail["isSubscription"]) {
        // add subsription to user
        getIt<UserController>().addSubscription(SubscriptionDetail(
            entitlementId: productDetail["entitlement_id"],
            socialPoint: productDetail["socialPoints"],
            subscribedAt: Timestamp.now(),
            updatedAt: Timestamp.now()));
      } else {
        // add social point to user
        getIt<UserController>()
            .purchaseSocialPoint(productDetail["socialPoints"]);
      }

      // var isPro = purchaserInfo.entitlements.all["my_entitlement_identifier"].isActive;
      // if (isPro) {
      //   // Unlock that great "pro" content
      //   puchaseSuccessfull;
      // }
    } on PlatformException catch (e, stk) {
      print(e);
      print(stk);
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("purchase cancelled");
        print(e);
      }
    }
  }
}
