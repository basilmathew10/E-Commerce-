import 'dart:convert';
import 'dart:developer';
import 'package:ecommerceapp/Models/ProductModel.dart';
import 'package:ecommerceapp/Provider/cartprovider.dart';
import 'package:ecommerceapp/Screens/CartScreen.dart';
import 'package:ecommerceapp/Models/category_model.dart';
import 'package:ecommerceapp/Screens/CategoryProducts.dart';
import 'package:ecommerceapp/Screens/ProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import '../main.dart';
import 'OrderDetails.dart';
import 'package:http/http.dart 'as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:badges/badges.dart' as badges;

Future<List<CategoryModel>?>fetchCategory()async {
    try {
      final response = await http.post(Uri.parse('http://bootcamp.cyralearnings.com/getcategories.php'));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromMap(json))
            .toList();
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      log(e.toString());
    }
  }

                                                  Future<List<ProductModel>> fetchPost() async {
                                                    
                                                    final response =
                                                        await http.post(Uri.parse('http://bootcamp.cyralearnings.com/view_offerproducts.php'));
                                                        
                                                    if (response.statusCode == 200) {
                                                      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
                                                      return parsed.map<ProductModel>((json) => ProductModel.fromMap(json)).toList();
                                                    } else {
                                                      throw Exception('Failed to load album');
                                                    }
                                                  }

 

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
late Future<List<ProductModel>> futurePost;
late Future<List<CategoryModel>> futureCategory;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
    // futureCategory= fetchCategory();
  
  }
  @override
  Widget build(BuildContext context) {  

      return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'E-COMMERCE',
          style:TextStyle(color:Color.fromARGB(255, 238, 238, 242)),
        ),
              backgroundColor: Color.fromARGB(255, 4, 1, 36),

      ),
        
        drawer: Drawer(  
        
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        
        children: [
        
         Divider(
          height: 1,
          thickness: 1,
         ),
          SizedBox(
            height: 50,
          ),
                  
            Text(
                   "E-COMMERCE",
                    textAlign:TextAlign.center ,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: Color.fromARGB(255, 4, 1, 36),), 
                  ),
              SizedBox(
            height: 30,
          ),
                  Divider(
                    height: 2,
                    thickness: 2,
                  ),
        
                            SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size:30 ,
            ),
            title: const Text(
                    "Home",
                    style: TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 1, 36)),
                  ), 
                   trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
                  onTap: () {
                                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => MyHomePage(title: '',
                      
                      ),
                    ),
              );

                  },
          ),
          SizedBox(
            height: 10,
          ),
           ListTile(
              leading: badges.Badge(
                  showBadge:
                      //  true,
                      context.read<Cart>().getItems.isEmpty ? false : true,
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.grey,
                    // size: 15,
                  )),
              //const Icon(Icons.shopping_cart),
              title: const Text(
                'Cart page',
               style: TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 1, 36),),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
                    
                    
                 
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.book_online,
              size: 30,
            ),
            title: const Text(
                    "Order Deatils",
                    
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 1, 36),),
                  ),
                   trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => OrderDetails(),
                    ),
                  );
               },
          ),
                    SizedBox(
            height: 10,
          ),
                            Divider(
                    height: 2,
                    thickness: 2,
                  ),
         

          ListTile(
            leading: Icon( 
              Icons.power_settings_new_rounded,
              size: 30,
            ),
                        title: const Text(
                    "Logout",
                    
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 4, 1, 36),),
                  ),
                   trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
                  
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLoggedIn", false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(title: '',)),
                );
              },
            
          ),

                      Divider(
                    height: 1,
                    thickness: 1,
                  ),

        ],
      ),
       
    ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 80,
            child:
            
             FutureBuilder(
         future: fetchCategory(),
         builder: (context, snapshot) {
           if (snapshot.hasData) {
            //  log("length ==" + snapshot.data!.length.toString());
             return Container(
               height: 80,
               //  color: Colors.amber,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount:snapshot.data!.length,
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: InkWell(
                       onTap: () {
                        //  log("clicked");

                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) {
                             return Category_productsPage(
                               //  catid: ,catname: ,
                               catid: snapshot.data![index].id!,
                               catname: snapshot.data![index].category!,
                             );
                           },
                         ));
                       },
                       child: Container(
                         padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Color.fromARGB(37, 5, 2, 39),
                         ),
                         child: Center(
                           child: Text(
                             snapshot.data![index].category!,
                             // "Cateogry name",
                             style: TextStyle(
                                 // color: maincolor,
                                 fontSize: 15,
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                     ),
                   );
                 },
               ),
             );
           } else {
             return Center(child: CircularProgressIndicator());
           }
         }),
          ),
  
  Container(
            padding: EdgeInsets.all(16),
            child:
            Text(
              "Offer Products",
              style: TextStyle(
                  fontSize: 23,color: Color.fromARGB(255, 4, 1, 36), fontWeight: FontWeight.bold),
            ),
           
  ),
            //view products
            Expanded(
              child:
              
                                                        FutureBuilder<List<ProductModel>>(
                                                    future: futurePost,
                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return 
                                                        StaggeredGridView.countBuilder(
                                                          physics: BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                        crossAxisCount: 2,
                                                                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                                                        

                                                          itemCount: snapshot.data!.length,
                                                          itemBuilder: (BuildContext context,int index) {
                                                            final post= snapshot.data![index];
                                                            return Container(
                                                              margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                              padding:  EdgeInsets.all(20.0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(15.0),
                                                              ),
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
                                                                builder: (context) => ProductDetails(product: post,
                                                                id: post.id,
                                          name: post.prodname,
                                          image:"http://bootcamp.cyralearnings.com/products/${post.image}",
                                          price: post.price.toString(),
                                          description: post.description), 
                                                              ),
                                                            );
                                                          },
                                                          child: Image.network(
                                                            "http://bootcamp.cyralearnings.com/products/${post.image}",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),

                                                    Text(
                                                      "${snapshot.data![index].prodname}",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Rs:${snapshot.data![index].price}",
                                                        style: TextStyle(
                                                        color: Colors.red.shade900,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600),
                                                    ),
                            ],
                            ),
                          );
                    },
                      );

                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
          ),
        ],
      ),
    );
  }
}