
class CheckoutModel {
  List<CheckoutItem> checkoutItems;
  double totalAmount;

  CheckoutModel(
      {this.checkoutItems,
      this.totalAmount});

  Map<String, dynamic> toJson(){

  }
}

class CheckoutItem{
  String itemName;
  int quantity;
  double itemPrice;

  CheckoutItem({this.itemName, this.quantity, this.itemPrice});

  Map<String, dynamic> toJson(){
    return {
      "name": itemName,
      "quantity": quantity,
      "price": itemPrice/quantity,
      "currency": "USD"
    };
  }
}