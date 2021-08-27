import 'dart:core';
import 'package:flutter/material.dart';
import 'package:social_start/models/checkout.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/utils/service_locator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/paypal_service.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final CheckoutModel checkoutModel;

  PaypalPayment({this.onFinish, @required this.checkoutModel});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  UserController _userController = getIt<UserController>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalService services = PaypalService();

  // you can change default currency according to your need
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        print("orderparams:" + (await getOrderParams()).toString());
        final transactions = await getOrderParams();
        print("transactions: " + transactions.toString());
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e,stc) {
        print('exception: '+e.toString());
        print(stc);
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Navigator.pop(context);
      }
    });
  }

  // item name, price and quantity
  // String itemName = 'iPhone X';
  // String itemPrice = '1.99';
  // int quantity = 1;

  Future<Map<String, dynamic>> getOrderParams() async {
    List items = widget.checkoutModel.checkoutItems.map((e) => e.toJson()).toList();
    User user = await _userController.getUser();
    double total = 0;
    widget.checkoutModel.checkoutItems.forEach((element) {
      total += element.itemPrice;
      print(element.quantity);
    });
    print("total: $total");
    // checkout invoice details
    String totalAmount = '${widget.checkoutModel.totalAmount}';
    String subTotalAmount = totalAmount;
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = '${user.firstName}';
    String userLastName = '${user.lastName}';
    String addressCity = '-----';
    String addressStreet = '------';
    String addressZipCode = '------';
    String addressCountry = '-------';
    String addressState = '-------';
    String addressPhoneNumber = '--------';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount":
              ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping &&
                isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName +
                    " " +
                    userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            print(request.url);
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              print("payment: $uri payerId: $payerID");
              if (payerID != null) {
                services
                    .executePayment(Uri.parse(executeUrl), payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                });
              } else {
                // Navigator.of(context).pop();
              }
              // Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}