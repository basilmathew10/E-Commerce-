import 'package:ecommerceapp/Provider/cartprovider.dart';
import 'package:ecommerceapp/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceapp/Screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider<Cart>(
      create: (BuildContext context) =>  Cart(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-COMMERCE APP',
      theme: ThemeData(
       
        primarySwatch: Colors.grey,
      ),
      home: LoginPage(title: 'E-COMMERCE APP'),
    ));
  }
}