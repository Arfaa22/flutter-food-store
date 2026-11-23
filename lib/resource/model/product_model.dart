import 'package:flutter_application_1/resource/model/category_model.dart';
import 'package:flutter_application_1/resource/model/rating_model.dart';

class ProductModel {
  final int? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? image;
  final int? price;
  final int? weight;
  final int? categoryId;
  final CategoryModel? category;
  final List<RatingModel>? ratings;
  final dynamic ratingsAvgRating;

  ProductModel({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.price,
    this.weight,
    this.categoryId,
    this.category,
    this.ratings,
    this.ratingsAvgRating,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      title: map['title'],
      slug: map['slug'],
      description: map['description'],
      image: map['image'],
      price: map['price'] is String ? int.tryParse(map['price']) : map['price'],
      weight: map['weight'] is String
          ? int.tryParse(map['weight'])
          : map['weight'],
      categoryId: map['category_id'] is String
          ? int.tryParse(map['category_id'])
          : map['category_id'],
      category: map['category'] != null
          ? CategoryModel.fromMap(map['category'])
          : null,
      ratings: map['ratings'] != null
          ? List<RatingModel>.from(
              map['ratings'].map((x) => RatingModel.fromMap(x)),
            )
          : [],
      ratingsAvgRating: map['ratings_avg_rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "slug": slug,
    "description": description,
    "image": image,
    "price": price,
    "weight": weight,
    "category_id": categoryId,
  };
}
