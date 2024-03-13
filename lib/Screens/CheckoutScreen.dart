import 'dart:convert';
import 'dart:developer';
import 'package:ecommerceapp/Models/UserModel.dart';
import 'package:ecommerceapp/Provider/cartprovider.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerceapp/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerceapp/Models/UserModel.dart';
import 'package:ecommerceapp/Screens/Registration.dart';
   Future<UserModel?>fetchUser(String? username) async {
    try {
      final response = await http.post(Uri.parse('http://bootcamp.cyralearnings.com/get_user.php'),
          body: {'username': username.toString()});

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load User');
      }
    } catch (e) {
      log(e.toString());
    }
  }


class CheckoutPage extends StatefulWidget {
  List<CartProduct> cart;
  CheckoutPage({required this.cart});

 @override
   State<CheckoutPage> createState() => _CheckoutPageState();
 }

 class _CheckoutPageState extends State<CheckoutPage> {
  @override
    int selectedValue = 1;

  void initState() {
    super.initState();
    _loadUsername();
  }

  String? username;

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });
    log("isloggedin = " + username.toString());
  }

  orderPlace(
    List<CartProduct> cart,
    String amount,
    String paymentmethod,
    String date,
    String name,
    String address,
    String phone,
  ) async {
    try {
      String jsondata = jsonEncode(cart);
      // log('jsondata =${jsondata}');
// print(cart.toString());
      final vm = Provider.of<Cart>(context, listen: false);

      final response = await http.post(
          Uri.parse('http://bootcamp.cyralearnings.com/order.php'
              // Webservice.mainurl1 + "order.jsp"
              ),
          body: {
            "username": username,
            "amount": amount,
            "paymentmethod": paymentmethod,
            "date": date,
            "quantity": vm.count.toString(),
            "cart": jsondata,
            'name': name,
            "address": address,
            "phone": phone,
          });
// print(response.statusCode);
// print(amount);
// print(paymentmethod);
// print(date);
// print(vm.count.toString());
// print(jsondata);
// print(name);
// print(address);
// print(phone);
      if (response.statusCode == 200) {
        log(response.body);
        if (response.body.contains("Success")) {
          vm.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Text("YOUR ORDER SUCCESSFULLY COMPLETED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
          ));
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MyHomePage(title: '',);
            },
          ));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String? name, address, phone;
  String? paymentmethod = "Cash on delivery";
 


  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Cart>(context, listen: false);

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
          "CheckOut",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<UserModel?>(
                future: fetchUser(username.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    name=  snapshot.data!.name;
                    phone= snapshot.data!.phone;
                    address=  snapshot.data!.address;
                    
                    print(name.toString());                  

                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(name.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Phone : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Text(phone.toString())
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Address : ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    // color: Colors.amber,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      address.toString(),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ));
                  }
                  return const CircularProgressIndicator();
                }),
          ),
          SizedBox(
            height: 10,
          ),
          RadioListTile(
            activeColor: Colors.blue.shade900,
            value: 1,
            groupValue: selectedValue,
            onChanged: (int? value) {
              setState(() {
                selectedValue = value!;
                paymentmethod = 'Cash on delivery';
              });
            },
            title: const Text(
              'Cash On Delivery',
              style: TextStyle(fontFamily: "muli"),
            ),
            subtitle: const Text(
              'Pay Cash At Home',
              style: TextStyle(fontFamily: "muli"),
            ),
          ),
          RadioListTile(
            activeColor: Colors.blue.shade900,
            value: 2,
            groupValue: selectedValue,
            onChanged: (int? value) {
              setState(() {
                selectedValue = value!;
                paymentmethod = 'Online';
              });
            },
            title: const Text(
              'Pay Now',
            ),
            subtitle: const Text(
              'Online Payment',
            ),
          ),
        ],
      )),
       bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              String datetime = DateTime.now().toString();

              log(datetime.toString());
              // orderPlace(cart, amount, paymentmethod, date, name, address, phone)
              orderPlace(widget.cart, vm.totalPrice.toString(), paymentmethod!,
                  datetime, name!, address!, phone!);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.black),
              child: Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          )),
   );
  }
}