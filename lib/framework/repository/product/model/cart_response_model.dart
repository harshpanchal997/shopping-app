// To parse this JSON data, do
//
//     final cartResponseModel = cartResponseModelFromJson(jsonString);

import 'dart:convert';

List<CartResponseModel> cartResponseModelFromJson(String str) => List<CartResponseModel>.from(json.decode(str).map((x) => CartResponseModel.fromJson(x)));

String cartResponseModelToJson(List<CartResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponseModel {
  CartResponseModel({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.price,
    this.featuredImage,
    this.status,
    this.quantity,
    this.createdAt,
  });

  int? id;
  String? slug;
  String? title;
  String? description;
  int? price;
  String? featuredImage;
  String? status;
  int? quantity;
  String? createdAt;

  factory CartResponseModel.fromJson(Map<String, dynamic> json) => CartResponseModel(
    id: json["id"] == null ? null : json["id"],
    slug: json["slug"] == null ? null : json["slug"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"],
    featuredImage: json["featured_image"] == null ? null : json["featured_image"],
    status: json["status"] == null ? null : json["status"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "slug": slug == null ? null : slug,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "price": price == null ? null : price,
    "featured_image": featuredImage == null ? null : featuredImage,
    "status": status == null ? null : status,
    "quantity": quantity == null ? null : quantity,
    "created_at": createdAt == null ? null : createdAt,
  };
}
