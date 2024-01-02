import 'dart:convert';

List<CategoryModel> postFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromMap(x)));

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.category,
   


  });
int? id;
String? category;
  


  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
          id: json["id"],
          category: json["category"],
      

      );

  
}
