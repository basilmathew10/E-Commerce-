import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ecommerceapp/productdetails.dart';
import 'package:http/http.dart 'as http;
import 'package:ecommerceapp/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

Future<List<ProductModel>> fetchCatProducts(int catid) async {
    final response = await http.post(

        Uri.parse('http://bootcamp.cyralearnings.com/get_category_products.php'),
         body: {'catid': catid.toString()});

    // print("hiiiii"+response.statusCode.toString());
        
    if (response.statusCode == 200) {
          // print(response.body);

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ProductModel>((json) => ProductModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Failed to load category products');
    }
  }

class Category_productsPage extends StatefulWidget {
 String catname;
  int catid;
  Category_productsPage({required this.catid, required this.catname});
  @override
  State<Category_productsPage> createState() => _Category_productsPageState();
}

class _Category_productsPageState extends State<Category_productsPage> {
  @override
  Widget build(BuildContext context) {
    // log("catname = " + widget.catname.toString());
    // log("catid = " + widget.catid.toString());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.catname,
          // "Category name",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),

      body: FutureBuilder(
          future: fetchCatProducts(widget.catid),
          builder: (context, snapshot) {
            // print(snapshot.data!.length.toString());
            if (snapshot.hasData) {
// print(snapshot.data!.length);
              return StaggeredGridView.countBuilder(
                                  crossAxisCount: 2,
                    staggeredTileBuilder: (context) =>
                      const StaggeredTile.fit(1),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];


                    return InkWell(
                      onTap: () {
                       
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return DetailsPage(
                        //       id: procduct.id!,
                        //       name: procduct.productname!,
                        //       image: imageurl + procduct.image!,
                        //       price: procduct.price.toString(),
                        //       description: procduct.description!,
                        //     );
                        //   },
                        // ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                         child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails( product: product, 
                                         id: product.id,
                                          name: product.prodname,
                                          image:"http://bootcamp.cyralearnings.com/products/${product.image}",
                                          price: product.price.toString(),
                                          description: product.description),  
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      "http://bootcamp.cyralearnings.com/products/${product.image}",
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        product.prodname,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                           
                                            Text(
                                             "Rs:${product.price.toString()}",
                                              style: TextStyle(
                                                  color: Colors.red.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}