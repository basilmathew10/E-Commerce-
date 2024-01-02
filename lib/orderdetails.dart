import 'dart:convert';
import 'dart:developer';
import 'package:ecommerceapp/orderdetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart 'as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
 Future<List<OrderModel>?> fetchOrderDetails(String username) async {
    try {
      log("username ==" + username.toString());
      final response = await http.post(
          Uri.parse('http://bootcamp.cyralearnings.com/get_orderdetails.php'),
          body: {'username': username});

// print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      log("order details ==" + e.toString());
    }
  }


class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String? username;

  void initState() {
    super.initState();
    _loadUsername();
  }
    void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });
    log("isloggedin = " + username.toString());
  }
  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "Order Details ",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
     body: FutureBuilder(
          future: fetchOrderDetails(username.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount:
                      // 2,
                      snapshot.data!.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    log(snapshot.data!.length.toString());
                    final order_details = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                          elevation: 0,
                          color: Color.fromARGB(15, 74, 20, 140),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ExpansionTile(
                              trailing: Icon(Icons.arrow_drop_down),
                              textColor: Colors.black,
                              collapsedTextColor: Colors.black,
                              iconColor: Colors.red,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      DateFormat.yMMMEd()
                                          .format(order_details.date),
                                      // "12-03-2023",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Text(order_details.paymentmethod.toString(),
                                      // "Online",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      order_details.totalamount.toString() +" /-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red.shade900,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              children: [
                                ListView.separated(
                                  itemCount: order_details.products.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(top: 25),
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                  ( BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: SizedBox(
                                          height: 100,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 80,
                                                width: 100,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(left: 9),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      // color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(20)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                                               "http://bootcamp.cyralearnings.com/products/${order_details.products[index].image}"
                                                              ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                    // child: Image.network(product.imagesUrl.first)
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Wrap(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          // "product name",
                                                          order_details.products[index].productname,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:FontWeight.w600,
                                                              color: Colors.grey.shade700),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8,right: 8),
                                                        child: Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              // "2000",
                                                              order_details.products[index].price.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:FontWeight.bold,
                                                                  color: Colors.red.shade900),
                                                            ),
                                                            Text(
                                                              // "2" +
                                                              order_details.products[index].quantity.toString() +" X",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:FontWeight.bold,
                                                                  color: Colors.green.shade900),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ])),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}