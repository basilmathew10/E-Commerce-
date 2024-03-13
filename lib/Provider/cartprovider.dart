import 'dart:developer';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  final List<CartProduct> list = [];
  List<CartProduct> get getItems {
    return list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in list) {
      total = total + (item.price * item.qty);
    }
    return total;
  }

  int? get count {
    return list.length;
  }

  void addItem(
    int id,
    String name,
    double price,
    int qty,
    String imagesUrl,
  ) {
    final product = CartProduct(
      id: id,
      name: name,
      price: price,
      qty: qty,
      imagesUrl: imagesUrl,
    );
    list.add(product);
    notifyListeners();
    log("add product  !!!!!!!!!!!!!!!");
  }

  void increment(CartProduct product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(CartProduct product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(CartProduct product) {
    list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    list.clear();
    notifyListeners();
  }
}

class CartProduct {
  int id;
  String name;
  double price;
  int qty ;
  String imagesUrl;

  CartProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.imagesUrl,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        imagesUrl: json["image"],
        qty: json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": imagesUrl,
        "qty": qty,
      };
  void increase() {
    qty++;
    //  qty = qty + 1;
  }

  void decrease() {
    qty--;
    //qty = qty - 1;
  }
}
