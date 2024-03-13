import 'dart:convert';

List<ProductModel> postFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromMap(x)));

class ProductModel {
  ProductModel({
    required this.id,
    required this.catId,
    required this.prodname,
    required this.price,
    required this.image,
    required this.description,


  });

   int id;
   int catId;
  String prodname;
  double price;
  String image;
  String description;


  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
          id: json["id"],
          catId: json["catid"],
      prodname: json["productname"],
        price: json["price"].toDouble(),
                image: json["image"],
        description: json["description"],

      );
}
