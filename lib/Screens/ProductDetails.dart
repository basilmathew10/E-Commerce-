import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:ecommerceapp/Models/ProductModel.dart';
import 'package:ecommerceapp/Provider/CartProvider.dart';
import 'package:ecommerceapp/Screens/CartScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ecommerceapp/Screens/HomeScreen.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {

  final String name, price, image, description;
  final int id;
  final ProductModel product;

  ProductDetails({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.id,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.prodname),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  "http://bootcamp.cyralearnings.com/products/${product.image}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.prodname,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs.${product.price}",
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                      SizedBox(
                            height: 35,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
                              // log("price ==" + double.parse(price).toString());

            var existingItemCart = context
                .read<Cart>()
                .getItems
                .firstWhereOrNull((element) => element.id == id);

            if (existingItemCart != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  content: Text(
                    "This item is already in the cart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              context.read<Cart>().addItem(id, name, double.parse(price), 1, image);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  content: Text(
                    "Added to cart!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black, // Use your desired color
            ),
            child: Center(
              child: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}