import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/checkout.dart';
import 'package:social_start/pages/paypal_payment_page.dart';
import 'package:social_start/utils/constants.dart';
import 'package:social_start/utils/utility.dart';
import 'package:social_start/widgets/custom_appbar.dart';

class PurchaseSocialPointPage extends StatefulWidget {
  static final String pageName = "purchaseSocialPoint";

  @override
  _PurchaseSocialPointPageState createState() =>
      _PurchaseSocialPointPageState();
}

class _PurchaseSocialPointPageState extends State<PurchaseSocialPointPage> {
  UserController _userController = UserController();
  double totalPrice =  0.0;
  int amount = 0;

  var priceFuture;
  @override
  void initState() {
    priceFuture = FirebaseFirestore.instance.collection("config").get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(title: "PurchaseSocialPoint"),
            Expanded(
              child: FutureBuilder(
                  future: priceFuture,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    print(snapshot.hasData);
                    if (snapshot.hasData) {
                      print("snapshot: ${snapshot.data.docs}");
                      var priceEntry = snapshot.data.docs.firstWhere((element) {
                        print("element $element");
                        return element.get('name') == 'social_point_price';
                      });
                      print(priceEntry.get("value"));
                      double singlePrice = double.parse(priceEntry.get("value"));

                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "\$${singlePrice * amount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 34.0, color: kPrimaryColor),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: IconButton(padding: EdgeInsets.zero,onPressed: (){
                                  setState(() {
                                    if(amount > 1){
                                      amount--;
                                      totalPrice = amount * singlePrice;
                                    }
                                  });
                                }, icon: Icon(Icons.horizontal_rule, size: 30, color: kPrimaryColor,))),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('$amount', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24.0),),
                                ),
                                Center(child: IconButton(padding: EdgeInsets.zero,onPressed: (){
                                  setState(() {
                                    amount++;
                                    totalPrice = amount * singlePrice;
                                  });
                                }, icon: Icon(Icons.add, size: 30, color: kPrimaryColor,))),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            TextButton(onPressed: () async{
                              if(amount == 0){
                                Utility.showSnackBar(context, "Amount must be greater than 0");
                                return;
                              }
                              var checkOutModel = CheckoutModel(checkoutItems: [CheckoutItem(quantity: amount, itemPrice: totalPrice,itemName: 'SocialPoint')], totalAmount: totalPrice);
                              print("CheckOutModel: ${checkOutModel.totalAmount}");
                              await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => PaypalPayment(
                                    onFinish: (number) async {
                                      print("Order id: $number");
                                      if (number != null) {
                                        Utility.showProgressAlertDialog(context, "Please wait");
                                        _userController
                                        .purchaseSocialPoint(amount)
                                            .onError((error, stackTrace) {
                                          Navigator.of(context).pop();
                                          Utility.showSnackBar(
                                              context, "Purchase failed, try again");
                                        }).then((value) {
                                          Navigator.of(context).pop();
                                          Utility.showSnackBar(
                                              context, "Purchase successful");
                                        });
                                      } else {
                                        Utility.showSnackBar(
                                            context, "Purchase failed, try again");
                                      }
                                    },
                                    checkoutModel: checkOutModel,
                                  )));
                              Navigator.of(context).pop();
                            }, child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                  color: kAccentColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text('Continue', style: TextStyle(color: Colors.white),),
                            ))
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Somthing went wrong"),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
